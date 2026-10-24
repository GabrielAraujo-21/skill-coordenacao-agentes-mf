# Coordenação de agentes (LLMs)

Skill para coordenar **vários agentes de IA trabalhando no mesmo projeto** e conduzir as **decisões do usuário** sem confusão. Funciona com o Claude Code (como skill ou plugin) e serve de protocolo para qualquer outro agente que leia `AGENTS.md`.

Instalada num projeto, ela cria e mantém na raiz:

| Arquivo | O que guarda |
|---|---|
| `COORDENACAO-AGENTES.md` | Protocolo, **quadro de atuação** (agente, frente, situação, desde/até, arquivos reservados), critério de delegação, instruções para quem assume e notas por agente. Só o que está acontecendo agora. |
| `PENDENCIAS.md` | Lista canônica do que falta: ID, origem, dependência, **quem age** (agente, usuário, externo), **situação** (aberta, bloqueada, em andamento, aguarda o usuário) e a tabela **Concluídas** (data e commit). |
| `AGENTS.md` ou `CLAUDE.md` | Um trecho de regra (entre marcadores) mandando consultar os dois documentos antes de iniciar e atualizá-los ao iniciar, pausar e concluir. |

## Como funciona

1. **Antes de iniciar**, o agente lê o quadro e as pendências; não toca no que outro agente reservou nem em trabalho alheio não commitado.
2. **Ao iniciar**, registra a própria linha no quadro (frente, data e arquivos reservados).
3. **Ao pausar**, marca a linha como pausada, com o commit e o que falta, e libera as reservas.
4. **Ao concluir**, no mesmo commit da entrega, remove a própria linha e move a pendência para **Concluídas**.
5. Cada agente edita só as próprias linhas.
6. **Decisões do usuário** são levadas **uma por vez**, explicadas de forma muito simples (como para uma criança de 10 anos), com as opções e a recomendação; cada decisão é registrada antes da próxima.

## Instalação

São dois caminhos; escolha um.

### 1. Plugin do Claude Code (pelo marketplace deste repositório)

Instala a skill para o seu usuário (vale em todos os projetos) ou só para um projeto.

No Claude Code:

```text
/plugin marketplace add GabrielAraujo-21/coordenacao-agentes-mf
/plugin install coordenacao-agentes@coordenacao-agentes-mf
```

Ou pelo terminal:

```bash
claude plugin marketplace add GabrielAraujo-21/coordenacao-agentes-mf
```

```bash
claude plugin install coordenacao-agentes@coordenacao-agentes-mf
```

Para instalar só num projeto (fica registrado no `.claude/settings.json` dele), acrescente `--scope project` ao `install`. Para atualizar depois: `claude plugin marketplace update coordenacao-agentes-mf`.

Com o plugin, a skill aparece como `coordenacao-agentes:coordenacao-agentes`.

### 2. Instalador (copia a skill para `.claude/skills/` do projeto)

A skill passa a fazer parte do projeto (pode ser versionada com ele) e qualquer pessoa que abrir o projeto no Claude Code já a tem.

Linux, macOS ou Git Bash, a partir de um clone:

```bash
git clone https://github.com/GabrielAraujo-21/coordenacao-agentes-mf.git
```

```bash
./coordenacao-agentes-mf/install.sh /caminho/do/projeto --com-documentos
```

Sem clonar:

```bash
curl -fsSL https://raw.githubusercontent.com/GabrielAraujo-21/coordenacao-agentes-mf/main/install.sh | bash -s -- /caminho/do/projeto --com-documentos
```

Windows (PowerShell), a partir de um clone:

```powershell
.\coordenacao-agentes-mf\install.ps1 -Projeto C:\caminho\do\projeto -ComDocumentos
```

Opções do instalador:

| Bash | PowerShell | Efeito |
|---|---|---|
| `--com-documentos` | `-ComDocumentos` | Também cria `COORDENACAO-AGENTES.md` e `PENDENCIAS.md` (se não existirem) e insere a regra no `AGENTS.md` ou `CLAUDE.md` (cria os dois se nenhum existir). |
| `--prefixo X` | `-Prefixo X` | Prefixo dos IDs das pendências (padrão `P`). Útil quando dois projetos se coordenam (`P-NN` e `E-NN`). |
| `--forcar` | `-Forcar` | Substitui uma instalação anterior da skill. |

O instalador nunca sobrescreve documentos existentes e não insere a regra duas vezes.

## Primeiro uso

Abra o projeto no Claude Code e peça:

> Use a skill coordenacao-agentes para iniciar a coordenação neste projeto.

O agente cria o que faltar, ajusta o critério de delegação e as instruções com os comandos de teste reais do projeto e, se você já tiver uma lista do que falta, traz para o `PENDENCIAS.md`. Depois disso, basta pedir coisas como:

- "O que falta fazer?"
- "Assuma a próxima pendência que um agente pode fazer."
- "Vamos decidir as pendências que dependem de mim."

## Estrutura do repositório

```text
.claude-plugin/marketplace.json          marketplace (lista o plugin)
plugins/coordenacao-agentes/
  .claude-plugin/plugin.json             manifesto do plugin
  skills/coordenacao-agentes/
    SKILL.md                             instruções da skill
    modelos/COORDENACAO-AGENTES.md       modelo do quadro de atuação
    modelos/PENDENCIAS.md                modelo da lista de pendências
    modelos/trecho-regra.md              trecho para AGENTS.md / CLAUDE.md
install.sh                               instalador (Bash)
install.ps1                              instalador (PowerShell)
```

Para conferir os manifestos: `claude plugin validate .` e `claude plugin validate plugins/coordenacao-agentes`.
