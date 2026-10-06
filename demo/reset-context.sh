#!/usr/bin/env bash
# Volta pra rodada 1 (sem contexto). Use entre os ensaios.
set -e
git checkout -- CLAUDE.md
rm -rf .claude/skills .claude/commands
echo "Voltou pra rodada 1: CLAUDE.md mínimo, sem skills e sem /review."
