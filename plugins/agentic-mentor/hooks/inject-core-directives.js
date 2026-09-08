#!/usr/bin/env node
// Injects context/core-directives.md into the session as additionalContext.
//
// Why a hook and not CLAUDE.md: a plugin cannot ship CLAUDE.md or .claude/rules/
// content. A SessionStart hook is the only way to deliver always-on behaviour
// through a plugin, and it has one real advantage over CLAUDE.md — it re-fires on
// "compact", so the working agreement is restored after context compaction rather
// than quietly decaying.
//
// Failure is silent by design. A broken personal hook must never block a session.

const fs = require('fs');
const path = require('path');

const root = process.env.CLAUDE_PLUGIN_ROOT || path.resolve(__dirname, '..');
const file = path.join(root, 'context', 'core-directives.md');

let text;
try {
  text = fs.readFileSync(file, 'utf8').trim();
} catch (err) {
  process.exit(0);
}

if (!text) process.exit(0);

process.stdout.write(
  JSON.stringify({
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: text,
    },
  })
);
