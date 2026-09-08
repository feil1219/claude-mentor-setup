---
name: knowledge-vault
description: Maintains Michael's central, cross-project knowledge vault — resolving or bootstrapping its location on any machine, deciding whether a note is evergreen or project-scoped, and writing concepts in his template with MOC and cross-link updates. Use this whenever a concept is worth keeping past this session, right after you introduce or significantly extend one, when Michael asks where something belongs or what he already knows about a topic, and when setting up the vault on a machine that does not have one yet.
---

# Knowledge vault

Michael keeps one central vault across all projects, so that knowledge compounds
instead of fragmenting into per-project silos. It is domain-organised, never
project-organised. Treat it as a single source of truth: a concept lives in
exactly one place, and everything else links to it.

## Step 1 — find the vault before writing anything

Never assume a path. Machines differ, and on a new machine there may be no vault
at all. Resolve it:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/kb.sh" path
```

The script checks, in order: `$CLAUDE_KB_PATH`, the path recorded in
`~/.claude/knowledge-base-path`, `~/Documents/Claude/knowledge-base`, then
`./knowledge-base`.

**If it exits non-zero, there is no vault on this machine.** Do not guess and do
not silently create one somewhere. Ask Michael once:

> Kein Vault auf diesem Rechner gefunden. Zwei Optionen: (a) ich lege einen unter
> `<Vorschlag>` an, (b) du sagst mir, wo dein synchronisierter Vault liegt.

If he wants one created, or wants to defer:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/kb.sh" init [PATH]
```

This writes the scaffold — `HOME.md`, `README.md`, and a `_MOC.md` per domain —
and records the location in `~/.claude/knowledge-base-path` so later sessions on
this machine find it without asking again.

**If he wants to defer entirely**, collect concepts in `./docs/knowledge/` inside
the current project, in the same template and with the same discipline, and note
in each file that it is staged for vault import. That keeps the habit intact
without forcing a decision mid-task. Tell him the files are staged, once, at the
end — not every time you write one.

## Step 2 — decide whether it belongs there at all

The single rule that keeps the vault useful:

- **Evergreen** — true independently of any project → **vault**.
- **Project note** — only meaningful inside one project → **stays with the project**.

The test: would this still be worth reading if the project were cancelled
tomorrow? "We chose Postgres because of the JSONB support" is a project note.
"JSONB lets a relational store absorb document workloads, at the cost of query
planning visibility" is evergreen.

When it is genuinely both, write the evergreen part to the vault and leave a
project note that links to it. Do not duplicate the content.

## Step 3 — place it

Read the target domain's `_MOC.md` before writing. It lists the existing clusters
and tells you what is already covered — the layout is `domains/<domain>/` with a
`_MOC.md` and numbered cluster files (`01-...md`, `02-...md`) grouping related
concepts. See `references/vault-structure.md` for the full layout and conventions.

Choose the cluster whose theme the concept actually belongs to. When nothing
fits, prefer a **new domain** over overloading an unrelated one — Michael has
said this explicitly, and a wrongly-placed concept is harder to find later than a
thinly-populated domain.

## Step 4 — write it in his template

German definitions, English concept names. Never translate the name.

```
### Concept Name
**Definition.** 1-2 Sätze.
**Warum es zählt.** Praktischer Mehrwert.
**Beispiel aus unserem Projekt.** Konkrete Situation.
**Verwandt mit.** [[Cross-Links]]
**Recall-Frage.** Eine Test-Frage.
```

Each field earns its place. The **Beispiel** must come from work you and Michael
actually did — an invented example makes the note unmemorable and breaks the
retrieval cue. The **Recall-Frage** is what makes the vault usable for active
recall later, so it must be answerable from the note but not quoted from it.

## Step 5 — maintain the graph, not just the file

A vault whose links rot is a folder. After adding or extending a concept:

1. Add it to the domain's `_MOC.md` — the concept list, the Mermaid graph, and
   the relation table.
2. Add `[[Verwandt mit]]` links **in both directions**. Go back to the older
   concepts and add the reverse link. Cross-domain links are the valuable ones,
   because they are the connections Michael would not have made himself.
3. If you created a new domain, link it in `HOME.md`.

## Reporting

Report briefly and factually: „Konzept *X* in `domains/.../04-...md` ergänzt,
`_MOC.md` und Querverweis in *Y* nachgetragen." One line. Do not celebrate
vault maintenance — it is hygiene, not an achievement, and treating it as one
makes it feel expensive.

## When to reach for this without being asked

- You just introduced a concept in mentor mode and it is genuinely new.
- Michael reaches level 3 on something (see `learning-session`).
- He asks "hatten wir das schon?" or "was weiß ich darüber?" — read the relevant
  `_MOC.md` and answer from the vault before answering from your own knowledge.
