#!/usr/bin/env bash
# Abre o PR de demonstração. Rode na raiz do projeto, já com o repo no GitHub.
# Requer: git e GitHub CLI (gh) logado.
set -e
git checkout main
git checkout -b feat/ajuste-frete
cp -r demo/pr-change/src/. src/
git add src
git commit -m "feat: ajuste no frete e totais por lista de pedidos"
git push -u origin feat/ajuste-frete
gh pr create \
  --title "feat: ajuste no frete e totais por lista de pedidos" \
  --body-file demo/pr-description.md
