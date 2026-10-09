#!/usr/bin/env bash
# Rodada 1 (como o pessoal faz no dia a dia): cola o link do PR e a IA busca
# o diff pelo MCP do GitHub. Roda numa pasta vazia, então ela não tem nenhum
# arquivo local pra ler, e o servidor do MCP só expõe o pull_request_read
# (somente leitura). Só sobra o que vem do PR: o diff.
#
# Token: exporte GITHUB_PAT (fine-grained, só este repo, leitura de PRs e
# issues). Sem ele, o script tenta o token do gh (gh auth token).
#
# Uso: bash demo/rodada1-mcp.sh
# Dentro da sessão, cole: Revise este PR: bugs e code smells. <link do PR>
set -e
cd "$(git rev-parse --show-toplevel)"

TOKEN="${GITHUB_PAT:-$(gh auth token 2>/dev/null || true)}"
[ -n "$TOKEN" ] || { echo "Sem token: export GITHUB_PAT=... ou gh auth login"; exit 1; }

PR_URL="$(gh pr view feat/ajuste-frete --json url --jq .url 2>/dev/null || true)"

VAZIA="$(mktemp -d)"
trap 'rm -rf "$VAZIA"' EXIT
cat > "$VAZIA/.mcp-rodada1.json" <<EOF
{"mcpServers":{"github":{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer $TOKEN","X-MCP-Readonly":"true","X-MCP-Tools":"pull_request_read"}}}}
EOF

echo "Pasta vazia: $VAZIA"
[ -n "$PR_URL" ] && echo "Cole na sessão: Revise este PR: bugs e code smells. $PR_URL"
echo

cd "$VAZIA"
# --tools "": sem Read, Grep, Bash (e a pasta está vazia de qualquer jeito)
# --strict-mcp-config: só o MCP do GitHub deste arquivo, nenhum outro seu
# X-MCP-Tools: o servidor só expõe o pull_request_read; get_commit e
# search_commits devolveriam o patch do checkout.js
claude --setting-sources project,local --tools "" \
  --strict-mcp-config --mcp-config "$VAZIA/.mcp-rodada1.json"
