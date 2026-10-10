#!/usr/bin/env bash
# Rodada 2 (dia a dia, com contexto): cola o mesmo link do PR, mas agora a IA
# tem as regras do time, as skills e o /review, e o MCP do GitHub libera ler
# a task e os outros arquivos do repo. Roda numa pasta vazia, como a rodada 1:
# o código vem todo do GitHub, nada do projeto na sua máquina.
#
# Uso: bash demo/add-context.sh ["regra"] e depois bash demo/rodada2-mcp.sh
# Dentro da sessão: /review <link do PR> 1
set -e
cd "$(git rev-parse --show-toplevel)"
[ -d .claude/commands ] || { echo "Rode antes: bash demo/add-context.sh"; exit 1; }

TOKEN="${GITHUB_PAT:-$(gh auth token 2>/dev/null || true)}"
[ -n "$TOKEN" ] || { echo "Sem token: export GITHUB_PAT=... ou gh auth login"; exit 1; }

PR_URL="$(gh pr view feat/frete-pedidos --json url --jq .url 2>/dev/null || true)"

VAZIA="$(mktemp -d)"
trap 'rm -rf "$VAZIA"' EXIT
# Só o contexto do time vai junto: regras, skills e o /review
cp CLAUDE.md "$VAZIA/"
mkdir -p "$VAZIA/.claude" && cp -r .claude/skills .claude/commands "$VAZIA/.claude/"
cat > "$VAZIA/.mcp-rodada2.json" <<JSON
{"mcpServers":{"github":{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer $TOKEN","X-MCP-Readonly":"true","X-MCP-Tools":"pull_request_read,issue_read,get_file_contents,search_code"}}}}
JSON

echo "Pasta só com o contexto do time: $VAZIA"
[ -n "$PR_URL" ] && echo "Cole na sessão: /review $PR_URL 1"
echo

cd "$VAZIA"
# X-MCP-Tools: além do PR, ler a task (issue_read) e os arquivos do repo
claude --setting-sources project,local --permission-mode default \
  --strict-mcp-config --mcp-config "$VAZIA/.mcp-rodada2.json"
