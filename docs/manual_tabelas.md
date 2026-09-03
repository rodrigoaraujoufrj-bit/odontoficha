# OdontoFlow - Manual de Preenchimento das Tabelas

Última atualização: 2026-06-13

Este manual define como cada tabela deve ser preenchida. Ele deve evoluir junto com o schema do Supabase.

## Padrao Para Cada Tabela

Cada tabela deve ter:

- finalidade
- quando preencher
- quem preenche
- campos obrigatorios
- campos opcionais
- regras de preenchimento
- exemplo de registro

## profissionais

### Finalidade

Guardar os dados basicos do profissional que usa o OdontoFlow.

### Quando preencher

Ao criar a conta ou completar o perfil profissional.

### Quem preenche

O proprio profissional.

### Campos obrigatorios

- `nome`
- `telefone`
- `email`
- `cro`
- `cro_uf`

### Campos opcionais

- `usuario_id` quando o login estiver integrado

### Regras

- E-mail deve conter `@` e ser salvo em minusculo.
- Telefone principal deve ser salvo apenas com digitos.
- Para WhatsApp/celular, exigir 11 digitos: 2 do DDD e 9 do numero.
- CRO deve ser salvo separado da UF.

### Exemplo

```text
nome: Nome do profissional
telefone: 21999999999
email: profissional@example.com
cro: 00000
cro_uf: RJ
```

## consultorios

### Finalidade

Guardar os locais de atendimento do profissional.

### Quando preencher

Ao cadastrar o primeiro local de atendimento ou quando o profissional atender em novo local.

### Quem preenche

Dentista, recepcionista ou secretaria.

### Campos obrigatorios

- `nome`

### Campos opcionais

- `telefone`
- `email`
- `endereco`
- `cidade`
- `uf`
- `observacoes`

### Regras

- Consultorio deve ser tabela separada do paciente.
- Um paciente nao deve guardar o consultorio diretamente como texto livre.
- Se o paciente for vinculado ao consultorio errado, corrigir o vinculo em `paciente_consultorios`.

## profissional_consultorios

### Finalidade

Registrar em quais consultorios um profissional atende.

### Quando preencher

Ao vincular profissional a consultorio.

### Quem preenche

Dentista ou administrador.

### Campos obrigatorios

- `profissional_id`
- `consultorio_id`
- `ativo`

### Regras

- Nao apagar historico sem necessidade.
- Para remover vinculo, preferir marcar `ativo = false`.

## pacientes

### Finalidade

Guardar os dados basicos para localizar paciente, ficha, historico, agenda e financeiro.

### Quando preencher

No primeiro contato, antes do primeiro atendimento ou ao importar um paciente existente.

### Quem preenche

Dentista, recepcionista ou secretaria.

### Campos obrigatorios

- `nome`
- `telefone` ou outro contato principal

### Campos opcionais

- `email`
- `cpf`
- `data_nascimento`
- `observacoes`

### Regras

- O cadastro deve ser rapido.
- CPF nao deve ser obrigatorio no MVP.
- Evitar duplicidade por telefone e nome semelhante.
- E-mail deve conter `@` quando preenchido.
- Telefone deve ser salvo apenas com digitos.
- CPF deve ser salvo apenas com digitos e ter 11 digitos quando preenchido.
- Validacao de digitos verificadores do CPF deve ser implementada antes de uso real amplo.

### Exemplo

```text
nome: Joao da Silva
telefone: (21) 99999-9999
data_nascimento: 1985-04-15
observacoes: prefere contato por WhatsApp
```

## paciente_consultorios

### Finalidade

Vincular paciente a consultorio e profissional sem prender o cadastro principal a um local fixo.

### Quando preencher

Ao cadastrar um paciente em determinado local de atendimento.

### Quem preenche

Dentista, recepcionista ou secretaria.

### Campos obrigatorios

- `paciente_id`
- `consultorio_id`
- `profissional_id`
- `ativo`

### Regras

- Se o paciente for cadastrado no consultorio errado, corrigir esta tabela.
- Nao duplicar paciente apenas para trocar consultorio.
- Um paciente pode ter mais de um vinculo se for atendido em mais de um local.

