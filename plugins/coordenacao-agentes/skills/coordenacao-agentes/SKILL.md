---
name: coordenacao-agentes
description: Coordena vários agentes (LLMs) trabalhando no mesmo projeto e conduz as decisões do usuário. Cria e mantém na raiz do projeto o COORDENACAO-AGENTES.md (protocolo, quadro de atuação, critério de delegação, notas por agente), o PENDENCIAS.md (lista canônica com IDs, quem age, situação e Concluídas) e a regra no AGENTS.md ou CLAUDE.md. Use ao instalar a coordenação num projeto, antes de iniciar, ao pausar ou ao concluir uma frente de trabalho, ao registrar ou concluir uma pendência, ao ver o que falta fazer e ao levar decisões ao usuário.
---

# Coordenação de agentes

Esta skill organiza o trabalho de mais de um agente (LLM) no mesmo projeto. Ela mantém dois documentos na raiz do projeto e uma regra no arquivo de instruções dos agentes:

| Documento | Para que serve |
|---|---|
| `COORDENACAO-AGENTES.md` | Quem está atuando em quê **agora**: protocolo, quadro de atuação, critério de delegação, instruções para quem assume e notas por agente. Não é histórico. |
| `PENDENCIAS.md` | **Tudo o que falta**: lista canônica com ID, origem, dependência, quem age e situação, mais a tabela **Concluídas** (data e commit). |
| `AGENTS.md` ou `CLAUDE.md` | O trecho de regra que manda consultar os dois documentos antes de iniciar e atualizá-los ao iniciar, pausar e concluir. |

Os modelos ficam na pasta `modelos/` ao lado deste arquivo. Escreva no idioma do usuário (os modelos estão em português do Brasil).

## 1. Instalar no projeto (primeira vez)

Faça só o que faltar; nunca sobrescreva um documento que já existe.

1. Descubra a raiz do projeto (`git rev-parse --show-toplevel`, ou a pasta de trabalho).
2. Se `COORDENACAO-AGENTES.md` não existir na raiz, copie `modelos/COORDENACAO-AGENTES.md` e troque `{{DATA}}` pela data de hoje (AAAA-MM-DD).
3. Se `PENDENCIAS.md` não existir, copie `modelos/PENDENCIAS.md`, troque `{{DATA}}` e `{{PREFIXO}}`. O prefixo dos IDs é `P` por padrão; se o usuário tiver mais de um projeto coordenado, sugira um prefixo por projeto (por exemplo `P` e `E`) para as pendências que cruzam os dois poderem citar o ID do outro lado.
4. Insira o trecho de `modelos/trecho-regra.md` no arquivo de instruções dos agentes:
   - use o `AGENTS.md` da raiz se existir; senão o `CLAUDE.md`; se nenhum existir, crie o `AGENTS.md` e um `CLAUDE.md` com a linha `@AGENTS.md`;
   - se os marcadores `<!-- coordenacao-agentes:inicio -->` e `<!-- coordenacao-agentes:fim -->` já existirem, substitua só o que está entre eles; senão, acrescente o trecho no fim;
   - se o arquivo já tiver uma regra equivalente escrita à mão, não duplique: mostre a diferença ao usuário.
5. Ajuste no `COORDENACAO-AGENTES.md` a seção "Critério para delegar" e as "Instruções para quem assumir" com o que o projeto realmente usa (como rodar os testes, onde ficam as decisões e as especificações). Não invente comando nem documento: investigue o projeto; o que não souber, deixe como `(a definir)` e diga ao usuário.
6. Se o usuário já tiver uma lista de pendências (num documento, em issues, na conversa), traga para o `PENDENCIAS.md` com IDs sequenciais, citando a origem.
7. Faça o commit desses arquivos só se o usuário pedir ou se o projeto mandar commitar cada entrega; nunca faça push sem pedido.

## 2. Antes de iniciar qualquer frente de trabalho

1. Leia o **quadro de atuação** do `COORDENACAO-AGENTES.md` e as **Abertas** do `PENDENCIAS.md`.
2. Não atue numa frente que outro agente marcou **em atuação**, nem toque nos arquivos ou áreas que ele reservou.
3. Não mexa em trabalho alheio não commitado (confira `git status`); se a mudança não é sua, deixe como está e trabalhe em outra pasta ou worktree.
4. Escolha uma pendência que atenda ao **critério para delegar**. Se nenhuma atender, diga ao usuário o que bloqueia cada uma.

