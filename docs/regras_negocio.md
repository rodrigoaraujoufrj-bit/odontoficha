# OdontoFlow - Regras de Negocio

Última atualização: 2026-09-03

Este documento registra regras e decisoes de produto para orientar o MVP.

## Posicionamento Do MVP

O OdontoFlow deve ser validado como organizador de fluxo clinico-operacional para dentistas e equipes.

Nao posicionar inicialmente como:

- sistema odontologico completo
- apenas odontograma digital
- assistente virtual
- IA odontologica

Posicionamento sugerido:

```text
Organize ficha, evolucao, agenda, orcamento, financeiro e laboratorio em um fluxo simples.
```

## Principios Do Produto

1. Cadastro rapido vale mais que cadastro completo.
2. O dentista precisa abrir historico e evolucao em poucos cliques.
3. O produto deve funcionar para quem atende em mais de um local.
4. O produto deve ajudar dentista e secretaria/recepcionista.
5. O MVP deve aceitar informacao incompleta.
6. A agenda deve priorizar retornos e confirmacoes.
7. O financeiro inicial deve responder: quanto pagou e quanto falta.
8. Laboratorio deve ser tratado como pendencia clinica relevante.

## Regras De Cadastro De Paciente

- `nome` deve ser obrigatorio.
- Pelo menos um contato deve ser informado.
- CPF nao deve ser obrigatorio no MVP.
- O sistema deve alertar possivel duplicidade por nome e telefone.
- O cadastro deve poder ser criado rapidamente e completado depois.
- Paciente nao deve depender de um unico `consultorio_id` fixo na tabela principal.
- Vinculo com consultorio deve ser controlado em `paciente_consultorios`.
- Se o consultorio for informado errado, corrigir o vinculo, nao duplicar o paciente.
- `criado_por_profissional_id` (em `pacientes`) e um dado de auditoria: registra apenas
  quem cadastrou o paciente pela primeira vez e nunca muda depois disso. Ele **nao**
  define quem pode atender o paciente hoje - isso e sempre decidido por `paciente_consultorios`.

## Regras De Compartilhamento De Paciente Entre Profissionais

Confirmado como cenario real: mais de um dentista do mesmo consultorio pode dividir o
mesmo paciente, dependendo do tratamento (ex.: dois profissionais do mesmo consultorio,
cada um responsavel por um tipo de procedimento).

- Um paciente pode estar vinculado a mais de um profissional no mesmo consultorio ao
  mesmo tempo, cada vinculo sendo uma linha ativa em `paciente_consultorios`.
- Todo profissional vinculado (ativo) a um paciente tem acesso igual: pode ver e
  atualizar ficha, anamnese, planos de tratamento e orcamentos desse paciente. Nao existe
  um "dono" com mais poder que os demais sobre o cadastro do paciente.
- Compartilhar um paciente e uma acao explicita: um profissional que ja atende o
  paciente escolhe um colega do mesmo consultorio e cria o vinculo. Nao existe
  compartilhamento implicito ou automatico entre todos os profissionais de um
  consultorio.
- Profissionais do mesmo consultorio podem ver o nome e CRO uns dos outros (apenas
  isso) para viabilizar essa colaboracao - fora dessa lista, nenhum dado de outro
  profissional fica visivel.
- Remover o acesso de um profissional a um paciente compartilhado (desativar o
  vinculo) ainda nao tem interface no MVP; hoje so o proprio profissional consegue
  desativar o proprio vinculo diretamente no banco.

## Regras De Cadastro Do Profissional

- Profissional deve ter cadastro proprio.
- Campos minimos:
  - `nome`
  - `telefone`
  - `email`
  - `cro`
  - `cro_uf`
- E-mail deve conter `@`.
- E-mail deve ser normalizado para minusculo.
- Telefone deve ser salvo apenas com digitos.
- Para telefone principal/WhatsApp, exigir 11 digitos: 2 do DDD e 9 do numero.
- CRO deve ser separado da UF para evitar texto livre inconsistente.

## Regras De Consultorio

