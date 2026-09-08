# claude-mentor-setup

A Claude Code plugin marketplace holding Michael's personal working agreement.
One repository, one plugin: [`agentic-mentor`](plugins/agentic-mentor).

## Install on a new machine

```bash
claude plugin marketplace add <your-github-user>/claude-mentor-setup
claude plugin install agentic-mentor@mentor-setup
```

Then start Claude Code in any project. Run `/context` and confirm the plugin's
skills are listed; the working agreement arrives through a `SessionStart` hook,
so it is in place from the first message.

If the install output says `Run /reload-plugins to activate.`, run that.

## Update

```bash
claude plugin marketplace update mentor-setup
```

Users only receive changes when `version` in
`plugins/agentic-mentor/.claude-plugin/plugin.json` is bumped, so raise it with
every meaningful edit.

## Develop locally

```bash
claude --plugin-dir ./plugins/agentic-mentor
```

A local `--plugin-dir` copy takes precedence over the installed one for that
session, so you can test changes without uninstalling. `/reload-plugins` picks
up edits without a restart.

See [TESTING.md](TESTING.md) for manual trigger cases and [evals/](evals/) for the quantitative trigger benchmark.

Validate before pushing:

```bash
claude plugin validate ./plugins/agentic-mentor
```

## What lives at which level

The design principle: **behaviour that must affect every answer cannot be a
skill** — Claude would systematically under-trigger it. **Procedures that only
apply sometimes must not be always-on** — they would spend context permanently
for occasional value.

| Level | Goes where | Why |
|---|---|---|
| Language, mentor stance, coaching | `SessionStart` hook | Must shape every turn |
| Explanation doctrine, learning methodology, vault procedure | Skills | Situational; loaded when relevant |
| The concept ritual | `/agentic-mentor:concept` | Deliberately invoked |
| Project architecture, build commands, conventions | The project's own `CLAUDE.md` | Repo-specific, team-shared |

Keep project-specific facts out of this repo. This plugin is about how Claude
works *with Michael*, not about any one codebase.
