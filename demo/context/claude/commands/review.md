---
description: Revisa o diff desta branch com as skills do time e junta tudo numa tabela
argument-hint: [número da issue com o requisito]
allowed-tools: Bash(git diff:*), Bash(gh issue view:*), Bash(npm test:*), Read, Grep, Glob
---

Você coordena o review da branch atual contra a main.

Diff: !`git diff main...HEAD`

Passos:
1. Se recebeu um número de issue ($ARGUMENTS), leia com `gh issue view $ARGUMENTS` e use como requisito.
2. Aplique, uma por vez, estas skills ao diff: negocio, bugs e legibilidade.
3. Junte tudo numa só tabela: arquivo, linha, tipo (bug, smell ou regra), skill que achou, como resolver. Não repita o mesmo achado.
4. Termine com o nível de risco da mudança (baixo, médio ou alto) e uma frase: o que bloquearia o merge.
