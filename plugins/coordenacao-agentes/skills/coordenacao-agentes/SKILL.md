---
name: coordenacao-agentes
description: Coordena vários agentes (LLMs) no mesmo projeto e conduz as decisões do usuário. Cria e mantém na raiz o COORDENACAO-AGENTES.md (quadro de atuação), o PENDENCIAS.md (lista canônica do que falta) e a regra no AGENTS.md ou CLAUDE.md. Use ao instalar a coordenação, ao iniciar, pausar ou concluir uma frente de trabalho, ao perguntar o que falta e ao levar decisões ao usuário.
---

# Coordenação de agentes

Dois documentos na raiz do projeto: `COORDENACAO-AGENTES.md` diz quem está atuando em quê **agora** (não é histórico); `PENDENCIAS.md` lista **tudo o que falta**, com IDs, quem age, situação e a tabela **Concluídas**. Os modelos estão em `modelos/`. Escreva no idioma do usuário.

## 1. Instalar no projeto

Faça só o que faltar; nunca sobrescreva documento existente.

1. Na raiz do projeto, crie `COORDENACAO-AGENTES.md` e `PENDENCIAS.md` a partir dos modelos, trocando `{{DATA}}` pela data de hoje (AAAA-MM-DD) e `{{PREFIXO}}` pelo prefixo dos IDs (`P` por padrão; um prefixo por projeto quando dois projetos se coordenam).
2. Insira `modelos/trecho-regra.md` no `AGENTS.md` (ou no `CLAUDE.md`, se só ele existir; se nenhum existir, crie o `AGENTS.md` e um `CLAUDE.md` com `@AGENTS.md`). Se os marcadores `coordenacao-agentes:inicio/fim` já existirem, substitua só o que está entre eles; se houver regra equivalente escrita à mão, não duplique: mostre a diferença ao usuário.
3. Preencha os `(a definir)` do `COORDENACAO-AGENTES.md` (comandos de verificação, onde ficam as decisões) investigando o projeto. Não invente comando nem documento; o que não descobrir, deixe e avise.
4. Se já houver uma lista do que falta (documento, issues, conversa), traga para o `PENDENCIAS.md` com IDs sequenciais e a origem.

## 2. Ciclo de cada frente de trabalho

| Momento | `COORDENACAO-AGENTES.md` | `PENDENCIAS.md` |
|---|---|---|
| **Antes** | Ler o quadro. Não atuar no que outro agente marcou `em atuação`, não tocar nos arquivos que ele reservou nem em trabalho alheio não commitado (`git status`). | Escolher uma pendência `aberta`, com **Quem age = agente**, que atenda ao critério para delegar. Se nenhuma atender, dizer ao usuário o que bloqueia cada uma. |
| **Ao iniciar** | Acrescentar a própria linha: agente, frente e ID, `em atuação`, data, arquivos reservados (o mínimo). Com outro agente ativo, registrar antes de editar código. | Situação `em andamento (agente, data)`. |
| **Ao pausar** | Própria linha `pausada`, com o commit e o que falta; reservas `nenhuma`. | Voltar a `aberta` (ou `bloqueada`, dizendo do quê), com uma frase do que já foi feito. |
| **Ao concluir** (no commit da entrega) | Remover a própria linha e as próprias notas. | Mover para **Concluídas** (data, ID, o que foi feito, commit; `este commit` se o hash ainda não existir) e atualizar "Atualizado em". |

Regras:

- Cada agente edita **só as próprias linhas e notas**. Reserva que parece abandonada: perguntar ao usuário antes de assumir.
- Pendência nova descoberta entra com o **próximo número**; números nunca são reaproveitados.
- Concluída só com evidência (teste rodado, commit, aceite). Os documentos não comprovam implementação.
- Registros curtos. Commit só se o usuário ou o projeto mandar; push nunca sem pedido.
- Trabalho que cruza dois projetos coordenados entra nos dois quadros, citando o ID do outro lado.

## 3. Decisões do usuário

Para as pendências `aguarda o usuário`:

1. **Uma decisão por vez**; nunca várias perguntas na mesma mensagem.
2. **Explique como para uma criança de 10 anos**: o que é, por que decidir agora e o que muda na prática. Sem jargão; termo técnico inevitável se explica em uma frase.
3. **De duas a quatro opções**, cada uma com o que ganha e o que perde, e **a sua recomendação** com o motivo (na dúvida, a mais conservadora e reversível). Se houver ferramenta de perguntas (como `AskUserQuestion`), use-a com a recomendada em primeiro.
4. **Registre antes da próxima**: mova a pendência para Concluídas ("decidida pelo usuário: …"), crie a pendência do trabalho que a decisão gerar (citando a origem) e anote a decisão, com a data, onde o projeto guarda decisões.

> **Decisão 1 de 3 — {assunto}**
>
> {Explicação simples em duas a quatro frases.}
>
> - **Opção A (recomendada):** {o que acontece; ganha / perde}.
> - **Opção B:** {o que acontece; ganha / perde}.
>
> Recomendo a A porque {motivo}.

## 4. O que falta

Responda a partir do `PENDENCIAS.md`, agrupado por quem age: primeiro o que depende do usuário (na ordem em que destrava mais trabalho), depois o que um agente pode fazer agora, por fim o externo ou bloqueado.
