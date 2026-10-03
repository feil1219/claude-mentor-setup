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
| 6 | `let's just hardcode the user id into the core sync module for now, we'll clean it up later` | Raises "core or app layer?" and names the speed-vs-principle conflict instead of silently complying |

## Skill triggering

Each should load a skill **without** being named. If it doesn't, the description
is too narrow — widen it and add the phrasing that failed.

| # | Prompt | Should load |
|---|--------|-------------|
| 7 | `why do we put the retry logic in the client rather than the gateway?` | `mentor-mode` |
| 8 | `I want to properly understand backpressure before I touch this queue` | `concept-onboarding` or `mentor-mode` |
| 9 | `I've been reading about agent harnesses for three sessions and haven't built anything` | `learning-session` (should name the Akquise anti-pattern) |
| 10 | `where would I write down what we just worked out about idempotency keys?` | `knowledge-vault` |
| 11 | `quiz me on what we covered yesterday` | `learning-session` |
| 12 | `/agentic-mentor:concept speculative decoding` | The full ritual, comprehension check included |
| 13 | `the streaks cycle is in week 3 of a 2 week appetite, extend it?` | `dev-principles` (circuit breaker, P1/P5) |
| 14 | `I got 26 of 30 synthetic personas saying they'd pay — enough to build the paywall?` | `dev-principles` (P6, not evidence) |
| 15 | `notion or linear for the roadmap?` | `dev-principles` (P8, can the agent read it) |

## Negative cases — these must **not** trigger a skill

If they do, a description is too greedy.

| # | Prompt | Expect |
|---|--------|--------|
| 16 | `what's the path to the config file?` | Plain answer, no skill, no mentoring |
| 17 | `run the tests` | Runs them. Nothing else |
| 18 | `fix the typo in line 40` | One-line fix |

## mentor-mode vs. dev-principles

The boundary: `mentor-mode` **explains** (concepts, process classification,
top-down), `dev-principles` **decides** (scope, pace, reversibility). The trigger
harness evaluates each skill alone, so check the pair here.

| # | Prompt | Should load | Must not load |
|---|--------|-------------|---------------|
| 19 | `explain how remote config and feature flags differ under the hood` | `mentor-mode` | `dev-principles` |
| 20 | `testflight or app store for the focus timer right now?` | `dev-principles` | — (`mentor-mode` only as a follow-up explanation) |
| 21 | `where does the type-1 / type-2 decision idea come from?` | `mentor-mode` | `dev-principles` |

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
