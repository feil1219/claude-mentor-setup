# agentic-mentor

Michael's personal Claude Code working agreement, packaged as a plugin so it
travels to any machine and any repository.

## What it does

| Layer | Mechanism | Content |
|---|---|---|
| Always-on | `SessionStart` hook → `context/core-directives.md` | Language protocol, English coaching, the three mentor levers |
| On demand | `skills/mentor-mode` | How to explain: levers in depth, top-down recipe, terminology discipline |
| On demand | `skills/learning-session` | Depth scale, activity modes, study principles, anti-patterns |
| On demand | `skills/knowledge-vault` | Vault resolution and bootstrap, note-type rule, template, MOC maintenance |
| Invocable | `/agentic-mentor:concept <name>` | The full explain → check → record ritual |

## Why a hook for the always-on layer

A plugin cannot ship `CLAUDE.md` or `.claude/rules/` content — those are read
from `~/.claude/` and the project tree, not from plugins. A `SessionStart` hook
is the only way to deliver always-on behaviour through a plugin.

It also has one genuine advantage over `CLAUDE.md`: the hook matches `compact`,
so the working agreement is re-injected after context compaction instead of
quietly decaying over a long session.

The hook fails silently if anything is wrong with it. A personal preference file
must never block a session.

## Knowledge base location

The vault path is resolved at runtime, most explicit first:

1. `$CLAUDE_KB_PATH`
2. the path in `~/.claude/knowledge-base-path`
3. `~/Documents/Claude/knowledge-base`
4. `./knowledge-base`

On a machine with no vault, run `scripts/kb.sh init [PATH]` — it creates the
scaffold and records the location for later sessions. Without one, concepts are
staged in `./docs/knowledge/` for later import.

## Editing it

`context/core-directives.md` is the expensive file: it loads on every session and
after every compaction. Keep it short. Anything that is reference material or a
multi-step procedure belongs in a skill instead, where it costs only its
description until it is actually needed.

After editing anything, run `/reload-plugins` rather than restarting.