## 3. Ao iniciar

- Acrescente **uma linha** no quadro: agente (nome e ferramenta, por exemplo "Claude Code, sessão de 2026-10-24"), frente e pendência (ID), situação `em atuação`, data de início e os arquivos ou áreas reservados (o mínimo necessário).
- No `PENDENCIAS.md`, mude a situação da pendência para `em andamento (agente, data)`.
- Se o trabalho tiver contexto que o próximo agente precisaria, abra uma seção curta com o seu nome em **Notas dos agentes**.
- Quando houver mais de um agente ativo, registre a linha antes de editar código (de preferência num commit pequeno), para o outro ver a reserva.

## 4. Ao pausar

- Atualize a **própria** linha: situação `pausada`, o commit (se houver), o que falta e reservas `nenhuma`. A partir daí outro agente pode assumir.
- No `PENDENCIAS.md`, volte a situação para `aberta` (ou `bloqueada`, dizendo do quê), com uma frase sobre o que já foi feito.

## 5. Ao concluir

No **mesmo commit** da entrega:

1. Remova do `COORDENACAO-AGENTES.md` a própria linha do quadro e as próprias notas daquela frente. O registro da conclusão fica na entrega (commit, documentação, aceite); manter aqui faria o documento crescer sem necessidade.
2. No `PENDENCIAS.md`, tire a pendência das **Abertas** e acrescente uma linha curta em **Concluídas**: data, ID e o que foi feito, e o commit. Se o hash só existir depois do commit, escreva `este commit` e, se o projeto pedir, corrija num commit seguinte.
3. Pendência nova descoberta no caminho entra nas Abertas com o **próximo número** (os números nunca são reaproveitados).
4. Atualize a data "Atualizado em" do `PENDENCIAS.md`.

## 6. Regras de convivência

- Cada agente edita **só as próprias linhas e notas**; nunca as de outro. Se uma reserva parecer abandonada, pergunte ao usuário antes de assumir.
- Registros curtos. Nada de relato longo nos dois documentos.
- Os documentos não comprovam implementação: vale o que está no código, nos testes e nos aceites.
- Não promova uma pendência para concluída sem evidência (teste rodado, commit, aceite).
- Se dois projetos se coordenam, o trabalho que cruza os dois entra nos dois quadros, citando o ID da pendência do outro lado.

## 7. Decisões do usuário: uma por vez

Quando o trabalho depender de uma decisão do usuário (as pendências com **Quem age = usuário** e situação `aguarda o usuário`):

1. **Uma decisão por vez.** Nunca empilhe várias perguntas na mesma mensagem.
2. **Explique de um jeito muito simples**, como para uma criança de 10 anos: o que é a coisa, por que precisa decidir agora e o que muda na prática. Use uma comparação do dia a dia quando ajudar. Sem jargão; se um termo técnico for inevitável, explique-o em uma frase.
3. **Dê as opções** (de duas a quatro), cada uma com o que ganha e o que perde, em uma ou duas frases.
4. **Diga a sua recomendação** e o motivo, e marque-a como recomendada. Na dúvida, recomende a opção mais conservadora e reversível. Prefira ferramentas sem mensalidade quando servirem.
5. Se a ferramenta de perguntas estiver disponível (por exemplo `AskUserQuestion`), use-a com a recomendada como primeira opção.
6. **Registre a decisão antes de passar à próxima:** no `PENDENCIAS.md`, mova a pendência de decisão para Concluídas ("decidida pelo usuário: …", data e commit) e, se a decisão gerar trabalho, crie a pendência nova com o próximo número, citando a de origem. Registre também onde o projeto guarda decisões (ADR, documento de decisões, especificação), com a data.
7. Só então leve a próxima decisão.

Modelo de mensagem:

> **Decisão 1 de 3 — {assunto curto}**
>
> {Explicação simples em duas a quatro frases.}
>
> - **Opção A (recomendada):** {o que acontece}. {Ganha / perde.}
> - **Opção B:** {o que acontece}. {Ganha / perde.}
>
> Recomendo a A porque {motivo em uma frase}.

## 8. Ver o que falta

Quando o usuário perguntar o que falta, responda a partir do `PENDENCIAS.md`, agrupado por quem age: primeiro o que depende dele (decisões e autorizações, na ordem em que destravam mais trabalho), depois o que um agente pode fazer agora, depois o que é externo ou está bloqueado.
