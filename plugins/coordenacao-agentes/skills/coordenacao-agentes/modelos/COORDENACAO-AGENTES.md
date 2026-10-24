# Coordenação entre agentes

**Documento canônico de coordenação** entre os agentes (LLMs) que trabalham neste repositório (criado em {{DATA}}; a regra também está no `AGENTS.md` ou `CLAUDE.md`, seção "Coordenação entre agentes"). Ele diz **quem está atuando em quê agora** e **o que ainda pode ser assumido**. Não é histórico: o que foi entregue fica registrado no commit, na documentação da entrega e no aceite do usuário. Este documento não comprova implementação.

Partes: o **protocolo** (como usar), o **quadro de atuação** (quem está em quê), o **critério** de delegação (as pendências estão no [`PENDENCIAS.md`](PENDENCIAS.md)), as **instruções** para quem assume um item e, no fim, as **notas de cada agente** sobre o trabalho em andamento.

## Protocolo de coordenação

1. **Antes de iniciar** uma frente de trabalho (ou uma pendência), ler este documento e o `PENDENCIAS.md`. Não atuar numa frente que outro agente marcou **em atuação** nem tocar nos arquivos que ele reservou, nem em trabalho alheio não commitado.
2. **Ao iniciar**, acrescentar uma linha no quadro: agente, frente e pendência, situação **em atuação**, data de início e arquivos ou áreas reservados; no `PENDENCIAS.md`, situação **em andamento**.
3. **Ao pausar**, atualizar a própria linha: situação **pausada**, com o commit (se houver) e o que falta, e reservas "nenhuma". A partir daí o agente não está mais atuando naquela frente e outro pode assumi-la.
4. **Ao concluir**, **remover** do documento a própria linha do quadro e as próprias notas sobre aquela frente, e mover a pendência para **Concluídas** no `PENDENCIAS.md`, **no mesmo commit da entrega**. O registro da conclusão fica na entrega; manter aqui faria o documento crescer sem necessidade.
5. Registros curtos. Cada agente edita só as próprias linhas e notas; nunca as de outro.

## Quadro de atuação

| Agente | Frente e pendência | Situação | Desde / até | Arquivos ou áreas reservados |
|---|---|---|---|---|

## Critério para delegar

Uma pendência pode ser assumida por um agente quando reúne as quatro condições:

1. **Não precisa de decisão nova do usuário:** a documentação já diz o que fazer.
2. **Não toca arquivos reservados** por outro agente no quadro de atuação.
3. **Não exige download, segredo, conta externa, pagamento nem implantação** sem autorização do usuário.
4. **É verificável localmente** (testes: `(a definir)`).

## Pendências e quem pode assumir

A lista canônica das pendências está em [`PENDENCIAS.md`](PENDENCIAS.md). Um agente pode assumir as que lá têm **Quem age = agente** e situação **aberta**, desde que atendam ao critério acima e não estejam reservadas no quadro de atuação. Ao concluir, o agente atualiza o `PENDENCIAS.md` no mesmo commit.

## Instruções para quem assumir um item

- Ler primeiro o `AGENTS.md` (ou `CLAUDE.md`) e a documentação citada na origem da pendência.
- Procurar o que já existe antes de criar algo novo; não criar caminho paralelo para a mesma regra.
- Trabalhar numa **worktree ou branch própria** quando houver outro agente ativo, sem tocar nos arquivos reservados nem no trabalho alheio não commitado.
- Rodar as verificações do projeto nos arquivos alterados: `(a definir)`.
- Registrar escolhas não aprovadas como **provisórias**, com a data, onde o projeto guarda decisões: `(a definir)`.
- Commit **local**; **sem push e sem PR** sem pedido do usuário. Nada de download, segredo ou implantação sem autorização.
- Ao entregar, informar: o que mudou, arquivos, evidências de verificação, pendências e riscos.

## Notas dos agentes

Uma seção por agente, só com o trabalho em andamento; removida quando ele conclui (protocolo, item 4).
