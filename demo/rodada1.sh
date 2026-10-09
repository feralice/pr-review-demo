#!/usr/bin/env bash
# Rodada 1: a IA recebe só o diff, sem ferramentas pra abrir arquivos.
# --setting-sources project,local deixa de fora as configurações e plugins do
# seu usuário (~/.claude), pra que só o contexto do repositório entre.
set -e
git diff main...HEAD | claude -p "Revise este diff: bugs e code smells." \
  --tools "" --setting-sources project,local
