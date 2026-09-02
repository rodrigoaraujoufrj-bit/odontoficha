-- Corrige erro de modelagem: severidade clinica (urgente) nao e um valor do
-- status de andamento/aprovacao do item de plano de tratamento, e um eixo
-- independente. Um item pode ser urgente em qualquer status (planejado,
-- em_andamento, etc). Ver docs/levantamento_persistencia_atendimento.md.

alter table public.itens_plano_tratamento
  add column if not exists urgente boolean not null default false;

-- Migra dados existentes: quem estava marcado como status='urgente' vira
-- planejado (andamento neutro) + urgente=true, preservando o sinal clinico.
update public.itens_plano_tratamento
set urgente = true,
    status = 'planejado'
where status = 'urgente';

alter table public.itens_plano_tratamento
  drop constraint if exists itens_plano_status_valido;

alter table public.itens_plano_tratamento
  add constraint itens_plano_status_valido
  check (status in ('planejado', 'aprovado', 'em_andamento', 'realizado', 'cancelado'));

comment on column public.itens_plano_tratamento.status is
  'Andamento de aprovacao/execucao do item. Severidade clinica fica em urgente, campo separado.';
comment on column public.itens_plano_tratamento.urgente is
  'Severidade clinica do item (independe do status de andamento/aprovacao).';
