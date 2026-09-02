#!/usr/bin/env bash
# Contract checks for the OpenMirror repository.
# Enforces what CONTRIBUTING.md promises: no em dashes, OpenMirror vocabulary,
# and no broken document references.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1
FAIL=0

echo "== required documents =="
required=(README.md ARCHITECTURE.md ROADMAP.md CONTRIBUTING.md SECURITY.md CODE_OF_CONDUCT.md LICENSE)
for f in "${required[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "missing required document: $f"
    FAIL=1
  fi
done

echo "== em dashes (project standard: none) =="
while IFS= read -r f; do
  if grep -Pq '\x{2014}' "$f"; then
    echo "em dash found in $f"
    FAIL=1
  fi
done < <(find . -name '*.md' -not -path './node_modules/*')

echo "== banned product nouns =="
while IFS= read -r f; do
  # Relit is the former project name; it must not come back.
  if grep -Piq '\b(warehouse|Omarchy|platform engineer|relit)\b' "$f"; then
    echo "banned product noun in $f"
    FAIL=1
  fi
  if grep -P '\b(tenant|Mouse)\b' "$f" | grep -qiv 'multi-tenant'; then
    echo "banned product noun in $f"
    FAIL=1
  fi
done < <(find . -name '*.md' -not -path './node_modules/*')

echo "== document references =="
# Markdown names that are OpenCode artifacts or deliberate references,
# not repo documents.
external_md=(AGENTS.md project.md)
while IFS= read -r f; do
  while IFS= read -r ref; do
    ref="${ref//\`/}"
    if [[ "$ref" == *.md && ! -f "$ref" ]]; then
      skip=0
      for ext in "${external_md[@]}"; do
        [[ "$ref" == "$ext" ]] && skip=1
      done
      if [[ "$skip" -eq 0 ]]; then
        echo "broken document reference: $ref (in $f)"
        FAIL=1
      fi
    fi
  done < <(grep -oP '\x60[A-Za-z0-9_.-]+\.md\x60' "$f" || true)
done < <(find . -name '*.md' -not -path './node_modules/*')

if [[ "$FAIL" -ne 0 ]]; then
  echo "contract checks failed"
  exit 1
fi
echo "contract checks passed"