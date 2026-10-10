---
description: Revisa um PR com o contexto do time (task, regras e skills) e traz resumido
argument-hint: [link do PR] [número da task]
allowed-tools: Bash(gh pr diff:*), Bash(gh pr view:*), Bash(gh issue view:*), Bash(npm test:*), Read, Grep, Glob
---

Você recebeu o link de um PR e o número da task: $ARGUMENTS

Use este contexto:
- O PR: veja o que mudou com `gh pr diff <link do PR>`.
- A task: leia com `gh issue view <número> --json title,body`. É o pedido do cliente.
- As regras do time: o CLAUDE.md. Valem para os arquivos que o PR mexeu, mesmo em nomes que já existiam.
- O repositório: para cada função que o PR mudou, procure com Grep quem usa ela, inclusive fora do diff.

Passos:
1. Aplique, uma por vez, as skills negocio, bugs e legibilidade.
2. Traga resumido, numa tabela de até 5 linhas, primeiro os bugs: arquivo, problema e quem achou.
3. Termine com o risco (baixo, médio ou alto).
