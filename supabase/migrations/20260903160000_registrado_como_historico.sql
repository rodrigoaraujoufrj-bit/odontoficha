-- OdontoFlow - marca item de plano registrado so como historico
--
-- data_execucao (migracao anterior) diz QUANDO um procedimento aconteceu, mas
-- nao diz QUEM o realizou nem SE este consultorio recebeu por ele. Um item
-- marcado via "Ja foi realizado antes (historico/exame inicial)" registra
-- trabalho ja feito, tipicamente por outro profissional, antes do paciente
-- entrar no OdontoFlow - e forcado para status='realizado' mesmo sem este
-- consultorio ter executado ou cobrado nada. Sem separar isso, um relatorio
-- financeiro que soma itens 'realizado' contaria ganho que nunca existiu.
--
-- registrado_como_historico marca exatamente essa origem, para que
-- relatorios de ganhos/faturamento excluam esses itens.

alter table public.itens_plano_tratamento
  add column if not exists registrado_como_historico boolean not null default false;

comment on column public.itens_plano_tratamento.registrado_como_historico is
  'true quando o item foi criado via "Ja foi realizado antes" (historico/exame inicial): registra trabalho ja feito, tipicamente por outro profissional, antes deste consultorio/app - nao e trabalho que este consultorio executou ou foi pago para fazer. Usado para excluir o item de relatorios financeiros/ganhos.';
