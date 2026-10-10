#!/usr/bin/env bash
# Volta pra rodada 1 (sem contexto). Use entre os ensaios.
set -e
git checkout -- CLAUDE.md
rm -rf .claude/skills .claude/commands
echo "Voltou pra rodada 1: CLAUDE.md mínimo, sem skills e sem /review."
# Desliga o review automático da rodada 3, se ficou ligado
if gh workflow list --all 2>/dev/null | grep -q "AI Review.*active"; then
  gh workflow disable "AI Review (pré-review)" && echo "AI Review (rodada 3) desligado."
fi
