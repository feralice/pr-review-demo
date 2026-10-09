#!/usr/bin/env bash
# Rodada 3: abre o PR (feat/ajuste-frete -> main) ao vivo, e o CodeRabbit
# revisa sozinho. Ative o CodeRabbit no repo antes de rodar.
# Pra ensaiar de novo: feche o PR no GitHub e rode outra vez.
# Requer: git e GitHub CLI (gh) logado, com o repositório já no GitHub.
set -e
if ! git ls-remote --exit-code --heads origin feat/ajuste-frete >/dev/null 2>&1; then
  bash demo/prepare-branch.sh
fi
# Commit novo a cada rodada (mesmo conteúdo): o CodeRabbit marca o commit, e
# um commit já revisado num ensaio deixaria o PR com o check "Review completed".
NOVO="$(git commit-tree "feat/ajuste-frete^{tree}" -p "feat/ajuste-frete^" \
  -m "feat: frete grátis para compras grandes")"
git update-ref refs/heads/feat/ajuste-frete "$NOVO"
git push -q --force origin feat/ajuste-frete
URL="$(gh pr create --base main --head feat/ajuste-frete \
  --title "feat: frete grátis para compras grandes" \
  --body-file demo/pr-description.md)"
echo "$URL"
# WSL não tem navegador próprio: abre no do Windows
command -v explorer.exe >/dev/null && explorer.exe "$URL" || true
