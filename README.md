# pr-review-demo

Projeto pequeno (Node.js, sem dependências) pra demonstrar **como dar contexto a uma IA que revisa código**, ao vivo, na **CLI** (Claude Code). A mesma ideia vale pra qualquer CLI de IA.

Duas rodadas, mesmo código, mesma IA:
1. **Rodada 1:** a IA revisa só o diff (o `CLAUDE.md` é o mínimo, sem skills).
2. **Rodada 2:** você dá contexto (regras do time, 3 skills e a issue do requisito) e ela revisa de novo com o comando `/review`.

## Subir pro GitHub

Precisa de `git`, Node.js 18+ e o GitHub CLI (`gh`). Faça `gh auth login` uma vez.

```bash
unzip pr-review-demo.zip && cd pr-review-demo
git init -b main
git add . && git commit -m "chore: projeto de demonstração"
gh repo create pr-review-demo --public --source=. --remote=origin --push
bash demo/create-issue.sh        # cria a issue #1 (o requisito). Precisa ser a primeira
bash demo/prepare-branch.sh      # cria e empurra a branch feat/ajuste-frete (o "PR")
```

O repositório fica **público**, porque o CodeRabbit só é gratuito assim (o código da demo é inofensivo). Se você já criou privado: `gh repo edit --visibility public --accept-visibility-change-consequences`.

## Demo local (a principal)

Na pasta do projeto, na branch do PR: `git checkout feat/ajuste-frete`. Antes de começar: `bash demo/preflight.sh`.

Os scripts chamam o `claude` com `--setting-sources project,local`, que deixa de fora as configurações, os plugins e o `CLAUDE.md` do seu usuário (`~/.claude`). Assim só entra o contexto do repositório.

**Rodada 1: só o diff (link do PR + MCP do GitHub)**

É o que o pessoal faz no dia a dia: cola o link do PR e o Claude busca o diff pelo MCP do GitHub.

```bash
export GITHUB_PAT=...            # fine-grained, só este repo, leitura de PRs e issues (sem ele, usa o gh auth token)
bash demo/rodada1-mcp.sh
> Revise este PR: bugs e code smells. <link do PR>
```

O link é o do PR da `feat/frete-pedidos`, aberto com o CodeRabbit **desativado** no repo, então a IA não tem comentário dele pra copiar. O CodeRabbit marca o commit, não o PR: um PR novo em cima de um commit que ele já revisou herda o check "Review completed". Se precisar refazer, ponha um commit novo na branch (`git merge main`).

O script abre o `claude` numa **pasta vazia**, sem Read/Grep/Bash, só com o MCP do GitHub em modo leitura e expondo uma única ferramenta, o `pull_request_read`: o diff. Quando ela pedir permissão pra ele, aprove e mostre na tela que ela foi buscar só o diff.

Anote o que ela **não** apontou. O `npm test` passa: o código funciona, só não faz o que o cliente pediu.

**Plano B (sem rede ou sem MCP):** `bash demo/rodada1.sh`, que é `git diff main...HEAD | claude -p "Revise este diff: bugs e code smells." --tools ""`. Mesmo resultado, com o diff local.

**Rodada 2: com contexto**
1. A turma escolhe a regra 1 (voto de mão): **snake_case**, **JSDoc em toda função** ou **aspas duplas**. Se ninguém escolher, vai de snake_case.
2. `bash demo/add-context.sh "Toda função tem JSDoc"` copia o `CLAUDE.md` completo, as 3 skills e o comando `/review`, e põe a regra da turma no lugar da regra 1. Sem argumento, fica snake_case.
3. Abra uma sessão **nova**: `bash demo/rodada2.sh`. Rode `/review 1` (o `1` é a issue com o requisito).
4. Compare com a rodada 1.

Pra repetir o ensaio: `bash demo/reset-context.sh` (volta pra rodada 1).

### Quem pega o quê

| Contexto | O que é | Pega |
|---|---|---|
| **1 · Regras do time** (`CLAUDE.md`) | O que só o time decide | `console.log`, snake_case |
| **2 · Skills** (`.claude/skills/`) | `negocio`, `bugs`, `legibilidade` | número solto, valor contra o requisito |
| **3 · Requisito** | A issue #1 do GitHub (`/review 1`) | `100` no código contra "acima de R$ 200" na issue |

## O que está plantado no PR

O PR muda uma função só (`src/frete.js`): compra acima de R$ 100 passa a ter frete grátis.

| # | Problema | Rodada 1 (só o diff) | Rodada 2: quem pega |
|---|---|---|---|
| 1 | O cliente pediu frete grátis **acima de R$ 200**, e o código usa **100** | **Não tem como saber**: 100 parece um número normal | Skill **negocio**, com a issue |
| 2 | `console.log` esquecido | Costuma apontar (o ESLint também pega) | **CLAUDE.md** (regra 3) |
| 3 | `calcularFrete` em camelCase, e o time usa snake_case | **Não tem como saber** | **CLAUDE.md** (regra 1) |
| 4 | O número `100` solto, sem nome | Pode apontar | Skill **legibilidade** |

A IA não é determinística: o que ela devolve só aparece no ensaio. Os itens 1 e 3 são os que mostram a diferença, porque sem contexto ela não tem como saber.

## O que tem aqui

