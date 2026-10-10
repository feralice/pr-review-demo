#!/usr/bin/env bash
# Rodada 3: abre um PR novo ao vivo, ligado à issue #1 (Closes #1), e o AI
# Review (GitHub Action) revisa sozinho. Ligue o workflow antes.
# Requer: git e GitHub CLI (gh) logado, com o repositório já no GitHub.
set -e
cd "$(git rev-parse --show-toplevel)"
if ! git ls-remote --exit-code --heads origin feat/ajuste-frete >/dev/null 2>&1; then
  bash demo/prepare-branch.sh
fi
# Branch nova a cada rodada: o GitHub só deixa um PR aberto por branch, e
# assim o PR sempre nasce do zero, sem review de ensaio anterior.
BRANCH="demo/frete-$(date +%m%d-%H%M%S)"
NOVO="$(git commit-tree "feat/ajuste-frete^{tree}" -p "feat/ajuste-frete^" \
  -m "feat: frete grátis para compras grandes")"
git push -q origin "$NOVO:refs/heads/$BRANCH"
URL="$(gh pr create --base main --head "$BRANCH" \
  --title "feat: frete grátis para compras grandes" \
  --body-file demo/context/pr-description-com-requisito.md)"
echo "$URL"
# WSL não tem navegador próprio: abre no do Windows
command -v explorer.exe >/dev/null && explorer.exe "$URL" || true
