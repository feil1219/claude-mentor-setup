# Testing the plugin

Run from the repo root:

```bash
claude --plugin-dir ./plugins/agentic-mentor
```

The riskiest failure mode for any skill is **under-triggering** — Claude not
loading it when it would have helped. These cases probe exactly that. Run each in
a fresh session and check the expectation.

## Always-on layer (hook)

| # | Prompt | Expect |
|---|--------|--------|
| 1 | `/context` | Plugin skills listed; hook fired without error |
| 2 | `what does this repo do?` | Answer in **English** |
| 3 | `erklär mir kurz, warum ein SessionStart-Hook hier besser ist als CLAUDE.md` | Explanation in **German**, English terms intact, at least one mentor lever |
| 4 | `Can you explain me how does the hook works?` | One short correction line ("Can you explain to me how the hook works?"), then the answer |
| 5 | After a long session that compacts | Language and mentor stance still hold |

## Skill triggering

Each should load a skill **without** being named. If it doesn't, the description
is too narrow — widen it and add the phrasing that failed.

| # | Prompt | Should load |
|---|--------|-------------|
| 6 | `why do we put the retry logic in the client rather than the gateway?` | `mentor-mode` |
| 7 | `I want to properly understand backpressure before I touch this queue` | `concept-onboarding` or `mentor-mode` |
| 8 | `I've been reading about agent harnesses for three sessions and haven't built anything` | `learning-session` (should name the Akquise anti-pattern) |
| 9 | `where would I write down what we just worked out about idempotency keys?` | `knowledge-vault` |
| 10 | `quiz me on what we covered yesterday` | `learning-session` |
| 11 | `/agentic-mentor:concept speculative decoding` | The full ritual, comprehension check included |

## Negative cases — these must **not** trigger a skill

If they do, a description is too greedy.

| # | Prompt | Expect |
|---|--------|--------|
| 12 | `what's the path to the config file?` | Plain answer, no skill, no mentoring |
| 13 | `run the tests` | Runs them. Nothing else |
| 14 | `fix the typo in line 40` | One-line fix |

## New-machine behaviour

On a machine with no vault, `scripts/kb.sh path` must exit non-zero and Claude
must **ask** rather than create one silently. Verify with:

```bash
CLAUDE_KB_PATH=/nonexistent ./plugins/agentic-mentor/scripts/kb.sh path
```

Then check that `kb.sh init /tmp/kb-test` produces the scaffold and records the
path in `~/.claude/knowledge-base-path`.

## When something fails

Fix the **description**, not the body — descriptions decide triggering. Bump
`version` in `plugin.json`, then `/reload-plugins`.
