# pr-review-demo

Projeto pequeno pra mostrar, ao vivo, **review automático de IA num Pull Request**, em **duas rodadas**:

1. **Rodada 1:** a IA revisa só com o diff. Sem regras do time e sem requisito.
2. **Rodada 2:** você dá contexto (regras no `CLAUDE.md`, a skill `clean-code` e o requisito numa **issue** ligada ao PR), faz um push, e a IA revisa de novo.

A turma compara as duas. É a prova de que **contexto vale mais que prompt**. A IA é um pré-review: ela acelera, e o humano decide.

## Subir pro GitHub (copie e cole)

Precisa de: `git`, Node.js 18+ e o GitHub CLI (`gh`). Faça `gh auth login` uma vez.

```bash
unzip pr-review-demo.zip && cd pr-review-demo
git init -b main
git add . && git commit -m "chore: projeto de demonstração"
gh repo create pr-review-demo --private --source=. --remote=origin --push
bash demo/create-issue.sh        # cria a issue #1 (o requisito)
bash demo/prepare-branch.sh      # empurra a branch feat/ajuste-frete, sem abrir o PR
```

Depois, no GitHub (uma vez):
1. **App do Claude:** instale em github.com/apps/claude, só neste repositório (ou rode `/install-github-app` no Claude Code).
2. **Segredo:** `gh secret set ANTHROPIC_API_KEY` (ele pede a chave; não cole no código).
3. **Actions:** confira que estão habilitadas (aba Actions).

Deixe o repositório **privado** nos ensaios. Pra turma abrir pelo QR, torne **público** só na hora: Settings > General > Danger Zone > Change visibility.

## O que tem aqui

| Arquivo | Pra quê |
|---|---|
| `src/frete.js`, `src/checkout.js` | Código da "loja": frete e total do pedido |
| `test/checkout.test.js` | Testes (passam na `main`, falham depois do PR) |
| `CLAUDE.md` e `.github/copilot-instructions.md` | **Versão mínima** (rodada 1): só diz o que é o projeto |
| `demo/context/CLAUDE.md` e `copilot-instructions.md` | **Versão completa** (rodada 2): as 4 regras do time (a 1ª: nomes de função em snake_case) |
| `demo/context/pr-description-com-requisito.md` | Descrição do PR **com** `Closes #1`, que liga a issue do requisito (rodada 2) |
| `demo/context/issue-requisito.md` | Título e corpo da **issue #1** (o requisito), que você cria uma vez no GitHub |
| `demo/pr-description.md` | Descrição do PR **sem** requisito (rodada 1) |
| `demo/pr-change/src/` | Os arquivos "depois" do PR (`frete.js` e `pedidos.js`) |
| `demo/open-demo-pr.sh` | Abre o PR de demonstração com um comando |
| `templates/arquivo-de-instrucoes.md` | Modelo do arquivo de instruções do time (o que vai por e-mail) |
| `demo/context/skills/clean-code/` | **Skill de exemplo** (o 2º contexto), pra achar code smells. Fica fora de `.claude/skills/` de propósito, pra não ativar na rodada 1. Na rodada 2 você cria o arquivo `.claude/skills/clean-code/SKILL.md` na branch do PR (Add file > Create new file) e cola o conteúdo. A documentação não confirma que a Action carrega skills: **teste na véspera** (se não carregar, cole as 4 linhas dela no `CLAUDE.md`) |
| `.github/workflows/ai-review.yml` | **O review automático** (GitHub Action com Claude) |
| `.github/workflows/ci.yml` | CI com os testes |
| `.github/pull_request_template.md` | Template que pede o requisito no PR |

## O que está plantado no PR

O PR muda o `src/frete.js` (3 linhas) e cria o `src/pedidos.js`.

