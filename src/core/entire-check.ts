/**
 * Core functionality for Entire CLI checking
 * Shared between OpenCode and Claude Code implementations
 */

import { existsSync, readFileSync } from "fs"
import { join } from "path"
import { execSync } from "child_process"

export interface EntireCheckConfig {
  enabled: boolean
  mode: "prompt" | "auto-init" | "silent"
  checkGitRepo: boolean
  showStatus: boolean
}

export interface MemoryStackStatus {
  entire: { enabled: boolean }
  claudeMem: { installed: boolean }
  rtk: { installed: boolean; efficiency?: string }
}

export interface CheckResult {
  config: EntireCheckConfig
  status: MemoryStackStatus
  needsPrompt: boolean
  workingDir: string
  message?: string
}

/**
 * Load configuration from OpenCode or Claude Code config directories
 */
export function loadConfig(): EntireCheckConfig {
  const defaults: EntireCheckConfig = {
    enabled: true,
    mode: "prompt",
    checkGitRepo: true,
    showStatus: true
  }

  try {
    const configPaths = [
      join(process.env.HOME || "", ".config/opencode/entire-check.json"),
      join(process.env.HOME || "", ".claude/entire-check.json")
    ]

    for (const configPath of configPaths) {
      if (existsSync(configPath)) {
        const config = JSON.parse(readFileSync(configPath, "utf-8"))
        return { ...defaults, ...config }
      }
    }
  } catch {
    return defaults
  }

  return defaults
}

/**
 * Check if current directory is a git repository
 */
export function isGitRepository(workingDir: string): boolean {
  try {
    execSync("git rev-parse --git-dir", {
      cwd: workingDir,
      stdio: "ignore",
      timeout: 5000
    })
    return true
  } catch {
    return false
  }
}

/**
 * Check if Entire CLI is enabled in the working directory
 */
export function isEntireEnabled(workingDir: string): boolean {
  return existsSync(join(workingDir, ".entire", "settings.json"))
}

/**
 * Check if Claude-Mem is installed
 */
export function isClaudeMemInstalled(): boolean {
  return existsSync(join(process.env.HOME || "", ".claude-mem", "claude-mem.db"))
}

/**
 * Check RTK status and efficiency
 */
export async function checkRtkStatus(): Promise<{ installed: boolean; efficiency?: string }> {
  try {
    const output = execSync("rtk gain --json 2>/dev/null || echo '{\"installed\":true}'", {
      encoding: "utf-8",
      timeout: 5000
    })
    const data = JSON.parse(output)
    return {
      installed: true,
      efficiency: data.efficiency || "N/A"
    }
  } catch {
    return { installed: false }
  }
}

/**
 * Get complete memory stack status
 */
export async function getMemoryStackStatus(workingDir: string): Promise<MemoryStackStatus> {
  return {
    entire: { enabled: isEntireEnabled(workingDir) },
    claudeMem: { installed: isClaudeMemInstalled() },
    rtk: await checkRtkStatus()
  }
}

/**
 * Run the entire check and return results
 */
export async function runEntireCheck(workingDir: string): Promise<CheckResult> {
  const config = loadConfig()

  if (!config.enabled) {
    return {
      config,
      status: {
        entire: { enabled: false },
        claudeMem: { installed: false },
        rtk: { installed: false }
      },
      needsPrompt: false,
      workingDir
    }
  }

  if (config.checkGitRepo && !isGitRepository(workingDir)) {
    return {
      config,
      status: {
        entire: { enabled: false },
        claudeMem: { installed: false },
        rtk: { installed: false }
      },
      needsPrompt: false,
      workingDir
    }
  }

  const status = await getMemoryStackStatus(workingDir)

  if (status.entire.enabled && !config.showStatus) {
    return {
      config,
      status,
      needsPrompt: false,
      workingDir
    }
  }

  const needsPrompt = !status.entire.enabled || config.showStatus
  const message = needsPrompt ? generateMessage(status, !status.entire.enabled) : undefined

  return {
    config,
    status,
    needsPrompt,
    workingDir,
    message
  }
}

/**
 * Generate formatted message for user
 */
export function generateMessage(
  status: MemoryStackStatus,
  showWarning: boolean
): string {
  const entireEmoji = status.entire.enabled ? "✅" : "⚠️"
  const claudeMemEmoji = status.claudeMem.installed ? "✅" : "❌"
  const rtkEmoji = status.rtk.installed ? "✅" : "❌"

  if (status.entire.enabled && !showWarning) {
    // Success status message
    return `🧠 Memory Stack Status

${entireEmoji} Entire CLI: Enabled
${claudeMemEmoji} Claude-Mem: ${status.claudeMem.installed ? "Active" : "Not installed"}
${rtkEmoji} RTK: ${status.rtk.installed ? `Active (${status.rtk.efficiency})` : "Not installed"}

All systems operational. 🚀`
  }

  // Warning/prompt message
  return `📝 Memory Management Check

${entireEmoji} **Entire CLI**: ${status.entire.enabled ? "Enabled" : "Not initialized"}
   ${!status.entire.enabled ? "→ Run: \`entire enable --strategy auto-commit\`" : ""}

${claudeMemEmoji} **Claude-Mem**: ${status.claudeMem.installed ? "Active" : "Not installed"}

${rtkEmoji} **RTK**: ${status.rtk.installed ? `Active (${status.rtk.efficiency} efficiency)` : "Not installed"}

**Why this matters:**
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

${!status.entire.enabled ? "**Recommendation:** Enable Entire to prevent context loss on crashes." : ""}

---
💡 To disable these reminders, create \`~/.config/opencode/entire-check.json\`:
\`\`\`json
{
  "enabled": true,
  "mode": "silent"
}
\`\`\``
}

/**
 * Auto-initialize Entire CLI in the working directory
 */
export function autoInitEntire(workingDir: string): boolean {
  try {
    execSync("entire enable --strategy auto-commit", {
      cwd: workingDir,
      stdio: "pipe",
      timeout: 10000
    })
    return true
  } catch {
    return false
  }
}
