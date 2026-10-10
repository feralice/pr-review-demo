#!/usr/bin/env bash
# Plano B da rodada 2 (sem MCP): sessão na pasta do projeto, lê o PR e a
# task pelo gh. A principal é o rodada2-mcp.sh.
# Rode depois do add-context.sh. Dentro da sessão: /review <link do PR> 1
# --strict-mcp-config: sem MCP nenhum (nem os conectores do claude.ai); o PR
# e a task chegam pelo gh, que o /review chama.
exec claude --setting-sources project,local --strict-mcp-config "$@"
