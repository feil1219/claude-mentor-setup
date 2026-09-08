# Vault structure and conventions

## Layout

```
knowledge-base/
├── HOME.md                    ← Master MOC, the entry point
├── README.md                  ← Methodology & conventions
└── domains/
    ├── software-engineering/
    │   ├── _MOC.md
    │   ├── 01-agentic-foundations.md
    │   ├── 02-agentic-workflow.md
    │   └── ...                ← numbered thematic clusters
    ├── knowledge-management/
    ├── generative-ai/
    ├── machine-learning/
    ├── computer-vision/
    └── robotics/
```

Domains and clusters listed here are the state at setup time. **Always read the
actual `_MOC.md` before placing a concept** — the vault grows, and this file will
drift.

Domain-organised, never project-organised. A project folder holds at most a
`KNOWLEDGE-BASE.md` pointer plus its own project notes.

## What a `_MOC.md` contains

Three things, all of which need updating when a concept is added:

1. A list of the concepts in the domain, each pointing at its cluster file.
2. A Mermaid graph of how those concepts relate.
3. A relation table: concept, related concept, kind of relationship.

The MOC is the navigation layer. A concept that exists in a cluster file but not
in the MOC is effectively lost.

## Cluster files

A cluster groups concepts that are learned and used together. Numbered so the
reading order is meaningful — roughly foundational first, applied later. Each
concept inside is a `###` section following the template.

Create a new cluster when an existing one exceeds comfortable reading length or
when a concept genuinely starts a new theme. Renumbering existing clusters is
almost never worth it; append instead.

## Naming

- Concept names: English, as the field uses them. `retrieval-augmented generation`,
  not `abrufgestützte Generierung`.
- Definitions and explanatory prose: German.
- File and directory names: English, kebab-case.

## Links

`[[Concept Name]]` wiki-links, resolved by Obsidian. Bidirectional by
convention — the tooling does not enforce it, so adding the reverse link is a
manual step that must not be skipped. Cross-domain links carry the most value
and are the easiest to forget.
