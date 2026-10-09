#!/usr/bin/env bash
# Rodada 3: abre o PR (feat/ajuste-frete -> main) ao vivo, e o CodeRabbit
# revisa sozinho. Ative o CodeRabbit no repo antes de rodar.
# Pra ensaiar de novo: feche o PR no GitHub e rode outra vez.
# Requer: git e GitHub CLI (gh) logado, com o repositório já no GitHub.
set -e
if ! git ls-remote --exit-code --heads origin feat/ajuste-frete >/dev/null 2>&1; then
  bash demo/prepare-branch.sh
fi
URL="$(gh pr create --base main --head feat/ajuste-frete \
  --title "feat: ajuste no frete e totais por lista de pedidos" \
  --body-file demo/pr-description.md)"
echo "$URL"
# WSL não tem navegador próprio: abre no do Windows
command -v explorer.exe >/dev/null && explorer.exe "$URL" || true