### Exemplo

```text
paciente_id: <uuid>
consultorio_id: <uuid>
profissional_id: <uuid>
ativo: true
```

## fichas_clinicas

### Finalidade

Guardar informacoes clinicas gerais do paciente.

### Quando preencher

Na primeira avaliacao e atualizar quando houver mudanca relevante.

### Quem preenche

Dentista.

### Campos obrigatorios

- `paciente_id`

### Campos opcionais

- `anamnese`
- `alergias`
- `medicamentos`
- `observacoes_clinicas`

### Regras

- Nao misturar evolucao diaria com ficha geral.
- Evolucoes devem ir em `evolucoes_clinicas`.

## evolucoes_clinicas

### Finalidade

Registrar o que aconteceu em cada atendimento e qual o proximo passo.

### Quando preencher

Ao final de cada consulta ou procedimento.

### Quem preenche

Dentista.

### Campos obrigatorios

- `paciente_id`
- `data_atendimento`
- `descricao`

### Campos opcionais

- `procedimentos_realizados`
- `procedimentos_a_realizar`
- `proximo_passo`
- `profissional_id`

### Regras

- Deve ser facil e rapido de preencher.
- Deve permitir texto livre no MVP.
- Pode ganhar campos estruturados depois.

## agendamentos

### Finalidade

Controlar consultas e retornos: agendamento nativo do MVP (sem grade de
calendario ainda - so listas cronologicas, no dashboard e na ficha do
paciente).

### Quando preencher

Ao marcar uma consulta, retorno ou compromisso clinico para um paciente.

### Quem preenche

O profissional dono do agendamento (`profissional_id`), na ficha do
paciente. Nao existe hoje um papel de recepcionista/secretaria distinto de
`profissionais` no OdontoFlow (ver Regras De Acesso E Permissoes em
`regras_negocio.md`), entao quem cria e edita um agendamento e sempre um
profissional autenticado.

### Campos obrigatorios

- `paciente_id`
- `consultorio_id`
- `profissional_id`
- `data_hora_inicio`
- `status`

### Campos opcionais

- `tipo`
- `data_hora_fim`
- `observacoes`
- `confirmado_por_whatsapp`

### Regras

- Status: `agendado`, `confirmado`, `realizado`, `cancelado`, `faltou`.
- `tipo` e texto livre (ex.: "Consulta", "Retorno", "Avaliação") - sem enum
  de proposito, para nao travar o vocabulario do consultorio.
- `data_hora_fim` e opcional: o dentista pode nao saber a duracao ao marcar.
- `confirmado_por_whatsapp` e uma marca manual (o dentista/recepcao assinala
  que a confirmacao chegou por WhatsApp) - o OdontoFlow nao envia nem le
  mensagens automaticamente.
- Sem `delete`: cancelamento e soft-delete via `status = 'cancelado'`, igual
  ao resto do dado clinico.
- So o profissional dono (`profissional_id`) pode alterar um agendamento
  (status, horarios, observacoes). Um colega com acesso ao mesmo
  paciente/consultorio ve o agendamento, mas nao pode edita-lo - nao existe
  ainda um fluxo de "assumir agendamento" (mesma situacao de
  `itens_plano_tratamento`/`planos_tratamento` antes do "assumir plano").
- Integracao com Google Agenda fica fora desta rodada (ver Questoes Em
  Aberto em `modelo_dados.md`); quando existir, sera opt-in por
  profissional, nunca ligada por padrao para todos.

## procedimentos

### Finalidade

Listar procedimentos usados em orcamentos e planos.

### Quando preencher

Ao configurar a base inicial do profissional ou clinica.

### Quem preenche

Dentista ou administrador.

### Campos obrigatorios

- `nome`

### Campos opcionais

- `categoria`
- `descricao`
- `consultas_previstas`
- `ativo`

### Regras

- Procedimento nao deve guardar todas as variacoes de preco.
- Variacoes devem ir em `regras_preco_procedimento`.

## regras_preco_procedimento

