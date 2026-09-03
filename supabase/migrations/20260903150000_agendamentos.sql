-- OdontoFlow - agendamento nativo (MVP)
--
-- Sem grade de calendario nesta rodada: a UI e uma lista cronologica (hoje +
-- proximos 7 dias no dashboard, historico completo na ficha do paciente).
-- "tipo" fica como texto livre (Consulta/Retorno/Avaliacao etc.) em vez de
-- enum: ver docs/regras_negocio.md, e nao ha ganho em travar isso agora.
--
-- data_hora_fim e opcional porque o dentista nem sempre sabe a duracao ao
-- marcar. Sem exclusao real: cancelamento e soft-delete via status, igual ao
-- resto do dado clinico (ver itens_plano_tratamento).
--
-- Nao ha fluxo de "assumir agendamento" nesta rodada (fora de escopo, como o
-- "assumir plano" foi antes de existir): so quem criou o agendamento
-- (profissional_id) pode edita-lo depois. Um colega com acesso ao mesmo
-- paciente/consultorio ve o agendamento, mas nao pode altera-lo - mesma forma
-- que planos_tratamento funciona antes do escape hatch de "assumir".
--
-- Sincronizacao com Google Agenda fica fora desta rodada por decisao (ver
-- docs/modelo_dados.md); quando existir, sera opt-in por profissional, nao
-- coluna nenhuma aqui ainda.

create table if not exists public.agendamentos (
  id uuid primary key default gen_random_uuid(),
  paciente_id uuid not null references public.pacientes(id) on delete cascade,
  consultorio_id uuid not null references public.consultorios(id) on delete restrict,
  profissional_id uuid not null references public.profissionais(id) on delete restrict,
  data_hora_inicio timestamptz not null,
  data_hora_fim timestamptz,
  tipo text,
  status text not null default 'agendado',
  observacoes text,
  confirmado_por_whatsapp boolean not null default false,
  criado_em timestamptz not null default now(),

  constraint agendamentos_status_valido check (status in ('agendado', 'confirmado', 'realizado', 'cancelado', 'faltou'))
);

create index if not exists idx_agendamentos_consultorio_data on public.agendamentos(consultorio_id, data_hora_inicio);
create index if not exists idx_agendamentos_paciente_id on public.agendamentos(paciente_id);

alter table public.agendamentos enable row level security;

revoke all on table public.agendamentos from anon;
grant select, insert, update on table public.agendamentos to authenticated;

drop policy if exists agendamentos_select_paciente on public.agendamentos;
create policy agendamentos_select_paciente
on public.agendamentos
for select
to authenticated
using (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists agendamentos_insert_paciente on public.agendamentos;
create policy agendamentos_insert_paciente
on public.agendamentos
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists agendamentos_update_paciente on public.agendamentos;
create policy agendamentos_update_paciente
on public.agendamentos
for update
to authenticated
using (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
)
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

comment on table public.agendamentos is
  'Agendamento nativo (MVP): consulta/retorno por paciente. Sem grade de calendario ainda - so listas cronologicas na UI. Cancelamento e soft-delete via status.';
comment on column public.agendamentos.tipo is
  'Texto livre (ex.: Consulta, Retorno, Avaliacao). Sem enum de proposito: ver docs/regras_negocio.md.';
comment on column public.agendamentos.data_hora_fim is
  'Opcional: o dentista pode nao saber a duracao ao marcar o horario.';
comment on column public.agendamentos.confirmado_por_whatsapp is
  'Marca manual do dentista/recepcao de que a confirmacao do paciente veio por WhatsApp. Nao envia nem le mensagens automaticamente.';
