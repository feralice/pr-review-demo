#!/usr/bin/env bash
# Abre o PR de demonstração (feat/ajuste-frete -> main).
# Requer: git e GitHub CLI (gh) logado, com o repositório já no GitHub.
set -e
if ! git ls-remote --exit-code --heads origin feat/ajuste-frete >/dev/null 2>&1; then
  bash demo/prepare-branch.sh
fi
gh pr create --base main --head feat/ajuste-frete \
  --title "feat: ajuste no frete e totais por lista de pedidos" \
  --body-file demo/pr-description.md
