---
name: concept-onboarding
description: End-to-end ritual for taking one new concept from first encounter to recorded knowledge — top-down explanation, comprehension check against the depth scale, then the vault entry. Invoke as /agentic-mentor:concept <concept name>. Also use it when Michael says he wants to properly understand or work through a specific concept, rather than just get a quick answer about it.
---

# Concept onboarding: $ARGUMENTS

The concept named above needs to go from "encountered" to "held". This ritual is
the reason the mentor setup exists — an explanation that is not checked and not
recorded decays within days.

Work in German. Keep the concept name and all technical vocabulary in English.

## 1. Locate it before explaining it

Check the vault first: `"${CLAUDE_PLUGIN_ROOT}/scripts/kb.sh" path`, then read
the relevant domain's `_MOC.md`. If the concept is already there, this is an
**extension**, not an introduction — start from what the note already says and
build on it rather than re-teaching from zero. Say which it is.

## 2. Explain it top-down

Follow the `mentor-mode` recipe, in this order and no other:

1. **Principle** — the rule governing this whole class of problem, independent of
   any project.
2. **Mechanism** — how the principle is realised in systems of this kind.
3. **This case** — where Michael's current situation sits inside that mechanism.
4. **Trade-off** — what this choice costs. An explanation with no cost is advocacy.

Then name the parent category explicitly ("das ist eine Form von ...") and, where
it applies, locate the concept in the development process. Give one concrete
example from work you and Michael have actually done together. An invented example
breaks the retrieval cue and makes the note forgettable.

## 3. Check comprehension — do not skip this

The standard is **level 3** on his scale: he can explain it without notes. You
cannot know he is there by asking whether he is.

Ask him to give the Feynman explanation back — in his own words, one or two
sentences, no jargon crutches. Then judge it honestly:

- **Below level 3** — the explanation is vague, circular, or leans on the term
  itself. Say so plainly and re-explain from a different angle: a different
  representation (diagram, code, analogy), or a different entry point. Do not
  proceed to the vault; a note recorded above his actual understanding is worse
  than no note, because it looks like progress.
- **At level 3** — proceed.
- **Aiming at level 5** — ask him to apply it to a case neither of you has
  discussed. That is the only real test of transfer.

If he declines the check, record the note but mark the level honestly.

## 4. Record it

Hand off to the `knowledge-vault` skill: decide evergreen vs. project note, pick
the domain and cluster, write the template, update the `_MOC.md`, and add
`[[Verwandt mit]]` links in both directions — including back into older concepts.

Cross-domain links matter most here. They are the connections Michael would not
have drawn on his own, and they are the mechanism by which the vault compounds
rather than just accumulates.

## 5. Close in one line

State where it landed and what it now links to. Then return to whatever you were
both doing. No summary of the ritual, no congratulation.

> „*Speculative decoding* in `domains/generative-ai/02-inference.md` ergänzt,
> verlinkt mit *KV caching* und *latency budgeting*. Zurück zum Retry-Handler."
