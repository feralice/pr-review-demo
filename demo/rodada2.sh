#!/usr/bin/env bash
# Rodada 2: sessão nova do Claude Code, só com o contexto do repositório.
# Rode depois do add-context.sh. Dentro da sessão: /review <link do PR> 1
exec claude --setting-sources project,local "$@"
