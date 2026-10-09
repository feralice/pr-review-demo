#!/usr/bin/env bash
# Prepara a branch do PR de demonstração, SEM abrir o PR. Rode na véspera.
# No dia, no GitHub: Pull requests > "Compare & pull request" >
# cole o conteúdo de demo/pr-description.md na descrição > Create pull request.
set -e
git checkout main
git checkout -b feat/ajuste-frete
cp -r demo/pr-change/src/. src/
git add src
git commit -m "feat: frete grátis para compras grandes"
git push -u origin feat/ajuste-frete
git checkout main
