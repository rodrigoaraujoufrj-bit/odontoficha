-- OdontoFlow MVP - procedimentos, regras de preco e plano de tratamento
-- Mantem RLS ativo e usa somente chaves publicaveis no front-end.

create table if not exists public.procedimentos (
  id uuid primary key default gen_random_uuid(),
  consultorio_id uuid not null references public.consultorios(id) on delete cascade,
  nome text not null,
  categoria text,
  descricao text,
  aplicacao text not null default 'sem_dente',
  exige_dente boolean not null default false,
  exige_face boolean not null default false,
  permite_multiplas_faces boolean not null default true,
  consultas_previstas integer,
  ativo boolean not null default true,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint procedimentos_aplicacao_valida check (aplicacao in ('sem_dente', 'por_dente', 'por_face', 'arcada', 'boca_toda')),
  constraint procedimentos_consultas_previstas_positivas check (consultas_previstas is null or consultas_previstas > 0)
);

create table if not exists public.regras_preco_procedimento (
  id uuid primary key default gen_random_uuid(),
  procedimento_id uuid not null references public.procedimentos(id) on delete cascade,
  nome_regra text not null,
  numero_dente text,
  face_dente text,
  quantidade_faces integer,
  regiao_boca text,
  material text,
  nivel_dificuldade text,
  valor numeric(12,2) not null default 0,
  observacoes text,
  ativo boolean not null default true,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint regras_preco_valor_nao_negativo check (valor >= 0),
  constraint regras_preco_quantidade_faces_valida check (quantidade_faces is null or quantidade_faces between 0 and 6)
);

create table if not exists public.planos_tratamento (
  id uuid primary key default gen_random_uuid(),
  paciente_id uuid not null references public.pacientes(id) on delete cascade,
  consultorio_id uuid not null references public.consultorios(id) on delete restrict,
  profissional_id uuid not null references public.profissionais(id) on delete restrict,
  titulo text not null default 'Plano de tratamento',
  status text not null default 'rascunho',
  observacoes text,
  valor_total_estimado numeric(12,2) not null default 0,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint planos_tratamento_status_valido check (status in ('rascunho', 'apresentado', 'aprovado_parcial', 'aprovado', 'em_execucao', 'concluido', 'cancelado', 'substituido')),
  constraint planos_tratamento_valor_nao_negativo check (valor_total_estimado >= 0)
);

create table if not exists public.itens_plano_tratamento (
  id uuid primary key default gen_random_uuid(),
  plano_tratamento_id uuid not null references public.planos_tratamento(id) on delete cascade,
  procedimento_id uuid references public.procedimentos(id) on delete set null,
  regra_preco_procedimento_id uuid references public.regras_preco_procedimento(id) on delete set null,
  numero_dente text,
  faces_dente text[] not null default '{}',
  procedimento_nome text not null,
  regra_preco_nome text,
  valor_estimado numeric(12,2) not null default 0,
  valor_final numeric(12,2) not null default 0,
  observacao text,
  status text not null default 'planejado',
  ordem integer not null default 1,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint itens_plano_status_valido check (status in ('planejado', 'aprovado', 'em_andamento', 'realizado', 'cancelado', 'urgente')),
  constraint itens_plano_valores_nao_negativos check (valor_estimado >= 0 and valor_final >= 0),
  constraint itens_plano_ordem_positiva check (ordem > 0)
);

create index if not exists idx_procedimentos_consultorio_id on public.procedimentos(consultorio_id);
create index if not exists idx_procedimentos_nome on public.procedimentos(nome);
create index if not exists idx_regras_preco_procedimento_id on public.regras_preco_procedimento(procedimento_id);
create index if not exists idx_planos_tratamento_paciente_id on public.planos_tratamento(paciente_id);
create index if not exists idx_planos_tratamento_consultorio_id on public.planos_tratamento(consultorio_id);
create index if not exists idx_planos_tratamento_profissional_id on public.planos_tratamento(profissional_id);
create index if not exists idx_itens_plano_tratamento_plano_id on public.itens_plano_tratamento(plano_tratamento_id);
create index if not exists idx_itens_plano_tratamento_procedimento_id on public.itens_plano_tratamento(procedimento_id);

drop trigger if exists procedimentos_tocar_atualizado_em on public.procedimentos;
create trigger procedimentos_tocar_atualizado_em
before update on public.procedimentos
for each row execute function public.tocar_atualizado_em();

drop trigger if exists regras_preco_procedimento_tocar_atualizado_em on public.regras_preco_procedimento;
create trigger regras_preco_procedimento_tocar_atualizado_em
before update on public.regras_preco_procedimento
for each row execute function public.tocar_atualizado_em();

drop trigger if exists planos_tratamento_tocar_atualizado_em on public.planos_tratamento;
create trigger planos_tratamento_tocar_atualizado_em
before update on public.planos_tratamento
for each row execute function public.tocar_atualizado_em();

drop trigger if exists itens_plano_tratamento_tocar_atualizado_em on public.itens_plano_tratamento;
create trigger itens_plano_tratamento_tocar_atualizado_em
before update on public.itens_plano_tratamento
for each row execute function public.tocar_atualizado_em();

