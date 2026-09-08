#!/usr/bin/env bash
# Knowledge-base helper for the agentic-mentor plugin.
#
#   kb.sh path            resolve the vault path; exits 1 with a hint if none
#   kb.sh init [PATH]     create the vault scaffold (default: resolved path)
#   kb.sh domains         list existing domains
#
# Resolution order, most explicit first:
#   1. $CLAUDE_KB_PATH
#   2. the path stored in ~/.claude/knowledge-base-path
#   3. ~/Documents/Claude/knowledge-base   (Michael's primary machine)
#   4. ./knowledge-base                     (project-local fallback)

set -euo pipefail

CONFIG="$HOME/.claude/knowledge-base-path"

resolve() {
  if [ -n "${CLAUDE_KB_PATH:-}" ]; then printf '%s\n' "$CLAUDE_KB_PATH"; return 0; fi
  if [ -f "$CONFIG" ]; then
    p="$(head -n1 "$CONFIG" | tr -d '\r' | sed "s|^~|$HOME|")"
    [ -n "$p" ] && { printf '%s\n' "$p"; return 0; }
  fi
  for p in "$HOME/Documents/Claude/knowledge-base" "$PWD/knowledge-base"; do
    [ -d "$p" ] && { printf '%s\n' "$p"; return 0; }
  done
  return 1
}

cmd_path() {
  if p="$(resolve)"; then
    printf '%s\n' "$p"
    [ -d "$p" ] || echo "note: path resolved but does not exist yet; run 'kb.sh init'" >&2
  else
    cat >&2 <<'HINT'
No knowledge base found.
Set one of these, then re-run:
  export CLAUDE_KB_PATH=/path/to/knowledge-base
  echo '/path/to/knowledge-base' > ~/.claude/knowledge-base-path
Or create one here:  kb.sh init ./knowledge-base
HINT
    exit 1
  fi
}

cmd_init() {
  target="${1:-}"
  [ -n "$target" ] || target="$(resolve || echo "$PWD/knowledge-base")"
  target="${target/#\~/$HOME}"

  if [ -f "$target/HOME.md" ]; then
    echo "Vault already initialised at $target" >&2
    exit 0
  fi

  mkdir -p "$target/domains"
  for d in software-engineering knowledge-management generative-ai machine-learning computer-vision robotics; do
    mkdir -p "$target/domains/$d"
    [ -f "$target/domains/$d/_MOC.md" ] || cat > "$target/domains/$d/_MOC.md" <<MOC
# $d — Map of Content

Noch keine Konzepte erfasst.

## Konzepte

_(Liste wächst mit jedem erfassten Konzept: Name → Cluster-Datei)_

## Relationen

| Konzept | Verwandt mit | Art der Beziehung |
|---------|--------------|-------------------|
MOC
  done

  [ -f "$target/HOME.md" ] || cat > "$target/HOME.md" <<'HOMEMD'
# Knowledge Base — HOME

Zentraler, projektübergreifender Wissens-Vault. Domänen-basiert organisiert,
nicht projekt-basiert: was projektunabhängig wahr ist, gehört hierher; was nur
für ein Projekt gilt, bleibt beim Projekt.

## Domänen

- [[software-engineering]] — Architektur, Strukturen, Systeme
- [[knowledge-management]] — PKM, Zettelkasten, PARA, MOC
- [[generative-ai]] — LLMs, Prompting, RAG, Evaluation
- [[machine-learning]] — klassisches ML, Training, Evaluation
- [[computer-vision]] — Perception, Modelle, Pipelines
- [[robotics]] — Embodied Systems, Control, Integration

Siehe `README.md` für Methodik und Konventionen.
HOMEMD

  [ -f "$target/README.md" ] || cat > "$target/README.md" <<'READMEMD'
# Methodik & Konventionen

**Sprache.** Deutsche Definitionen, englische Konzept-Namen. Fachbegriffe werden
nicht übersetzt.

**Notiztyp-Disziplin.**
- *Evergreen* (projektunabhängig wahr) → in diesen Vault.
- *Project note* (projektspezifisch) → bleibt beim Projekt.

**Struktur.** `domains/<domäne>/` mit `_MOC.md` als Einstieg und nummerierten
Cluster-Dateien (`01-...md`, `02-...md`) für zusammengehörige Konzepte.

**Vorlage pro Konzept.**

```
### Concept Name
**Definition.** 1-2 Sätze.
**Warum es zählt.** Praktischer Mehrwert.
**Beispiel aus unserem Projekt.** Konkrete Situation.
**Verwandt mit.** [[Cross-Links]]
**Recall-Frage.** Eine Test-Frage.
```

**Pflege.** Bei jedem neuen oder signifikant erweiterten Konzept: Cluster
ergänzen → `_MOC.md` nachtragen → Querverweise in verwandten Konzepten
ergänzen → bei neuer Domäne in `HOME.md` verlinken.
READMEMD

  mkdir -p "$HOME/.claude"
  printf '%s\n' "$target" > "$CONFIG"
  echo "Initialised knowledge base at $target"
  echo "Path recorded in $CONFIG"
}

cmd_domains() {
  p="$(resolve)" || { cmd_path; exit 1; }
  [ -d "$p/domains" ] || { echo "no domains/ directory in $p" >&2; exit 1; }
  find "$p/domains" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
}

case "${1:-path}" in
  path)    cmd_path ;;
  init)    shift; cmd_init "${1:-}" ;;
  domains) cmd_domains ;;
  *) echo "usage: kb.sh [path|init [PATH]|domains]" >&2; exit 2 ;;
esac
