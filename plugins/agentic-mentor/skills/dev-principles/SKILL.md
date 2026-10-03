---
name: dev-principles
description: Michael's development principles P1–P10 with their reasoning — the doctrine for deciding, not for explaining. Use this whenever a decision in his own projects is on the table, even if he only asks "should we…", "is it worth…" or "what first?" without naming a principle — scope, pace, prioritisation, what to cut, whether to extend or kill a cycle; choosing a tool, service or where knowledge should live; choosing how to validate an idea (interviews, synthetic users, landing pages, TestFlight, App Store, metrics, kill criteria); an architecture call such as core vs. app layer, data model or event schema; or whether a choice is reversible at all. Also use it when he asks about, cites, or wants to change the principles themselves. Not for explaining how or why a concept works when no decision is attached — that is mentor-mode.
---

# Development principles P1–P10

Michael's ground rules for his software projects. They hold across projects and
grew out of Life OS. The reasoning is part of each principle — a principle without
its reason is the first thing dropped under pressure, so cite the reason, not just
the number.

This file is the canonical version. When Michael wants to change a principle,
edit it here.

**When to apply:** every decision on scope, pace, tooling, validation or
architecture. P2, P6, P7 and P8 apply most often.

---

## P1 — Speed over perfection, at portfolio level

Build and release many apps quickly rather than one thoroughly evaluated app in
the same time — deliberately accepting a lower chance of success per app. The
solo advantage over companies is decision latency close to zero.

What is optimised is the **learning rate**, not speed:

```
Learning rate = cycles per unit of time × signal quality per cycle
```

A product, not a sum — one factor near zero makes the other worthless.

**Spread the assumption, not the finished app.** Ten shipped apps are the
expensive version of the same idea; ten validated or discarded assumptions are the
cheap one. Otherwise two failure points kick in: correlated failures (every bet
fails on missing distribution) and the maintenance ceiling (shipped apps eat the
capacity for new attempts).

**Mechanics, not a plan:** Now / Next / Later without dates. Appetite instead of
estimates. Two-week cycles as the unit of a bet. Circuit breaker — a cycle that
overruns its appetite is ended, not extended.

## P2 — Reversibility as the filter

Before every decision: can it be undone?

**Type-2, fast and imperfect:** screens, copy, flows, nudge logic, score
mechanics, feature scope, the stack of individual app layers, cycle length.

**Type-1, careful:** the core boundary, data model and event schema, the core's
tech stack, GDPR and the deletion concept, App Store presence and first ratings,
name and brand, pricing architecture.

## P3 — Instrumentation is non-negotiable

The one "perfection" that comes before speed. Without event tracking from day 1
there is no Measure step, and without Measure no closed Build-Measure-Learn loop —
you iterate fast against your own gut feeling.

## P4 — Go-live = fastest path to a real usage signal

Not store submission for its own sake. TestFlight-first delivers the same
learning rate without the store's irreversible costs (permanent 1-star reviews,
rejections under guideline 4.2 *Minimum Functionality*).

Iteration levers in a mobile context: **remote config and feature flags plus
server-side logic.** The App Store is a release train, not continuous deployment —
old versions stay live on users' devices.

The App Store is also the worst channel for shots on goal: organic discovery near
zero, winner-take-most. The portfolio lives in the validation funnel (landing
pages, fake doors, waitlists), not in the store.

For habit and behaviour products: the core signal (D7/D30 cohort retention) is a
*lagging indicator* and cannot be pushed below roughly four weeks. So
**parallelise** cycles rather than accelerating them sequentially, and define
*leading indicators*.

## P5 — Kill criteria before every cycle

Confirm and falsify thresholds are set before the data is in. Speed without
abort criteria is just running faster in the wrong direction. The circuit breaker
is the operational form of the same principle.

## P6 — Synthetic users: generator yes, evidence no

**Allowed:** hardening an interview guide, generating hypotheses and edge cases,
copy and onboarding variants, heuristic evaluation, pre-filtering before scarce
real slots.

**Forbidden:** confirming the problem exists, willingness to pay,
prioritisation, go/no-go, retention.

Three reasons. **Sycophancy bias** — personas almost always say "yes, I'd use
that"; the signal you need is suppressed. **Say-do gap without the do side** — a
persona has no weakness of will and no Tuesday evening at 10 pm; the friction a
behaviour product is meant to solve is missing from the simulation. **Epistemic
circularity** — the persona answers from inside your own framing and confirms
your own assumptions.

**Hard rule:** any decision that binds code for more than a week needs at least
one signal from a real human.

## P7 — Platform-backed portfolio

One core, thin apps on top. The core is the **intersection** of the bets, never
their sum.

Core thesis: **make intention vs. reality visible and turn it into an action** —
intention store, signal intake (self-reports and device data), gap engine,
commitment loop, prompting, local data storage with sync. The core is
**platform-neutral**; the design system does not belong in it.

**Answer explicitly at every architecture decision: "Core or app layer?"**
Without that question, app-specific logic migrates into the core, and the
platform loses the property it exists for.

Do not forget: **distribution before product.** Without an audience all bets are
correlated and fail together. It is the slowest factor, and the one development
speed does not help with.

## P8 — Agentic software engineering, to the limit

**The plan is the prompt.** Planning artefacts have two readers: Michael and the
agent.

Selection criterion for every tool: *can the agent read and write it without
someone translating?* It follows that **plaintext in the Git repo is the source
of truth**; SaaS tools are surface. Documentation is no longer overhead but
primary input.

Corollary: knowledge that lives only in a service must be exported as a file
before an agent can work with it. That export is a step in the plan, not an
afterthought.

## P9 — Continuous discovery instead of an interview batch

Two conversations a week as fixed capacity instead of a blocking recruitment
phase. Reason: continuous alignment with reality instead of a snapshot of a
dynamic world.

Discovery is **not a WIP item** but an ongoing rhythm. Discovery and delivery
tracks run in parallel (dual-track), not alternately. An opportunity solution
tree as the filing system, so every conversation lands in the tree instead of in
a report.

## P10 — Working system: short setup time, one overview

For a part-time side project, setup time is the cost driver, not development
time.

- Write `STATE.md` **at the end** of each session, not at the start — on the way
  out, the state is still in your head.
- The *Next action* field holds an action, not a topic.
- **WIP limit 1** in the delivery track: exactly one thing in progress at a time.
- "Done for today" instead of "Done": committed, tests green, `STATE.md` written.
- Spec-driven development; ADRs as the highest-value solo artefact.
- **Overviews are generated, not maintained.** Hand-maintained dashboards rot.

---

## Applying them

Check every proposal on scope, pace, tooling or validation against P1–P10. The
four most frequent questions:

- **P2** — is this decision really reversible?
- **P6** — is AI output being treated as evidence here?
- **P7** — core or app layer?
- **P8** — can the agent read it?

When speed and a principle conflict, name the conflict instead of resolving it
silently.
