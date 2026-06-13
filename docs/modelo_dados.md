# OdontoFlow - Modelo de Dados

Status: rascunho inicial

Este documento descreve a proposta inicial de modelo de dados do OdontoFlow. Os nomes de tabelas e campos devem seguir o padrao `pt_br` em `snake_case`.

## Premissas

- O OdontoFlow deve ser um organizador de fluxo clinico-operacional, nao apenas um odontograma digital.
- O MVP deve priorizar cadastro rapido, ficha clinica, evolucao, agenda/retornos, orcamento, financeiro simples e laboratorio.
- O odontograma deve comecar simples e evoluir conforme validacao.
- O banco deve evitar cadastros obrigatorios longos.
- Dados clinicos exigem cuidado com permissao, auditoria, backup e LGPD.

## Convencoes

- Tabelas no plural: `pacientes`, `agendamentos`, `procedimentos`.
- Campos em `snake_case`: `data_nascimento`, `criado_em`, `paciente_id`.
- Chaves primarias: `id`.
- Chaves estrangeiras: `<tabela_singular>_id`, exemplo `paciente_id`.
- Datas de auditoria: `criado_em`, `atualizado_em`.
- Exclusao logica quando necessario: `arquivado_em`.

## Tabelas Propostas Para MVP

### profissionais

Guarda os dados do dentista/profissional que usa o OdontoFlow.

Campos provaveis:

- `id`
- `usuario_id`
- `nome`
- `telefone`
- `email`
- `cro`
- `cro_uf`
- `criado_em`
- `atualizado_em`

### consultorios

Guarda os locais de atendimento.

Campos provaveis:

- `id`
- `nome`
- `telefone`
- `email`
- `endereco`
- `cidade`
- `uf`
- `observacoes`
- `criado_em`
- `atualizado_em`

### profissional_consultorios

Vincula profissionais a consultorios.

Campos provaveis:

- `id`
- `profissional_id`
- `consultorio_id`
- `ativo`
- `criado_em`
- `atualizado_em`

### pacientes

Guarda dados basicos do paciente.

Campos provaveis:

- `id`
- `nome`
- `telefone`
- `email`
- `cpf`
- `data_nascimento`
- `observacoes`
- `criado_em`
- `atualizado_em`

### paciente_consultorios

Vincula pacientes a consultorios e profissionais.

Campos provaveis:

- `id`
- `paciente_id`
- `consultorio_id`
- `profissional_id`
- `ativo`
- `criado_em`
- `atualizado_em`

### fichas_clinicas

Guarda dados gerais da ficha clinica do paciente.

Campos provaveis:

- `id`
- `paciente_id`
- `anamnese`
- `alergias`
- `medicamentos`
- `observacoes_clinicas`
- `criado_em`
- `atualizado_em`

### evolucoes_clinicas

Registra a evolucao de cada atendimento.

Campos provaveis:

- `id`
- `paciente_id`
- `ficha_clinica_id`
- `data_atendimento`
- `descricao`
- `procedimentos_realizados`
- `procedimentos_a_realizar`
- `proximo_passo`
- `profissional_id`
- `criado_em`
- `atualizado_em`

### agendamentos

Controla consultas, retornos e confirmacoes.

Campos provaveis:

- `id`
- `paciente_id`
- `data_hora_inicio`
- `data_hora_fim`
- `tipo`
- `status`
- `observacoes`
- `confirmado_por_whatsapp`
- `criado_em`
- `atualizado_em`

### procedimentos

Cadastro base de procedimentos.

Campos provaveis:

- `id`
- `nome`
- `categoria`
- `descricao`
- `consultas_previstas`
- `ativo`
- `criado_em`
- `atualizado_em`

### regras_preco_procedimento

Define variacoes de preco por material, face, dificuldade ou contexto.

Campos provaveis:

- `id`
- `procedimento_id`
- `nome_regra`
- `material`
- `quantidade_faces`
- `nivel_dificuldade`
- `valor`
- `observacoes`
- `ativo`
- `criado_em`
- `atualizado_em`

