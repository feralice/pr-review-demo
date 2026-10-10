---
description: Revisa a branch com o contexto do time (task, regras e skills) e traz resumido
argument-hint: [número da task (issue)]
allowed-tools: Bash(git diff:*), Bash(gh issue view:*), Bash(npm test:*), Read, Grep, Glob
---

Você coordena o review da branch atual contra a main.

Use este contexto:
- O que mudou: `git diff main...HEAD -- src`.
- A task: se recebeu um número ($ARGUMENTS), leia com `gh issue view $ARGUMENTS --json title,body`. É o pedido do cliente.
- As regras do time: o CLAUDE.md. Valem para os arquivos que o PR mexeu, mesmo em nomes que já existiam.
- O repositório: abra outros arquivos quando precisar, como os testes e quem usa o código que mudou.

Passos:
1. Aplique, uma por vez, as skills negocio, bugs e legibilidade.
2. Traga resumido, numa tabela de até 5 linhas: arquivo, problema e quem achou.
3. Termine com o risco (baixo, médio ou alto).