- Consultorio deve ser uma tabela propria.
- Profissional pode trabalhar em varios consultorios.
- Consultorio pode ter varios profissionais no futuro.
- O vinculo profissional-consultorio deve ficar em `profissional_consultorios`.
- O vinculo paciente-consultorio-profissional deve ficar em `paciente_consultorios`.
- Correcoes de local de atendimento devem alterar o vinculo, nao o cadastro base do paciente.

## Regras De Validacao De Dados

- CPF deve conter exatamente 11 digitos quando preenchido.
- CPF deve ser salvo apenas com digitos.
- Validacao de digitos verificadores do CPF deve ser implementada antes de uso real amplo.
- Telefone principal deve conter exatamente 11 digitos quando usado como WhatsApp/celular.
- Se futuramente existir telefone fixo, criar campo separado ou regra propria para 10 digitos.
- E-mail deve conter `@` e nao pode ter espacos.
- Campos formatados na tela devem ser salvos limpos no banco.

Exemplos:

```text
telefone na tela: (21) 99999-9999
telefone no banco: 21999999999

cpf na tela: 123.456.789-09
cpf no banco: 12345678909
```

## Regras De Ficha Clinica

- Ficha clinica guarda informacoes gerais.
- Evolucao por atendimento deve ficar em tabela propria.
- Historico deve ser facil de consultar em quase todo atendimento.
- Anexos devem poder ser ligados a paciente, evolucao ou laboratorio.

## Regras De Evolucao Clinica

- Toda evolucao deve pertencer a um paciente.
- Evolucao deve registrar data do atendimento.
- Campo de texto livre deve existir no MVP.
- Deve ser possivel registrar:
  - o que foi realizado
  - o que ficou pendente
  - o proximo passo

## Regras De Agenda

- Agenda e nativa no MVP (decisao registrada: nao e integracao com Google
  Agenda desde o inicio - ver `modelo_dados.md`).
- Sem grade de calendario na v1: listas cronologicas bastam - dashboard
  mostra os proximos 7 dias do profissional logado no consultorio atual,
  ficha do paciente mostra o historico completo dele.
- Agenda deve suportar consulta e retorno (campo `tipo`, texto livre).
- Confirmacao por WhatsApp comeca manual: `confirmado_por_whatsapp` e uma
  marca do dentista/recepcao, sem envio nem leitura automatica de mensagem.
- So o profissional dono do agendamento pode altera-lo; um colega com acesso
  ao paciente ve mas nao edita (sem fluxo de "assumir agendamento" no MVP).
- Integracao com Google Agenda fica para depois do MVP e, quando existir,
  deve ser **opt-in por profissional** (cada dentista liga para si, nunca
  ligada por padrao para todos) - nao apenas "avaliada", ja e decisao de
  produto tomada.
- Status minimo:
  - `agendado`
  - `confirmado`
  - `realizado`
  - `cancelado`
  - `faltou`

## Regras De Procedimentos E Precos

- Procedimento base nao deve carregar todas as variacoes de preco.
- Variacoes devem considerar:
  - material
  - quantidade de faces
  - dificuldade
  - observacoes do profissional
- Deve ser possivel criar item manual no plano sem tabela cadastrada.
- Valores podem mudar com frequencia.

## Regras De Plano De Tratamento

- Um paciente pode ter varios planos.
- Um plano pode estar em rascunho.
- Um plano pode gerar orcamento.
- Itens do plano devem aceitar dente e face, mas isso nao deve ser sempre obrigatorio.
- `profissional_id` no plano representa quem esta conduzindo aquele plano **agora**,
  nao necessariamente quem criou. Qualquer profissional com acesso ao paciente naquele
  consultorio pode assumir um plano criado por um colega (por exemplo, um especialista
  assumindo uma etapa especifica do tratamento). Reatribuir so e possivel para si mesmo,
  e so quando o profissional ja tem acesso legitimo ao paciente e ao consultorio - nunca
  para alguem de fora da clinica.
- Status minimo do item (andamento de aprovacao/execucao):
  - `planejado`
  - `aprovado`
  - `em_andamento`
  - `realizado`
  - `cancelado`
