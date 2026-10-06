#!/usr/bin/env bash
# Rodada 2: dá contexto à IA (regras do time, 3 skills e o comando /review).
# Rode na raiz do projeto, na branch do PR.
set -e
cp demo/context/CLAUDE.md CLAUDE.md
mkdir -p .claude && cp -r demo/context/.claude/. .claude/
echo "Contexto adicionado:"
echo "  CLAUDE.md (regras do time)"
for s in .claude/skills/*/; do echo "  skill: $(basename "$s")"; done
echo "  comando: /review"
echo "Agora abra uma sessão NOVA do claude e rode: /review 1"
