#!/usr/bin/env bash
# Rodada 1 (como o pessoal faz no dia a dia): cola o link do PR e a IA busca
# o diff pelo MCP do GitHub. Roda numa pasta vazia, então ela não tem nenhum
# arquivo local pra ler, e as ferramentas do MCP que abrem arquivo do repo
# ficam bloqueadas. Só sobra o que vem do PR: o diff.
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
{"mcpServers":{"github":{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer $TOKEN"}}}}
EOF

echo "Pasta vazia: $VAZIA"
[ -n "$PR_URL" ] && echo "Cole na sessão: Revise este PR: bugs e code smells. $PR_URL"
echo

cd "$VAZIA"
# --tools "": sem Read, Grep, Bash (e a pasta está vazia de qualquer jeito)
# --strict-mcp-config: só o MCP do GitHub deste arquivo, nenhum outro seu
# --disallowedTools: bloqueia as ferramentas do MCP que abrem arquivo do repo
claude --setting-sources project,local --tools "" \
  --strict-mcp-config --mcp-config "$VAZIA/.mcp-rodada1.json" \
  --disallowedTools "mcp__github__get_file_contents,mcp__github__search_code"
