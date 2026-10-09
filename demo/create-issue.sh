#!/usr/bin/env bash
# Cria a issue #1 (o requisito da rodada 2). Rode uma vez, com o repo já no GitHub.
# Requer: GitHub CLI (gh) logado. A issue precisa ser a primeira do repositório.
set -e
gh issue create \
  --title 'Frete grátis para pedidos de R$ 100 ou mais' \
  --body '## Requisito
- Frete grátis para pedidos de R$ 100 ou mais
- Abaixo disso, R$ 5 por kg, com frete mínimo de R$ 15'
