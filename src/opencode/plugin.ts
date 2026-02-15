/**
 * OpenCode plugin implementation
 * Uses shared core functionality for Entire CLI checking
 */

import type { Hooks, PluginInput } from "@opencode-ai/plugin"
import {
  runEntireCheck,
  autoInitEntire,
  type CheckResult
} from "../core/entire-check.js"

/**
 * Create OpenCode plugin
 */
export async function createPlugin(context: PluginInput): Promise<Hooks> {
  const checkResult = await runEntireCheck(process.cwd())

  if (!checkResult.needsPrompt) {
    return {}
  }

  return {
    event: async ({ event }: { event: any }) => {
      if (event.type !== "session.created") {
        return
      }

      const sessionID = (event.properties as any).id
      const workingDir = (event.properties as any).workingDir || process.cwd()

      const result = await runEntireCheck(workingDir)

      if (!result.needsPrompt) {
        return
      }

      const { config, status } = result

      if (!status.entire.enabled) {
        switch (config.mode) {
          case "auto-init":
            const success = autoInitEntire(workingDir)
            if (success) {
              await showPrompt(context, sessionID, "Entire CLI auto-initialized in this repository. Session persistence is now active. Checkpoints will be created automatically.")
            } else {
              await showPrompt(context, sessionID, result.message || "")
            }
            break

          case "prompt":
            await showPrompt(context, sessionID, result.message || "")
            break

          case "silent":
            console.log(`[entire-check] Entire not enabled in ${workingDir}`)
            break
        }
      } else if (config.showStatus) {
        await showPrompt(context, sessionID, result.message || "")
      }
    }
  }
}

async function showPrompt(
  context: PluginInput,
  sessionID: string,
  message: string
): Promise<void> {
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