alter table public.procedimentos enable row level security;
alter table public.regras_preco_procedimento enable row level security;
alter table public.planos_tratamento enable row level security;
alter table public.itens_plano_tratamento enable row level security;

revoke all on table public.procedimentos from anon;
revoke all on table public.regras_preco_procedimento from anon;
revoke all on table public.planos_tratamento from anon;
revoke all on table public.itens_plano_tratamento from anon;

grant select, insert, update on table public.procedimentos to authenticated;
grant select, insert, update on table public.regras_preco_procedimento to authenticated;
grant select, insert, update on table public.planos_tratamento to authenticated;
grant select, insert, update on table public.itens_plano_tratamento to authenticated;

drop policy if exists procedimentos_select_consultorio on public.procedimentos;
create policy procedimentos_select_consultorio
on public.procedimentos
for select
to authenticated
using (odf_privado.usuario_pode_acessar_consultorio(consultorio_id));

drop policy if exists procedimentos_insert_consultorio on public.procedimentos;
create policy procedimentos_insert_consultorio
on public.procedimentos
for insert
to authenticated
with check (odf_privado.usuario_pode_acessar_consultorio(consultorio_id));

drop policy if exists procedimentos_update_consultorio on public.procedimentos;
create policy procedimentos_update_consultorio
on public.procedimentos
for update
to authenticated
using (odf_privado.usuario_pode_acessar_consultorio(consultorio_id))
with check (odf_privado.usuario_pode_acessar_consultorio(consultorio_id));

drop policy if exists regras_preco_select_consultorio on public.regras_preco_procedimento;
create policy regras_preco_select_consultorio
on public.regras_preco_procedimento
for select
to authenticated
using (
  exists (
    select 1
    from public.procedimentos pr
    where pr.id = procedimento_id
      and odf_privado.usuario_pode_acessar_consultorio(pr.consultorio_id)
  )
);

drop policy if exists regras_preco_insert_consultorio on public.regras_preco_procedimento;
create policy regras_preco_insert_consultorio
on public.regras_preco_procedimento
for insert
to authenticated
with check (
  exists (
    select 1
    from public.procedimentos pr
    where pr.id = procedimento_id
      and odf_privado.usuario_pode_acessar_consultorio(pr.consultorio_id)
  )
);

drop policy if exists regras_preco_update_consultorio on public.regras_preco_procedimento;
create policy regras_preco_update_consultorio
on public.regras_preco_procedimento
for update
to authenticated
using (
  exists (
    select 1
    from public.procedimentos pr
    where pr.id = procedimento_id
      and odf_privado.usuario_pode_acessar_consultorio(pr.consultorio_id)
  )
)
with check (
  exists (
    select 1
    from public.procedimentos pr
    where pr.id = procedimento_id
      and odf_privado.usuario_pode_acessar_consultorio(pr.consultorio_id)
  )
);

drop policy if exists planos_tratamento_select_paciente on public.planos_tratamento;
create policy planos_tratamento_select_paciente
on public.planos_tratamento
for select
to authenticated
using (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists planos_tratamento_insert_paciente on public.planos_tratamento;
create policy planos_tratamento_insert_paciente
on public.planos_tratamento
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists planos_tratamento_update_paciente on public.planos_tratamento;
create policy planos_tratamento_update_paciente
on public.planos_tratamento
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

drop policy if exists itens_plano_select_paciente on public.itens_plano_tratamento;
create policy itens_plano_select_paciente
on public.itens_plano_tratamento
for select
to authenticated
using (
  exists (
    select 1
    from public.planos_tratamento pt
    where pt.id = plano_tratamento_id
      and odf_privado.usuario_pode_acessar_paciente(pt.paciente_id)
      and odf_privado.usuario_pode_acessar_consultorio(pt.consultorio_id)
  )
);

drop policy if exists itens_plano_insert_paciente on public.itens_plano_tratamento;
create policy itens_plano_insert_paciente
on public.itens_plano_tratamento
for insert
to authenticated
with check (
  exists (
    select 1
    from public.planos_tratamento pt
    where pt.id = plano_tratamento_id
      and odf_privado.usuario_dono_profissional(pt.profissional_id)
      and odf_privado.usuario_pode_acessar_paciente(pt.paciente_id)
      and odf_privado.usuario_pode_acessar_consultorio(pt.consultorio_id)
  )
);

drop policy if exists itens_plano_update_paciente on public.itens_plano_tratamento;
create policy itens_plano_update_paciente
on public.itens_plano_tratamento
for update
to authenticated
using (
  exists (
    select 1
    from public.planos_tratamento pt
    where pt.id = plano_tratamento_id
      and odf_privado.usuario_pode_acessar_paciente(pt.paciente_id)
      and odf_privado.usuario_pode_acessar_consultorio(pt.consultorio_id)
  )
)
with check (
  exists (
    select 1
    from public.planos_tratamento pt
    where pt.id = plano_tratamento_id
      and odf_privado.usuario_dono_profissional(pt.profissional_id)
      and odf_privado.usuario_pode_acessar_paciente(pt.paciente_id)
      and odf_privado.usuario_pode_acessar_consultorio(pt.consultorio_id)
  )
);
