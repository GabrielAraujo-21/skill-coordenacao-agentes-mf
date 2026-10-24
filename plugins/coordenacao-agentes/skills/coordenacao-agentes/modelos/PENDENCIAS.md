# Pendências do projeto

**Documento canônico das pendências** (criado em {{DATA}}): tudo o que ainda falta, de onde veio, do que depende e quem precisa agir. As pendências são eliminadas uma a uma, e o agente que conclui uma atualiza este documento no mesmo commit. A coordenação entre agentes (quem está atuando em quê agora) fica em [`COORDENACAO-AGENTES.md`](COORDENACAO-AGENTES.md); os detalhes de cada entrega ficam no commit, na documentação e no aceite.

Atualizado em: **{{DATA}}**.

## Como usar

- **ID:** `{{PREFIXO}}-NN`, sequencial; números nunca são reaproveitados. Pendência nova descoberta no caminho entra com o próximo número.
- **Situação:** `aberta` (pronta para agir), `bloqueada` (depende de outra pendência ou de algo externo), `em andamento` (com o agente e a data) ou `aguarda o usuário` (decisão, aceite ou autorização).
- **Quem age:** `agente` (pode ser feito por um agente, seguindo `AGENTS.md` e `COORDENACAO-AGENTES.md`), `usuário` (decisão, aceite ou autorização), `externo` (fornecedor, outro sistema, infraestrutura). Combinações como `usuário → agente` indicam a ordem.
- **Ao iniciar:** mudar a situação para `em andamento` e registrar a atuação no quadro do `COORDENACAO-AGENTES.md`.
- **Ao concluir:** tirar a linha das abertas e acrescentar uma linha curta em **Concluídas**, com a data e o commit, no mesmo commit da entrega.
- **Decisões do usuário:** levadas uma por vez, com explicação simples, opções e recomendação; cada decisão é registrada em Concluídas antes da próxima, e o trabalho que ela gerar vira pendência nova.
- Este documento não comprova implementação: vale o que está no código, nos testes e nos registros de aceite.

## Abertas

### Implementação

| ID | Pendência | Origem | Depende de | Quem age | Situação |
|---|---|---|---|---|---|

### Decisões e aceites do usuário

| ID | Pendência | Origem | Depende de | Quem age | Situação |
|---|---|---|---|---|---|

### Autorizações, infraestrutura e dependências externas

| ID | Pendência | Origem | Depende de | Quem age | Situação |
|---|---|---|---|---|---|

## Concluídas

Registro curto; o detalhe está no commit e na documentação da entrega.

| Data | O que foi concluído | Commit |
|---|---|---|
