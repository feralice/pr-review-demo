---
description: Revisa um PR com o contexto do time (task, regras e skills) e traz resumido
argument-hint: [link do PR] [número da task]
allowed-tools: mcp__github__pull_request_read, mcp__github__issue_read, mcp__github__get_file_contents, mcp__github__search_code, Read, Bash(gh pr diff:*), Bash(gh issue view:*), Grep
---

Você recebeu o link de um PR e o número da task: $ARGUMENTS

Use este contexto, pelo MCP do GitHub (sem MCP, use `gh pr diff`, `gh issue view` e Grep):
- O PR: o que mudou (pull_request_read).
- A task: a issue com esse número (issue_read). É o pedido do cliente.
- O repositório: para cada função que o PR mudou, abra a pasta src (get_file_contents) e veja quem usa ela, inclusive fora do diff.

E as regras do time: o CLAUDE.md desta pasta. Valem para os arquivos que o PR mexeu, mesmo em nomes que já existiam.

Passos:
1. Aplique, uma por vez, as skills negocio, bugs e legibilidade.
2. Traga resumido, numa tabela de até 5 linhas, primeiro os bugs: arquivo, problema e quem achou.
3. Termine com o risco (baixo, médio ou alto).