### Finalidade

Guardar variacoes de valor por material, face, dificuldade ou contexto.

### Quando preencher

Ao montar tabela de preco ou quando um procedimento muda conforme regra.

### Quem preenche

Dentista ou administrador.

### Campos obrigatorios

- `procedimento_id`
- `valor`

### Campos opcionais

- `material`
- `quantidade_faces`
- `nivel_dificuldade`
- `nome_regra`
- `observacoes`

### Regras

- Deve suportar casos como restauracao por quantidade de faces.
- Deve suportar escolha de material.

## planos_tratamento

### Finalidade

Agrupar procedimentos planejados para um paciente.

### Quando preencher

Depois de avaliacao clinica ou montagem de proposta.

### Quem preenche

Dentista.

### Campos obrigatorios

- `paciente_id`
- `status`

### Campos opcionais

- `titulo`
- `observacoes`
- `valor_total_estimado`

### Regras

- Um paciente pode ter mais de um plano.
- Plano pode ser rascunho antes de virar orcamento.
- Unica transicao de `status` coberta hoje pelo app: `rascunho` <-> `aprovado`.
  O dono do plano clica em "Paciente aprovou o tratamento" (com confirmacao)
  para gravar `aprovado`; isso trava o formulario de novo item e os icones de
  editar/excluir de cada item (mesmo para o dono), e libera o checklist rapido
  Pendente/Iniciado/Feito de cada item como unico controle interativo (ver
  `itens_plano_tratamento`). "Reabrir plano para edicao" (tambem com
  confirmacao, so o dono) volta `status` para `rascunho` sem tocar em nenhum
  item - status/`data_execucao` ja gravados no checklist sobrevivem ao ciclo
  reabrir -> aprovar de novo.
- Os demais valores aceitos pela constraint (`apresentado`, `aprovado_parcial`,
  `em_execucao`, `concluido`, `cancelado`, `substituido`) ainda nao tem fluxo
  no app.

## itens_plano_tratamento

### Finalidade

Detalhar cada procedimento planejado.

### Quando preencher

Ao montar o plano.

### Quem preenche

Dentista.

### Campos obrigatorios

- `plano_tratamento_id`
- `descricao` ou `procedimento_id`
- `valor`

### Campos opcionais

- `dente`
- `face`
- `material`
- `consultas_previstas`
- `status`
- `urgente`
- `ordem`
- `data_execucao`

### Regras

- Status minimo sugerido: `planejado`, `aprovado`, `em_andamento`, `realizado`, `cancelado`.
- `urgente` e booleano e independente do `status`: severidade clinica, nao etapa
  de andamento. Um item pode estar `em_andamento` e `urgente` ao mesmo tempo.
- Deve permitir item manual sem procedimento cadastrado.
- `data_execucao` e diferente de `criado_em`: `criado_em` e so auditoria de
  quando a linha foi criada no sistema (imutavel); `data_execucao` e quando o
  procedimento de fato aconteceu na boca do paciente. Pode ficar em branco
  quando a data exata nao e conhecida, e serve principalmente para registrar
  trabalho pre-existente feito por outro profissional antes do paciente entrar
  no OdontoFlow (achado de exame inicial/historico).
- `face` aceita `"Gengiva"` como valor, junto com `"Raiz"`: os dois nao sao uma
  face de esmalte no sentido estrito (V/L/P/M/D/O), mas convivem no mesmo campo
  em vez de precisar de uma coluna separada para local anatomico.
- O checklist rapido Pendente/Iniciado/Feito na linha do item (fora do
  formulario completo de editar) e so um atalho de UI para os mesmos valores
  de `status` acima - nao introduz conceito novo. "Pendente" cobre tanto
  `planejado` quanto `aprovado`; ao reverter de `em_andamento`/`realizado` para
  "Pendente" o valor gravado e `aprovado` (nunca regride para `planejado`), e
  `data_execucao` ja gravada nunca e apagada por essa reversao.
