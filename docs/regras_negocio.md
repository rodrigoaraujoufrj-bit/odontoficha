# OdontoFlow - Regras de Negocio

Status: rascunho inicial

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

- Agenda deve suportar consulta e retorno.
- Confirmacao por WhatsApp e importante, mas pode comecar manual.
- Integracao com Google Agenda deve ser avaliada depois do MVP.
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
- Status minimo do item:
  - `planejado`
  - `aprovado`
  - `em_andamento`
  - `realizado`
  - `cancelado`

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
  - tratamento indicado
  - status basico
  - observacao
- Interface visual completa por face pode ficar para depois, se nao aparecer como dor recorrente.

## Regras De Estoque

- Estoque nao parece prioridade maxima nas primeiras respostas.
- MVP pode apenas registrar material relevante no procedimento/laboratorio.
- Controle completo de estoque deve ficar para fase posterior.

## Regras De Acesso E Permissoes

Ainda em aberto.

Hipotese inicial:

- Dentista pode ver todos os dados dos seus pacientes.
- Secretaria/recepcionista pode cadastrar paciente, agenda, pagamentos e laboratorio.
- Dados clinicos sensiveis podem exigir permissao mais restrita.

## Riscos

- Produto ficar amplo demais antes do MVP.
- Cadastro demorado impedir adocao.
- Agenda virar escopo grande demais.
- Confundir OdontoFlow com IA/assistente virtual.
- Odontograma complexo consumir tempo antes de validar ficha/evolucao/orcamento.

## Hipoteses A Validar Com Mais Questionarios

- Agenda simples e retornos sao prioridade recorrente.
- Laboratorio e relevante para mais perfis alem de protese.
- Financeiro por paciente e necessidade real.
- Sistema da clinica resolve apenas parcialmente a rotina individual do dentista.
- A maior barreira de adocao e tempo de cadastro/uso.
