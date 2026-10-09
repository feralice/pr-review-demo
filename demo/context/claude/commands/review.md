---
description: Revisa a branch com o contexto do time (task, regras e skills) e junta tudo numa tabela
argument-hint: [número da task (issue)]
allowed-tools: Bash(git diff:*), Bash(gh issue view:*), Bash(npm test:*), Read, Grep, Glob
---

Você coordena o review da branch atual contra a main.

O que mudou (diff): !`git diff main...HEAD`

Além do diff, use este contexto:
- A task: se recebeu um número ($ARGUMENTS), leia com `gh issue view $ARGUMENTS --json title,body`. É o pedido do cliente.
- As regras do time: o CLAUDE.md.
- O repositório: abra outros arquivos quando precisar, como os testes e quem usa o código que mudou.

Passos:
1. Aplique, uma por vez, as skills negocio, bugs e legibilidade.
2. Junte tudo numa só tabela: arquivo, linha, tipo (bug, smell ou regra), skill que achou, como resolver. Não repita o mesmo achado.
3. Termine com o risco (baixo, médio ou alto) e uma frase: o que bloquearia o merge.
