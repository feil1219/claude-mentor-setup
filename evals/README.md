# Trigger evaluation

Measures whether each skill's `description` actually fires on the prompts it
should, and stays quiet on the near-misses. Descriptions decide triggering —
the skill body is never consulted if the description doesn't match — so this is
the only part of a skill worth measuring quantitatively.

Each set is 20 realistic prompts: 10 that must trigger, 10 near-misses that must
not. The negative cases are the valuable half. A negative like "write a
fibonacci function" tests nothing; "remember that i prefer pnpm over npm" does,
because it shares vocabulary with `knowledge-vault` but belongs to auto memory.

## Running it

The optimizer ships with the `skill-creator` skill. From that skill's directory:

```bash
python3 -m scripts.run_loop \
  --eval-set  ~/Documents/Claude/claude-mentor-setup/evals/mentor-mode.json \
  --skill-path ~/Documents/Claude/claude-mentor-setup/plugins/agentic-mentor/skills/mentor-mode \
  --model claude-opus-5 \
  --timeout 120 \
  --num-workers 4 \
  --max-iterations 4 \
  --verbose
```

It splits the set 60/40 into train and held-out test, measures the current
description, asks Claude to propose better ones, and re-measures. It reports
`best_description`, selected on the **test** split so it does not overfit.
Put that string into the skill's frontmatter and bump `version` in
`plugin.json`.

## Two flags that are not optional

**`--timeout 120`.** The default is 30 seconds, which is shorter than a cold
`claude -p` start on a machine with a large skill and MCP set. Every query then
times out and the run reports `recall=0%` — a measurement artefact that looks
exactly like a catastrophically bad description. If you see 0% recall across the
board, suspect the timeout before you rewrite anything.

**`--num-workers 4`.** The default of 10 spawns ten full Claude sessions at once.
On a loaded machine they starve each other and time out, producing the same
false zero. Four is slower and honest. Run the three skills one after another,
not in parallel.

## Interpreting the result

- **Low recall** — the description is too narrow, or phrased in vocabulary the
  user does not use. Add the phrasings that failed.
- **Low precision** — too greedy. It is stealing turns from ordinary work, which
  costs context on every session. Tighten the scope, and name what it is *not*.
- **An assertion that passes no matter what the description says** is not
  measuring anything. Replace that query.

One caveat this harness cannot cover: it evaluates each skill alone. It will not
tell you whether `mentor-mode` and `concept-onboarding` steal turns from each
other, because competing skills are not loaded. Judge that from real sessions
with `TESTING.md`.