| Arquivo | O que é |
|---|---|
| `src/frete.js`, `src/checkout.js`, `test/` | Código "da loja": frete e total do pedido |
| `CLAUDE.md` e `.claude/settings.json` | A base (rodada 1): regras mínimas e permissões, sem skills |
| `demo/pr-change/src/` | O arquivo "depois" do PR (`frete.js`) |
| `demo/context/` | **O contexto** (rodada 2): `CLAUDE.full.md` e `claude/` com as skills e o `/review`. Os nomes são sem ponto de propósito, pra nenhuma ferramenta ler isso antes da hora |
| `demo/rodada1-mcp.sh` | Rodada 1 pelo link do PR: pasta vazia, só o MCP do GitHub, só o diff |
| `demo/rodada1.sh`, `demo/rodada2.sh` | Rodada 1 com o diff local (plano B) e rodada 2 |
| `demo/add-context.sh`, `demo/reset-context.sh` | Dá e tira o contexto |
| `demo/preflight.sh` | Confere se está tudo pronto pra começar |
| `demo/create-issue.sh`, `demo/prepare-branch.sh`, `demo/open-demo-pr.sh` | Cria a issue #1, a branch do PR e abre o PR |
| `demo/context/issue-requisito.md` | O texto da issue #1 |
| `templates/arquivo-de-instrucoes.md` | Modelo do arquivo de instruções (vai por e-mail) |
| `.github/workflows/ai-review.yml` | O mesmo review numa GitHub Action (só manual, ver abaixo) |
| `.coderabbit.yaml` | Deixa o review do CodeRabbit em português |

## Automático (mostrado funcionando, no capítulo 5): CodeRabbit

É um **app pronto**: instala em uns 2 minutos, **sem workflow e sem chave**, e revisa todo PR sozinho. É gratuito em **repositório público** (em privado, só um teste de 14 dias). Confira o plano em coderabbit.ai/pricing.

**Montar (uma vez):**
1. Deixe o repositório **público** (Settings > General > Danger Zone > Change visibility). O código da demo é inofensivo.
2. Entre em **app.coderabbit.ai/login** com a conta do GitHub, adicione os repositórios e escolha só o `pr-review-demo`.
3. Nada mais: ele já lê o `CLAUDE.md` da raiz (a documentação diz que detecta `CLAUDE.md`, `AGENTS.md` e `copilot-instructions.md` sozinho).

**No dia (ao vivo):** ative o CodeRabbit no repo (`github.com/settings/installations` > CodeRabbit > Configure > adicione o `pr-review-demo` > Save) e abra o PR:
```bash
bash demo/open-demo-pr.sh
```
O script abre o PR no navegador. O CodeRabbit leva de 2 a 5 minutos pra comentar. No ensaio, tire prints pro plano B e depois feche o PR, pra rodar de novo.

**No dia:** abra o PR no navegador e mostre o resumo e os comentários nas linhas. Se quiser rodar de novo, comente `@coderabbitai full review` no PR.

**Bônus (só se ensaiar):** coloque o `CLAUDE.md` completo (`demo/context/CLAUDE.full.md`) na **`main`** e comente `@coderabbitai full review`. Em repositório público, ele aplica só a configuração da branch base, então a regra precisa estar na `main`. Não confirmei se o `CLAUDE.md` segue essa mesma regra de branch: teste antes de prometer.

Skills e o `/review` são do Claude Code: o CodeRabbit não usa. Quem quiser mais controle, pode montar o próprio pipeline (alternativa abaixo).

### Alternativa: pipeline próprio (GitHub Action com Claude)

O workflow `.github/workflows/ai-review.yml` roda o Claude Code num PR. Está como manual (Actions > AI Review > Run workflow, com o número do PR); o comentário no topo do arquivo mostra como fazer rodar em todo PR. Precisa de: o app do Claude (https://github.com/apps/claude), o segredo com o token da assinatura (`claude setup-token` e `gh secret set CLAUDE_CODE_OAUTH_TOKEN`; ou `ANTHROPIC_API_KEY`, trocando a linha do workflow) e um PR aberto. Não confirmei que a Action carrega as skills. Use CLI em Actions só em repositório seu.

## Refazer o ensaio do zero

```bash
git checkout main
git branch -D feat/ajuste-frete && git push origin --delete feat/ajuste-frete
bash demo/prepare-branch.sh
```
Feche o PR antigo no GitHub antes. Entre um ensaio e outro, `bash demo/reset-context.sh` volta a pasta pra rodada 1.

## Plano B

- A CLI não responde ou demora: use os prints da véspera (rodada 1 e rodada 2).
- O MCP do GitHub não conecta (rede, token): `bash demo/rodada1.sh`, com o diff local.
- A skill não carrega: cole as linhas dela no `CLAUDE.md` e rode a rodada 2 assim.
- O `/review` não aparece: confirme que abriu uma sessão **nova** (`bash demo/rodada2.sh`) depois do `add-context.sh` e que `.claude/commands/review.md` existe. Como alternativa, peça: "Aplique as skills negocio, bugs e legibilidade ao diff da branch contra a main".
- Sem o `gh`: crie a issue pelo site e, na rodada 2, cole o requisito no pedido.

## Checklist da véspera

- [ ] Repositório criado (público), issue #1 criada, branch `feat/ajuste-frete` empurrada
- [ ] `claude` abre na pasta e pede só o que é esperado (primeiro uso pede confiar na pasta)
- [ ] `GITHUB_PAT` criado e exportado; `bash demo/rodada1-mcp.sh` abre e o `pull_request_read` aparece
- [ ] Rodada 1 feita pelo link do PR (2 vezes, sessão nova), sem citar o R$ 200, com prints
- [ ] Plano B testado: `bash demo/rodada1.sh`
- [ ] Rodada 2 feita (`add-context.sh`, `rodada2.sh`, `/review 1`), com prints
- [ ] Testadas as 3 regras da lista (snake_case, JSDoc, aspas duplas)
- [ ] As skills carregaram (o review cita negocio, bugs e legibilidade)
- [ ] Repositório público, CodeRabbit instalado e PR aberto com o review feito, com prints (o automático do capítulo 5)
- [ ] `reset-context.sh` rodado e `preflight.sh` sem erro