- O checklist so aparece interativo depois que o PLANO (`planos_tratamento.status`,
  campo diferente deste) sai de `rascunho` (ver `planos_tratamento`). Enquanto
  o plano ainda e rascunho nao ha andamento de execucao a acompanhar, entao a
  coluna mostra so um badge de status simples, nao clicavel.

## envios_plano_tratamento

### Finalidade

Registrar que um orcamento foi gerado em PDF ou preparado/aberto no WhatsApp,
para o dentista conseguir consultar depois o que foi enviado ao paciente sem
depender da memoria. Nao e a tabela `orcamentos` (proposta, com fluxo de
aprovacao/recusa) - e soh um log de envio.

### Quando preencher

Automaticamente, quando o dentista clica em "Imprimir PDF" ou "Abrir WhatsApp"
na tela de atendimento.

### Quem preenche

O sistema, em nome do profissional que estava com o plano aberto.

### Campos obrigatorios

- `plano_tratamento_id`
- `profissional_id`
- `canal` (`pdf` ou `whatsapp`)

### Campos opcionais

- `valor_total`
- `quantidade_itens`
- `item_ids`
- `destinatario_telefone` (soh quando `canal = whatsapp`)

### Regras

- E historico: nao tem `update` nem `delete`, so `insert`/`select`.
- Por decisao de manter o uso de espaco no banco baixo, `item_ids` guarda so os
  ids dos itens de `itens_plano_tratamento` incluidos no envio - nao duplica o
  conteudo deles. Como esses itens nunca sao apagados de verdade (so
  `status = cancelado`), os ids sempre resolvem para dados reais; a
  contrapartida e que, se um item for editado depois do envio, reconstruir o
  envio mostra o valor atual do item, nao o valor exato de quando foi enviado.
- Nao confirma entrega nem leitura da mensagem: o WhatsApp e aberto via link
  manual (`wa.me`), nao pela API oficial, entao so registramos que o dentista
  clicou em enviar.

## orcamentos

### Finalidade

Registrar proposta financeira apresentada ao paciente.

### Quando preencher

Ao gerar ou apresentar uma proposta.

### Quem preenche

Dentista ou recepcionista/secretaria.

### Campos obrigatorios

- `paciente_id`
- `valor_total`
- `status`

### Campos opcionais

- `plano_tratamento_id`
- `validade`
- `observacoes`

### Regras

- Deve permitir proposta em aberto, aprovada ou recusada.
- Paciente pode pedir tempo para decidir.

## pagamentos

### Finalidade

Controlar quanto o paciente pagou e quanto falta pagar.

### Quando preencher

Ao registrar cobranca, pagamento ou saldo.

### Quem preenche

Recepcionista, secretaria ou dentista.

### Campos obrigatorios

- `paciente_id`
- `valor`
- `status`

### Campos opcionais

- `orcamento_id`
- `plano_tratamento_id`
- `data_vencimento`
- `data_pagamento`
- `forma_pagamento`

### Regras

- Deve ficar visivel na ficha do paciente.
- Deve responder rapidamente: quanto ja pagou e quanto falta.

## casos_laboratorio

### Finalidade

Controlar trabalhos enviados ao laboratorio.

### Quando preencher

Quando um procedimento depende de laboratorio.

### Quem preenche

Dentista ou secretaria.

### Campos obrigatorios

- `paciente_id`
- `tipo_trabalho`
- `status`

### Campos opcionais

- `laboratorio_nome`
- `data_envio`
- `data_prevista_retorno`
- `observacoes`

### Regras

- Deve mostrar pendencias e proximas etapas.
- Especialmente importante para protese.

## etapas_laboratorio

### Finalidade

Detalhar etapas de laboratorio, como prova, ajuste, retorno e entrega.

### Quando preencher

Ao criar ou atualizar um caso de laboratorio.

### Quem preenche

Dentista ou secretaria.

### Campos obrigatorios

- `caso_laboratorio_id`
- `nome`
- `status`

### Campos opcionais

- `data_prevista`
- `data_conclusao`
- `observacoes`

### Regras

- Status minimo sugerido: `pendente`, `enviado`, `recebido`, `concluido`, `atrasado`.
