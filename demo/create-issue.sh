#!/usr/bin/env bash
# Cria a issue #1 (o requisito da rodada 2). Rode uma vez, com o repo já no GitHub.
# Requer: GitHub CLI (gh) logado. A issue precisa ser a primeira do repositório.
set -e
gh issue create \
  --title 'Frete grátis para compras acima de R$ 200' \
  --body '## Requisito
- Compras acima de R$ 200: frete grátis
- Até R$ 200: frete de R$ 10'
