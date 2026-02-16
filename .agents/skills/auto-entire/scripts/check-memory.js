#!/usr/bin/env node

/**
 * Memory stack checking script for Codex Skills
 * Uses shared core module for checking Entire, Claude-Mem, and RTK
 */

import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Import core module (relative to plugin root)
const coreModulePath = join(__dirname, '..', '..', 'core', 'entire-check.ts')

async function checkMemoryStack() {
  try {
    // Dynamically import to avoid TypeScript compilation issues
    const { runEntireCheck } = await import(coreModulePath)

    const workingDir = process.cwd()
    const result = await runEntireCheck(workingDir)
    console.log('\n' + result.message)

    if (result.needsPrompt && !result.status.entire.enabled) {
      process.exit(1)
    }

    process.exit(0)
  } catch (error) {
    console.error('Error checking memory stack:', error.message)
    console.error('\nMake sure the plugin is installed with: npm install')
    process.exit(1)
  }
}

checkMemoryStack()