### planos_tratamento

Agrupa procedimentos planejados para um paciente.

Campos provaveis:

- `id`
- `paciente_id`
- `titulo`
- `status`
- `observacoes`
- `valor_total_estimado`
- `criado_em`
- `atualizado_em`

### itens_plano_tratamento

Itens do plano de tratamento.

Campos provaveis:

- `id`
- `plano_tratamento_id`
- `procedimento_id`
- `dente`
- `face`
- `material`
- `descricao`
- `consultas_previstas`
- `valor`
- `status`
- `ordem`
- `criado_em`
- `atualizado_em`

### orcamentos

Proposta enviada ou apresentada ao paciente.

Campos provaveis:

- `id`
- `paciente_id`
- `plano_tratamento_id`
- `status`
- `validade`
- `valor_total`
- `observacoes`
- `criado_em`
- `atualizado_em`

### formas_pagamento_orcamento

Opcoes de pagamento associadas ao orcamento.

Campos provaveis:

- `id`
- `orcamento_id`
- `descricao`
- `valor`
- `parcelas`
- `desconto`
- `observacoes`

### pagamentos

Controle financeiro simples por paciente/plano/orcamento.

Campos provaveis:

- `id`
- `paciente_id`
- `orcamento_id`
- `plano_tratamento_id`
- `descricao`
- `valor`
- `data_vencimento`
- `data_pagamento`
- `status`
- `forma_pagamento`
- `observacoes`

### casos_laboratorio

Controle de trabalhos enviados ao laboratorio.

Campos provaveis:

- `id`
- `paciente_id`
- `plano_tratamento_id`
- `item_plano_tratamento_id`
- `laboratorio_nome`
- `tipo_trabalho`
- `status`
- `data_envio`
- `data_prevista_retorno`
- `observacoes`
- `criado_em`
- `atualizado_em`

### etapas_laboratorio

Etapas de um caso de laboratorio.

Campos provaveis:

- `id`
- `caso_laboratorio_id`
- `nome`
- `status`
- `data_prevista`
- `data_conclusao`
- `observacoes`

### anexos

Arquivos ligados a paciente, ficha, evolucao, orcamento ou laboratorio.

Campos provaveis:

- `id`
- `paciente_id`
- `tipo_entidade`
- `entidade_id`
- `nome_arquivo`
- `url_arquivo`
- `tipo_arquivo`
- `observacoes`
- `criado_em`

## Tabelas Futuras

- `usuarios`
- `perfis_acesso`
- `odontogramas`
- `marcacoes_odontograma`
- `estoques`
- `itens_estoque`
- `movimentacoes_estoque`
- `modelos_documento`
- `documentos_emitidos`

## Relacionamentos Principais

- Um `profissional` pode trabalhar em varios `consultorios`.
- Um `consultorio` pode ter varios `profissionais`.
- Um `profissional_consultorio` representa o vinculo entre profissional e consultorio.
- Um `paciente` tem uma `ficha_clinica`.
- Um `paciente` pode estar vinculado a um ou mais `consultorios`.
- Um `paciente_consultorio` permite corrigir consultorio errado sem alterar o cadastro principal do paciente.
- Um `paciente` tem muitas `evolucoes_clinicas`.
- Um `paciente` tem muitos `agendamentos`.
- Um `paciente` tem muitos `planos_tratamento`.
- Um `plano_tratamento` tem muitos `itens_plano_tratamento`.
- Um `plano_tratamento` pode gerar um ou mais `orcamentos`.
- Um `orcamento` pode ter varias `formas_pagamento_orcamento`.
- Um `paciente` pode ter muitos `pagamentos`.
- Um `item_plano_tratamento` pode gerar um `caso_laboratorio`.

## Questoes Em Aberto

- Como tratar dentistas que atendem em varios locais.
- Se agenda sera nativa ou integracao com Google Agenda no MVP.
- Se laboratorio entra no MVP completo ou apenas como controle simples de etapas.
- Nivel inicial do odontograma: texto por dente ou interface visual.
