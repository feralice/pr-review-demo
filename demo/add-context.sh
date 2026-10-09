#!/usr/bin/env bash
# Rodada 2: dá contexto à IA (regras do time, 3 skills e o comando /review).
# Rode na raiz do projeto, na branch do PR.
# Uso: bash demo/add-context.sh ["regra que a turma escolheu"]
# Com argumento, a regra da turma substitui a regra 1 do CLAUDE.md.
set -e
cp demo/context/CLAUDE.full.md CLAUDE.md
if [ -n "$1" ]; then
  REGRA="$1" perl -i -pe 's/^1\. .*/1. $ENV{REGRA}/' CLAUDE.md
fi
mkdir -p .claude && cp -r demo/context/claude/. .claude/
echo "Contexto adicionado:"
echo "  CLAUDE.md (regras do time), regra 1: $(grep -m1 '^1\. ' CLAUDE.md | cut -c4-)"
for s in .claude/skills/*/; do echo "  skill: $(basename "$s")"; done
echo "  comando: /review"
echo "Agora abra uma sessão NOVA: bash demo/rodada2.sh, e rode /review 1"
