#!/usr/bin/env bash
# Confere se está tudo pronto pra começar a demo. Rode antes da palestra.
cd "$(git rev-parse --show-toplevel)"
falhas=0
ok()   { echo "  ok    $1"; }
erro() { echo "  ERRO  $1"; falhas=$((falhas + 1)); }

[ "$(git branch --show-current)" = feat/ajuste-frete ] \
  && ok "branch feat/ajuste-frete" || erro "troque de branch: git checkout feat/ajuste-frete"

git diff --quiet HEAD -- CLAUDE.md && [ ! -e .claude/skills ] && [ ! -e .claude/commands ] \
  && ok "contexto limpo (rodada 1)" || erro "contexto da rodada 2 ainda está aqui: bash demo/reset-context.sh"

[ "$(git diff --name-only main...HEAD | tr '\n' ' ')" = "src/frete.js src/pedidos.js " ] \
  && ok "diff do PR: src/frete.js e src/pedidos.js" || erro "diff main...HEAD mudou: $(git diff --name-only main...HEAD | tr '\n' ' ')"

npm test >/dev/null 2>&1 && erro "npm test passou, mas deveria falhar (bug do checkout.js)" || ok "npm test falha, como esperado"

command -v claude >/dev/null && ok "claude $(claude --version 2>/dev/null | cut -d' ' -f1)" || erro "claude não encontrado"

if gh auth status >/dev/null 2>&1; then
  ok "gh logado"
  [ "$(gh issue view 1 --json state --jq .state 2>/dev/null)" = OPEN ] && ok "issue #1 aberta" || erro "issue #1 não está aberta"
  [ "$(gh pr view feat/ajuste-frete --json state --jq .state 2>/dev/null)" = OPEN ] && ok "PR aberto" || erro "PR da feat/ajuste-frete não está aberto"
  [ "$(gh pr view feat/frete-pedidos --json isDraft --jq .isDraft 2>/dev/null)" = true ] && ok "PR rascunho da rodada 1 aberto" || erro "PR rascunho da feat/frete-pedidos não está aberto"
else
  erro "gh sem login: gh auth login"
fi

[ -n "$GITHUB_PAT" ] && ok "GITHUB_PAT definido (rodada 1 pelo MCP)" \
  || echo "  aviso GITHUB_PAT não definido: a rodada 1 vai usar o gh auth token"

sobrando=$(git status --porcelain)
[ -z "$sobrando" ] && ok "nada pendente no git" || erro "arquivos pendentes no git:"$'\n'"$sobrando"

[ "$falhas" -eq 0 ] && echo "Tudo pronto." || { echo "$falhas problema(s)."; exit 1; }
