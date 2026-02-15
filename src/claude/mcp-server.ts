/**
 * Claude Code MCP Server implementation
 * Provides tools for checking Entire CLI, Claude-Mem, and RTK status
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  type Tool
} from "@modelcontextprotocol/sdk/types.js"
import {
  runEntireCheck,
  autoInitEntire,
  generateMessage,
  type CheckResult
} from "../core/entire-check.js"

/**
 * Create and run Claude Code MCP server
 */
export async function createMcpServer(): Promise<void> {
  const server = new Server(
    {
      name: "opencode-auto-entire",
      version: "1.0.0"
    },
    {
      capabilities: {
        tools: {}
      }
    }
  )

  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: [
        {
          name: "check_memory_stack",
          description: "Check the status of Entire CLI, Claude-Mem, and RTK in the current directory",
          inputSchema: {
            type: "object",
            properties: {
              workingDir: {
                type: "string",
                description: "Working directory to check (defaults to current directory)",
                default: process.cwd()
              }
            }
          }
        },
        {
          name: "enable_entire",
          description: "Auto-initialize Entire CLI in the current directory",
          inputSchema: {
            type: "object",
            properties: {
              workingDir: {
                type: "string",
                description: "Working directory to initialize (defaults to current directory)",
                default: process.cwd()
              }
            }
          }
        }
      ]
    }
  })

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params
    const workingDir = (args?.workingDir as string) || process.cwd()

    try {
      if (name === "check_memory_stack") {
        const result = await runEntireCheck(workingDir)

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({
                entire: result.status.entire.enabled,
                claudeMem: result.status.claudeMem.installed,
                rtk: {
                  installed: result.status.rtk.installed,
                  efficiency: result.status.rtk.efficiency
                },
                message: result.message,
                needsPrompt: result.needsPrompt
              }, null, 2)
            }
          ]
        }
      } else if (name === "enable_entire") {
        const success = autoInitEntire(workingDir)

        if (success) {
          return {
            content: [
              {
                type: "text",
                text: JSON.stringify({
                  success: true,
                  message: "Entire CLI auto-initialized successfully in this repository. Session persistence is now active."
                }, null, 2)
              }
            ]
          }
        } else {
          return {
            content: [
              {
                type: "text",
                text: JSON.stringify({
                  success: false,
                  message: "Failed to initialize Entire CLI. Please run manually: `entire enable --strategy auto-commit`"
                }, null, 2)
              }
            ],
            isError: true
          }
        }
      }

      return {
        content: [
          {
            type: "text",
            text: `Unknown tool: ${name}`
          }
        ],
        isError: true
      }
    } catch (error) {
      return {
        content: [
          {
            type: "text",
            text: `Error: ${error instanceof Error ? error.message : String(error)}`
          }
        ],
        isError: true
      }
    }
  })

  const transport = new StdioServerTransport()
  await server.connect(transport)

  console.error("OpenCode Auto-Entire MCP Server running on stdio")
}
