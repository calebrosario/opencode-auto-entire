#!/usr/bin/env node
/**
 * Claude Code MCP Server entry point
 */

import { createMcpServer } from "./claude/mcp-server.js"

createMcpServer().catch((error) => {
  console.error("Failed to start MCP server:", error)
  process.exit(1)
})
