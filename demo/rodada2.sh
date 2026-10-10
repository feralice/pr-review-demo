#!/usr/bin/env bash
# Rodada 2: sessão nova do Claude Code, só com o contexto do repositório.
# Rode depois do add-context.sh. Dentro da sessão: /review <link do PR> 1
# --strict-mcp-config: sem MCP nenhum (nem os conectores do claude.ai); o PR
# e a task chegam pelo gh, que o /review chama.
exec claude --setting-sources project,local --strict-mcp-config "$@"
