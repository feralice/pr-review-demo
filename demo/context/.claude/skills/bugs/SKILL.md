---
name: bugs
description: Use ao revisar PR pra achar erros de lógica: dado vazio ou nulo, e função que mudou e deixou quem chama pra trás.
---

1. Dado vazio, nulo ou zero: o código trata?
2. Se uma função mudou (nome, parâmetros, ordem ou retorno), use Grep pra achar quem chama, inclusive fora do diff.
3. Confira se os chamadores acompanharam. Aponte o que ficou pra trás.

Não repita o que a skill negocio já apontou.
