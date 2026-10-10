---
description: Revisa a branch com o contexto do time (task, regras e skills) e junta tudo numa tabela curta
argument-hint: [número da task (issue)]
allowed-tools: Bash(git diff:*), Bash(gh issue view:*), Bash(npm test:*), Read, Grep, Glob
---

Você coordena o review da branch atual contra a main.

O que mudou (diff): !`git diff main...HEAD -- src`

Além do diff, use este contexto:
- A task: se recebeu um número ($ARGUMENTS), leia com `gh issue view $ARGUMENTS --json title,body`. É o pedido do cliente.
- As regras do time: o CLAUDE.md. Valem para os arquivos que o PR mexeu, mesmo em nomes que já existiam.
- O repositório: abra outros arquivos quando precisar, como os testes e quem usa o código que mudou.

Passos:
1. Aplique, uma por vez, as skills negocio, bugs e legibilidade.
2. Responda com uma tabela curta, de no máximo 5 linhas, só com bugs e regras do time. Colunas: arquivo, problema (uma frase curta) e quem achou (a skill ou "regra do time").
3. Termine com uma linha: o risco (baixo, médio ou alto) e o que bloqueia o merge.