| # | Problema | Onde | Tipo | Rodada 1 (só o diff) | Rodada 2: o contexto que pega |
|---|---|---|---|---|---|
| 1 | A ordem dos parâmetros trocou: `calcularFrete(total, pesoKg)` virou `(pesoKg, total)`, mas o `checkout.js` ainda chama na ordem antiga, e o frete sai errado | `src/checkout.js`, **fora do diff** | Bug | Os testes pegam. A IA só pega se por conta própria for buscar quem chama | **4 · Repositório**: a regra 4 manda listar quem chama (bônus: só explicamos) |
| 2 | O ticket diz "100 **ou mais**", o código usa `> 100` (o pedido de exatamente R$ 100 paga frete) | `src/frete.js` | Regra de negócio | **Não tem como saber** sem o requisito | **3 · Requisito**: lê a issue #1 ligada ao PR |
| 3 | Os números `100` e `5` soltos no código | `src/frete.js` | Smell | Pode apontar por conta própria | **2 · Skill clean-code** (números mágicos) |
| 4 | O nome `totais` não começa com verbo | `src/pedidos.js` | Smell | Provavelmente não aponta | **2 · Skill clean-code** (nomes) |
| 5 | O comentário "Frete grátis a partir de R$ 100" sumiu | `src/frete.js` | Smell | Pode apontar | **2 · Skill clean-code** (comentário que sumiu) |
| 6 | `console.log` no código | `src/pedidos.js` | Padrão do time | Provavelmente não aponta | **1 · Regras do time** (regra 3) |
| 7 | As funções usam camelCase (`calcularFrete`, `calcularTotal`), e o time usa snake_case | `src/frete.js`, `src/checkout.js` | Padrão do time | **Não tem como saber** sem a regra | **1 · Regras do time** (regra 1: snake_case) |
| 8 | A função nova não tem teste | `src/pedidos.js` | Padrão do time | Provavelmente não aponta | **1 · Regras do time** (regra 2) |

A IA não é determinística: **teste na véspera e guarde os prints** das duas rodadas. Os itens 2, 3 e 7 são os mais seguros pra mostrar a diferença, porque sem contexto a IA não tem como saber.

## Setup (uma vez, ~10 min)

1. **Crie um repositório vazio no GitHub** (de preferência privado) e suba este projeto na branch `main`:
   ```bash
   git init -b main
   git add . && git commit -m "chore: projeto de demonstração"
   gh repo create pr-review-demo --private --source=. --push
   ```
2. **Instale o app do Claude no repositório.** O jeito rápido: abra o Claude Code dentro do projeto e rode `/install-github-app`. Ele instala o app e cria o segredo `ANTHROPIC_API_KEY`. Ou instale em https://github.com/apps/claude e crie o segredo à mão em Settings → Secrets and variables → Actions.
3. **Abra o PR da rodada 1:**
   ```bash
   bash demo/open-demo-pr.sh
   ```
   (Sem o `gh`: crie a branch `feat/ajuste-frete`, copie o conteúdo de `demo/pr-change/src/` pra dentro de `src/`, suba e abra o PR colando `demo/pr-description.md` na descrição.)
   **Jeito visual (recomendado pra apresentar):** rode `bash demo/prepare-branch.sh` na véspera. Ele só empurra a branch `feat/ajuste-frete`, **sem abrir o PR**. No dia, no GitHub: Pull requests → **Compare & pull request** → cole o conteúdo de `demo/pr-description.md` na descrição → Create pull request. O review começa sozinho.
4. **Crie a issue #1** no repositório (aba Issues > New issue), com o título e o corpo de `demo/context/issue-requisito.md`. Ela precisa ser a primeira issue (ou ajuste o `Closes #1` na descrição do PR).
5. Aba **Actions**: o workflow "AI Review" roda sozinho. Em 1 a 3 minutos aparecem os comentários, e o CI fica vermelho por causa dos testes.

## Roteiro da demo

**Rodada 1 (~3 min, bloco do PR):**
1. Mostre o diff e peça palpites: o que a IA vai achar? (A turma levanta a mão por categoria.)
2. Mostre a aba Actions rodando e depois os comentários.
3. Pergunte pra turma em cada comentário: aplica, descarta ou discute? (mão levantada, sem cartões)
4. **Anote o que ela NÃO apontou.** Isso é o que a rodada 2 vai comparar.

