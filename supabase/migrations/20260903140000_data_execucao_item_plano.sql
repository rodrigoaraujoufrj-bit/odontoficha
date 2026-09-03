-- OdontoFlow - data de execucao do item de plano de tratamento
--
-- Separa "quando isso de fato aconteceu na boca do paciente" (data_execucao)
-- de "quando foi digitado no sistema" (criado_em, auditoria, imutavel). Sem
-- isso nao ha como registrar um achado de exame inicial/historico anterior
-- (paciente vindo de outro profissional, com trabalho ja feito antes de
-- existir cadastro no OdontoFlow) com a data real, nem so aceitar que a data
-- e aproximada/desconhecida.
--
-- Nao mexe em "estrutura"/local anatomico separado: gengiva passa a ser mais
-- um valor aceito em faces_dente (ja convivia com "Raiz", que tambem nao e
-- uma face de esmalte no sentido estrito) - reaproveita o array que ja
-- existe em vez de criar coluna nova.

alter table public.itens_plano_tratamento
  add column if not exists data_execucao date;

comment on column public.itens_plano_tratamento.data_execucao is
  'Quando o procedimento de fato aconteceu (pode ser no passado, ex.: achado de exame inicial). Diferente de criado_em, que e so auditoria de quando a linha foi criada no sistema. Opcional: aceita nao saber a data exata.';
