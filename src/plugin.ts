import type { Hooks, PluginInput } from "@opencode-ai/plugin"
import { existsSync } from "fs"
import { join } from "path"
import { execSync } from "child_process"

interface EntireCheckConfig {
  enabled: boolean
  mode: "prompt" | "auto-init" | "silent"
  checkGitRepo: boolean
  showStatus: boolean
}

function loadConfig(): EntireCheckConfig {
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
        const config = JSON.parse(require("fs").readFileSync(configPath, "utf-8"))
        return { ...defaults, ...config }
      }
    }
  } catch {
    return defaults
  }

  return defaults
}

function isGitRepository(workingDir: string): boolean {
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

function isEntireEnabled(workingDir: string): boolean {
  return existsSync(join(workingDir, ".entire", "settings.json"))
}

function isClaudeMemInstalled(): boolean {
  return existsSync(join(process.env.HOME || "", ".claude-mem", "claude-mem.db"))
}

async function checkRtkStatus(): Promise<{ installed: boolean; efficiency?: string }> {
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

export async function createPlugin(context: PluginInput): Promise<Hooks> {
  const config = loadConfig()

  if (!config.enabled) {
    return {}
  }

  return {
    event: async ({ event }: { event: any }) => {
      if (event.type !== "session.created") {
        return
      }

      const sessionID = (event.properties as any).id
      const workingDir = (event.properties as any).workingDir || process.cwd()

      if (config.checkGitRepo && !isGitRepository(workingDir)) {
        return
      }

      const entireEnabled = isEntireEnabled(workingDir)
      
      if (entireEnabled && !config.showStatus) {
        return
      }

      const claudeMemInstalled = isClaudeMemInstalled()
      const rtkStatus = await checkRtkStatus()

      if (!entireEnabled) {
        switch (config.mode) {
          case "auto-init":
            try {
              execSync("entire enable --strategy auto-commit", {
                cwd: workingDir,
                stdio: "pipe",
                timeout: 10000
              })
              
              await context.client.session.prompt({
                path: { id: sessionID },
                body: {
                  parts: [{
                    type: "text",
                    text: `Entire CLI auto-initialized in this repository. Session persistence is now active. Checkpoints will be created automatically.`
                  }]
                }
              })
            } catch {
              await promptUser(context, sessionID, entireEnabled, claudeMemInstalled, rtkStatus)
            }
            break

          case "prompt":
            await promptUser(context, sessionID, entireEnabled, claudeMemInstalled, rtkStatus)
            break

          case "silent":
            console.log(`[entire-check] Entire not enabled in ${workingDir}`)
            break
        }
      } else if (config.showStatus) {
        await showStatus(context, sessionID, entireEnabled, claudeMemInstalled, rtkStatus)
      }
    }
  }
}

async function promptUser(
  context: PluginInput, 
  sessionID: string, 
  entireEnabled: boolean,
  claudeMemInstalled: boolean,
  rtkStatus: { installed: boolean; efficiency?: string }
): Promise<void> {
  const entireStatus = entireEnabled ? "✅" : "⚠️"
  const claudeMemStatus = claudeMemInstalled ? "✅" : "❌"
  const rtkIndicator = rtkStatus.installed ? `✅ (${rtkStatus.efficiency} efficiency)` : "❌"

  const message = `📝 Memory Management Check

${entireStatus} **Entire CLI**: ${entireEnabled ? "Enabled" : "Not initialized"}
   ${!entireEnabled ? "→ Run: \`entire enable --strategy auto-commit\`" : ""}

${claudeMemStatus} **Claude-Mem**: ${claudeMemInstalled ? "Active" : "Not installed"}

${rtkIndicator} **RTK**: ${rtkStatus.installed ? "Active" : "Not installed"}

**Why this matters:**
• Entire = Session checkpoint/recovery (crash protection)
• Claude-Mem = Cross-session memory (context persistence)
• RTK = Token optimization (60-90% savings)

${!entireEnabled ? "**Recommendation:** Enable Entire to prevent context loss on crashes." : ""}

---
💡 To disable these reminders, create \`~/.config/opencode/entire-check.json\`:
\`\`\`json
{
  "enabled": true,
  "mode": "silent"
}
\`\`\``

  await context.client.session.prompt({
    path: { id: sessionID },
    body: {
      parts: [{
        type: "text",
        text: message
      }]
    }
  })
}

async function showStatus(
  context: PluginInput,
  sessionID: string,
  entireEnabled: boolean,
  claudeMemInstalled: boolean,
  rtkStatus: { installed: boolean; efficiency?: string }
): Promise<void> {
  const entireEmoji = entireEnabled ? "✅" : "⚠️"
  const claudeMemEmoji = claudeMemInstalled ? "✅" : "❌"
  const rtkEmoji = rtkStatus.installed ? "✅" : "❌"

  const message = `🧠 Memory Stack Status

${entireEmoji} Entire CLI: ${entireEnabled ? "Enabled" : "Not initialized"}
${claudeMemEmoji} Claude-Mem: ${claudeMemInstalled ? "Active" : "Not installed"}
${rtkEmoji} RTK: ${rtkStatus.installed ? `Active (${rtkStatus.efficiency})` : "Not installed"}

All systems operational. 🚀`

  await context.client.session.prompt({
    path: { id: sessionID },
    body: {
      parts: [{
        type: "text",
        text: message
      }]
    }
  })
}