- Severidade clinica e um eixo separado do status acima, nao um valor dele:
  um item urgente pode estar em qualquer status (ex.: urgente e planejado,
  urgente e em_andamento). Ver `itens_plano_tratamento.urgente` (booleano).
- Uma consulta nova ("Nova consulta" na interface) nem sempre significa plano
  novo: pode ser um problema clinico novo (novo plano) ou o retorno de um
  tratamento ja em andamento (continuacao de um plano existente). Um paciente
  pode ter mais de um plano em aberto ao mesmo tempo.
- Paciente compartilhado implica plano compartilhado: qualquer profissional
  com vinculo ativo ao paciente (via `paciente_consultorios`) pode ver os
  planos dele, independente de quem criou. Editar continua exigindo assumir o
  plano para si mesmo (ver regra de reatribuicao acima).

## Regras De Orcamento

- Orcamento deve poder ser montado mesmo sem odontograma completo.
- Orcamento deve exibir:
  - procedimentos
  - dente/regiao quando houver
  - formas de pagamento
  - validade da proposta
- Status minimo:
  - `rascunho`
  - `apresentado`
  - `aguardando_resposta`
  - `aprovado`
  - `recusado`
  - `cancelado`

## Regras De Financeiro

- Financeiro inicial deve ser simples.
- Deve responder rapidamente:
  - valor total
  - quanto ja foi pago
  - quanto falta pagar
- Pagamento pode estar ligado a paciente, orcamento ou plano.
- Nao construir financeiro completo antes de validar o fluxo clinico.

## Regras De Laboratorio

- Laboratorio entra como pendencia do caso clinico.
- Deve ser possivel registrar:
  - tipo de trabalho
  - laboratorio
  - data de envio
  - data prevista de retorno
  - etapa atual
  - observacoes
- Casos de protese podem depender fortemente dessa funcionalidade.

## Regras De Odontograma

- Odontograma no MVP deve ser simples.
- Deve permitir:
  - numero do dente
  - face do dente quando informada
  - tratamento indicado
  - status basico
  - observacao
- Suporte a faces do dente deve ficar no radar porque ajuda o dentista a se orientar rapidamente.
- Interface visual completa por face pode ficar para depois, mas o modelo de dados nao deve impedir essa evolucao.
- No MVP v1, aceitar face como campo estruturado opcional e avaliar interface visual em fase seguinte.

## Regras De Estoque

- Estoque nao parece prioridade maxima nas primeiras respostas.
- MVP pode apenas registrar material relevante no procedimento/laboratorio.
- Controle completo de estoque deve ficar para fase posterior.

## Regras De Acesso E Permissoes

Decidido para profissionais (dentistas): ver "Regras De Compartilhamento De Paciente
Entre Profissionais". Resumo: acesso a paciente e sempre por vinculo explicito em
`paciente_consultorios`, todo profissional vinculado tem acesso igual, e colegas do
mesmo consultorio se enxergam (nome/CRO) para viabilizar o compartilhamento.

Ainda em aberto (perfil secretaria/recepcionista):

- Secretaria/recepcionista pode cadastrar paciente, agenda, pagamentos e laboratorio.
- Dados clinicos sensiveis (anamnese, historico medico) podem exigir permissao mais
  restrita que a de agenda/cadastro basico.
- Hoje o sistema so tem o papel "profissional" (`profissionais` = 1 conta = 1 dentista);
  um papel separado para secretaria/recepcionista ainda nao existe no modelo de dados.

## Riscos

- Produto ficar amplo demais antes do MVP.
- Cadastro demorado impedir adocao.
- Agenda virar escopo grande demais.
- Confundir OdontoFlow com IA/assistente virtual.
- Odontograma complexo consumir tempo antes de validar ficha/evolucao/orcamento.
- Ignorar faces do dente e depois precisar remodelar plano/orcamento/odontograma.

## Hipoteses A Validar Com Mais Questionarios

- Agenda simples e retornos sao prioridade recorrente.
- Laboratorio e relevante para mais perfis alem de protese.
- Financeiro por paciente e necessidade real.
- Sistema da clinica resolve apenas parcialmente a rotina individual do dentista.
- A maior barreira de adocao e tempo de cadastro/uso.