**Rodada 2 (~2,5 min, bloco de contexto, "Sua vez"):**
1. **Deixe a regra 1 aberta pra turma.** Faça um voto de mão entre 3 regras que este código mostra na hora: **snake_case** (`calcularFrete` vira `calcular_frete`), **JSDoc em toda função** e **aspas duplas** (o código usa simples). Um voluntário digita a escolhida na linha 1 do `CLAUDE.md`. Se ninguém escolher, vai de snake_case. Evite regras sem o que pegar neste código (funções com até N linhas, mensagens de erro em português). SOLID é a mais ousada, mas menos previsível.
2. No GitHub, abra o `CLAUDE.md` **na branch do PR** (botão de editar) e escreva as regras. Se a turma não ditar, cole o conteúdo de `demo/context/CLAUDE.md`. Faça commit direto na branch.
3. Crie a skill: na branch do PR, Add file > Create new file, caminho `.claude/skills/clean-code/SKILL.md`, e cole `demo/context/skills/clean-code/SKILL.md`. Faça commit na branch.
3b. Edite a **descrição do PR** e acrescente `Closes #1` (`demo/context/pr-description-com-requisito.md`). O GitHub mostra a issue ligada ao PR.
4. O commit dispara o workflow de novo. Em 1 a 3 minutos chegam comentários novos. Siga pros próximos slides enquanto roda.
5. No slide "Antes e depois do contexto", compare as duas rodadas.

Editar só a descrição do PR **não** dispara o workflow, por isso o commit é o gatilho. Como são 2 commits (`CLAUDE.md` e a skill), o workflow tem `concurrency` com `cancel-in-progress`: só o último review vale.

## Plano B

| Situação | O que fazer |
|---|---|
| Sem chave de API | Review do Copilot: Settings → Rules → Rulesets → nova regra pra branch `main` e ative a opção de pedir review do Copilot automaticamente (confira o nome exato na tela, a interface muda). Precisa de plano do Copilot com code review. O Copilot lê `.github/copilot-instructions.md` da branch base do PR, então a versão completa tem que entrar na `main` antes |
| Sem internet na sala | Use os prints das duas rodadas, tirados na véspera |
| A IA não comentou nada | Mostre os prints da véspera e fale do que ela costuma achar |

## Cuidados

- **Teste na véspera.** O review pode demorar e a interface do GitHub muda.
- **Confirme** se a Action lê o `CLAUDE.md` da branch do PR (o esperado, pelo checkout do workflow) ou só o da `main`. Se for só o da `main`, a regra tem que entrar na `main` antes da rodada 2.
- **Custo:** cada execução gasta tokens da API e minutos do Actions. Este projeto é minúsculo, então o gasto é baixo.
- **PR vindo de fork não recebe o segredo.** Faça a demo com branch dentro do mesmo repositório.
- **Confira os nomes dos parâmetros** da action (`anthropic_api_key`, `prompt`, `claude_args`, ferramentas liberadas) na documentação oficial na semana do workshop: https://code.claude.com/docs/en/github-actions
- Não rode isso em repositório do trabalho sem aprovação da empresa. O código vai pra um LLM.

## Checklist da véspera

- [ ] Repositório criado (privado), projeto na `main`, app do Claude instalado, segredo `ANTHROPIC_API_KEY` criado
- [ ] Branch `feat/ajuste-frete` empurrada (`demo/prepare-branch.sh`), **sem PR aberto**
- [ ] **Rodada 1** feita (só o diff): comentários chegaram, print tirado, anotado o que a IA não apontou
- [ ] CI vermelho por causa dos testes (print)
- [ ] **Rodada 2** feita (regras + requisito): print tirado, comparado com a rodada 1
- [ ] Confirmado se a Action lê o `CLAUDE.md` da branch do PR
- [ ] Issue #1 criada, e a Action leu a issue ligada ao PR (`gh issue view`)
- [ ] Skill `clean-code` carregou na Action? Se não, o primeiro suspeito é a lista `--allowedTools` (a ferramenta `Skill`); se ainda assim não carregar, cole as 4 linhas dela no `CLAUDE.md`
- [ ] Testado com 2 regras ditadas (ex.: siga SOLID, funções com até 20 linhas) pra saber o que a IA devolve
- [ ] PR da rodada 1 reaberto ou recriado limpo pro dia (pra a rodada 2 acontecer ao vivo)
- [ ] Notebook logado no GitHub, com as abas do PR e do Actions já abertas
- [ ] Internet testada na sala (ou hotspot do celular como reserva)

## Trocando pelas regras do seu time

Edite `demo/context/CLAUDE.md` (e copie pra `demo/context/copilot-instructions.md`). O Copilot só lê os primeiros 4.000 caracteres do arquivo e usa a versão da branch de destino do PR.
