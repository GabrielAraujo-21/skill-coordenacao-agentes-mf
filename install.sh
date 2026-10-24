#!/usr/bin/env bash
# Instala a skill coordenacao-agentes em .claude/skills/ de um projeto.
#
# Uso:
#   ./install.sh [PASTA_DO_PROJETO] [--com-documentos] [--prefixo P] [--forcar]
#
#   PASTA_DO_PROJETO  raiz do projeto (padrão: pasta atual)
#   --com-documentos  também cria COORDENACAO-AGENTES.md e PENDENCIAS.md na raiz
#                     (se não existirem) e insere a regra no AGENTS.md/CLAUDE.md
#   --prefixo X       prefixo dos IDs das pendências (padrão: P)
#   --forcar          substitui uma instalação anterior da skill
#
# Sem clonar o repositório:
#   curl -fsSL https://raw.githubusercontent.com/GabrielAraujo-21/coordenacao-agentes-mf/main/install.sh | bash -s -- /caminho/do/projeto --com-documentos
set -euo pipefail

REPO_URL="https://github.com/GabrielAraujo-21/coordenacao-agentes-mf.git"
NOME="coordenacao-agentes"

projeto="."
com_documentos=0
prefixo="P"
forcar=0
while [ $# -gt 0 ]; do
  case "$1" in
    --com-documentos) com_documentos=1 ;;
    --prefixo) shift; prefixo="${1:?--prefixo precisa de um valor}" ;;
    --forcar) forcar=1 ;;
    -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
    -*) echo "Opção desconhecida: $1" >&2; exit 2 ;;
    *) projeto="$1" ;;
  esac
  shift
done

[ -d "$projeto" ] || { echo "Pasta não encontrada: $projeto" >&2; exit 1; }
projeto="$(cd "$projeto" && pwd)"

# Origem: a cópia ao lado deste script ou um clone temporário.
origem=""
dir_script="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$dir_script" ] && [ -f "$dir_script/plugins/$NOME/skills/$NOME/SKILL.md" ]; then
  origem="$dir_script/plugins/$NOME/skills/$NOME"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --depth 1 --quiet "$REPO_URL" "$tmp/repo"
  origem="$tmp/repo/plugins/$NOME/skills/$NOME"
fi

destino="$projeto/.claude/skills/$NOME"
if [ -e "$destino" ] && [ "$forcar" -ne 1 ]; then
  echo "A skill já está instalada em $destino (use --forcar para substituir)."
else
  rm -rf "$destino"
  mkdir -p "$(dirname "$destino")"
  cp -R "$origem" "$destino"
  echo "Skill instalada em $destino"
fi

if [ "$com_documentos" -eq 1 ]; then
  hoje="$(date +%F)"
  for doc in COORDENACAO-AGENTES.md PENDENCIAS.md; do
    if [ -e "$projeto/$doc" ]; then
      echo "$doc já existe; mantido."
    else
      sed -e "s/{{DATA}}/$hoje/g" -e "s/{{PREFIXO}}/$prefixo/g" "$origem/modelos/$doc" > "$projeto/$doc"
      echo "$doc criado."
    fi
  done

  if [ -f "$projeto/AGENTS.md" ]; then
    regras="$projeto/AGENTS.md"
  elif [ -f "$projeto/CLAUDE.md" ]; then
    regras="$projeto/CLAUDE.md"
  else
    regras="$projeto/AGENTS.md"
    printf '# AGENTS.md\n' > "$regras"
    [ -e "$projeto/CLAUDE.md" ] || printf '@AGENTS.md\n' > "$projeto/CLAUDE.md"
    echo "AGENTS.md e CLAUDE.md criados."
  fi
  if grep -q 'coordenacao-agentes:inicio' "$regras"; then
    echo "$(basename "$regras") já tem a regra de coordenação; mantido."
  else
    printf '\n' >> "$regras"
    cat "$origem/modelos/trecho-regra.md" >> "$regras"
    echo "Regra de coordenação acrescentada ao $(basename "$regras")."
  fi
fi

echo
echo "Pronto. Abra o projeto no Claude Code e peça: \"use a skill coordenacao-agentes para iniciar a coordenação\"."
