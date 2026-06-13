-- OdontoFlow MVP - cadastros, anamnese e RLS inicial
-- Projeto alvo: https://wnpezdxwrdesrbqvtuwu.supabase.co

create extension if not exists pgcrypto;

create or replace function public.tocar_atualizado_em()
returns trigger
language plpgsql
as $$
begin
  new.atualizado_em = now();
  return new;
end;
$$;

create table if not exists public.profissionais (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  telefone text not null,
  email text not null,
  cro text not null,
  cro_uf text not null,
  observacoes text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint profissionais_usuario_unico unique (usuario_id),
  constraint profissionais_telefone_11_digitos check (telefone ~ '^[0-9]{11}$'),
  constraint profissionais_email_valido check (email = lower(email) and email like '%@%' and email not like '% %'),
  constraint profissionais_cro_uf_valida check (cro_uf ~ '^[A-Z]{2}$')
);

create table if not exists public.consultorios (
  id uuid primary key default gen_random_uuid(),
  criado_por_usuario_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome text not null,
  telefone text,
  email text,
  endereco text,
  cidade text,
  uf text,
  observacoes text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint consultorios_telefone_11_digitos check (telefone is null or telefone ~ '^[0-9]{11}$'),
  constraint consultorios_email_valido check (email is null or (email = lower(email) and email like '%@%' and email not like '% %')),
  constraint consultorios_uf_valida check (uf is null or uf ~ '^[A-Z]{2}$')
);

create table if not exists public.profissional_consultorios (
  id uuid primary key default gen_random_uuid(),
  profissional_id uuid not null references public.profissionais(id) on delete cascade,
  consultorio_id uuid not null references public.consultorios(id) on delete cascade,
  ativo boolean not null default true,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint profissional_consultorios_vinculo_unico unique (profissional_id, consultorio_id)
);

create table if not exists public.pacientes (
  id uuid primary key default gen_random_uuid(),
  criado_por_profissional_id uuid not null references public.profissionais(id) on delete restrict,
  nome text not null,
  telefone text,
  email text,
  cpf text,
  data_nascimento date,
  observacoes text,
  arquivado_em timestamptz,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint pacientes_contato_minimo check (telefone is not null or email is not null),
  constraint pacientes_telefone_11_digitos check (telefone is null or telefone ~ '^[0-9]{11}$'),
  constraint pacientes_cpf_11_digitos check (cpf is null or cpf ~ '^[0-9]{11}$'),
  constraint pacientes_email_valido check (email is null or (email = lower(email) and email like '%@%' and email not like '% %'))
);

create table if not exists public.paciente_consultorios (
  id uuid primary key default gen_random_uuid(),
  paciente_id uuid not null references public.pacientes(id) on delete cascade,
  consultorio_id uuid not null references public.consultorios(id) on delete restrict,
  profissional_id uuid not null references public.profissionais(id) on delete restrict,
  ativo boolean not null default true,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),

  constraint paciente_consultorios_vinculo_unico unique (paciente_id, consultorio_id, profissional_id)
);

create table if not exists public.anamneses (
  id uuid primary key default gen_random_uuid(),
  paciente_id uuid not null references public.pacientes(id) on delete cascade,
  profissional_id uuid not null references public.profissionais(id) on delete restrict,
  queixa_principal text,
  historico_medico text,
  alergias text,
  medicamentos_uso_continuo text,
  doencas_sistemicas text,
  gestante boolean,
  sangramento_excessivo boolean,
  possui_diabetes boolean,
  possui_hipertensao boolean,
  possui_cardiopatia boolean,
  observacoes_clinicas text,
  preenchida_em timestamptz,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);

create index if not exists idx_profissionais_usuario_id on public.profissionais(usuario_id);
create index if not exists idx_consultorios_criado_por_usuario_id on public.consultorios(criado_por_usuario_id);
create index if not exists idx_profissional_consultorios_profissional_id on public.profissional_consultorios(profissional_id);
create index if not exists idx_profissional_consultorios_consultorio_id on public.profissional_consultorios(consultorio_id);
create index if not exists idx_pacientes_criado_por_profissional_id on public.pacientes(criado_por_profissional_id);
create index if not exists idx_pacientes_nome on public.pacientes(nome);
create unique index if not exists idx_pacientes_cpf_por_profissional_unico
on public.pacientes(criado_por_profissional_id, cpf)
where cpf is not null;
create index if not exists idx_paciente_consultorios_paciente_id on public.paciente_consultorios(paciente_id);
create index if not exists idx_paciente_consultorios_profissional_id on public.paciente_consultorios(profissional_id);
create index if not exists idx_paciente_consultorios_consultorio_id on public.paciente_consultorios(consultorio_id);
create index if not exists idx_anamneses_paciente_id on public.anamneses(paciente_id);
create index if not exists idx_anamneses_profissional_id on public.anamneses(profissional_id);

create schema if not exists odf_privado;
revoke all on schema odf_privado from public;
revoke all on schema odf_privado from anon;

create or replace function odf_privado.usuario_dono_profissional(profissional_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.profissionais p
    where p.id = profissional_uuid
      and p.usuario_id = auth.uid()
  );
$$;

create or replace function odf_privado.usuario_pode_acessar_consultorio(consultorio_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.consultorios c
    where c.id = consultorio_uuid
      and c.criado_por_usuario_id = auth.uid()
  )
  or exists (
    select 1
    from public.profissional_consultorios pc
    join public.profissionais p on p.id = pc.profissional_id
    where pc.consultorio_id = consultorio_uuid
      and pc.ativo = true
      and p.usuario_id = auth.uid()
  );
$$;

create or replace function odf_privado.usuario_pode_acessar_paciente(paciente_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.pacientes pa
    join public.profissionais p on p.id = pa.criado_por_profissional_id
    where pa.id = paciente_uuid
      and p.usuario_id = auth.uid()
  )
  or exists (
    select 1
    from public.paciente_consultorios pc
    join public.profissionais p on p.id = pc.profissional_id
    where pc.paciente_id = paciente_uuid
      and pc.ativo = true
      and p.usuario_id = auth.uid()
  );
$$;

grant usage on schema odf_privado to authenticated;
revoke all on function odf_privado.usuario_dono_profissional(uuid) from public;
revoke all on function odf_privado.usuario_pode_acessar_consultorio(uuid) from public;
revoke all on function odf_privado.usuario_pode_acessar_paciente(uuid) from public;
revoke all on function odf_privado.usuario_dono_profissional(uuid) from anon;
revoke all on function odf_privado.usuario_pode_acessar_consultorio(uuid) from anon;
revoke all on function odf_privado.usuario_pode_acessar_paciente(uuid) from anon;
grant execute on function odf_privado.usuario_dono_profissional(uuid) to authenticated;
grant execute on function odf_privado.usuario_pode_acessar_consultorio(uuid) to authenticated;
grant execute on function odf_privado.usuario_pode_acessar_paciente(uuid) to authenticated;

drop trigger if exists profissionais_tocar_atualizado_em on public.profissionais;
create trigger profissionais_tocar_atualizado_em
before update on public.profissionais
for each row execute function public.tocar_atualizado_em();

drop trigger if exists consultorios_tocar_atualizado_em on public.consultorios;
create trigger consultorios_tocar_atualizado_em
before update on public.consultorios
for each row execute function public.tocar_atualizado_em();

drop trigger if exists profissional_consultorios_tocar_atualizado_em on public.profissional_consultorios;
create trigger profissional_consultorios_tocar_atualizado_em
before update on public.profissional_consultorios
for each row execute function public.tocar_atualizado_em();

drop trigger if exists pacientes_tocar_atualizado_em on public.pacientes;
create trigger pacientes_tocar_atualizado_em
before update on public.pacientes
for each row execute function public.tocar_atualizado_em();

drop trigger if exists paciente_consultorios_tocar_atualizado_em on public.paciente_consultorios;
create trigger paciente_consultorios_tocar_atualizado_em
before update on public.paciente_consultorios
for each row execute function public.tocar_atualizado_em();

drop trigger if exists anamneses_tocar_atualizado_em on public.anamneses;
create trigger anamneses_tocar_atualizado_em
before update on public.anamneses
for each row execute function public.tocar_atualizado_em();

alter table public.profissionais enable row level security;
alter table public.consultorios enable row level security;
alter table public.profissional_consultorios enable row level security;
alter table public.pacientes enable row level security;
alter table public.paciente_consultorios enable row level security;
alter table public.anamneses enable row level security;

revoke all on table public.profissionais from anon;
revoke all on table public.consultorios from anon;
revoke all on table public.profissional_consultorios from anon;
revoke all on table public.pacientes from anon;
revoke all on table public.paciente_consultorios from anon;
revoke all on table public.anamneses from anon;

grant usage on schema public to authenticated;
grant select, insert, update on table public.profissionais to authenticated;
grant select, insert, update on table public.consultorios to authenticated;
grant select, insert, update on table public.profissional_consultorios to authenticated;
grant select, insert, update on table public.pacientes to authenticated;
grant select, insert, update on table public.paciente_consultorios to authenticated;
grant select, insert, update on table public.anamneses to authenticated;

drop policy if exists profissionais_select_proprio on public.profissionais;
create policy profissionais_select_proprio
on public.profissionais
for select
to authenticated
using (usuario_id = auth.uid());

drop policy if exists profissionais_insert_proprio on public.profissionais;
create policy profissionais_insert_proprio
on public.profissionais
for insert
to authenticated
with check (usuario_id = auth.uid());

drop policy if exists profissionais_update_proprio on public.profissionais;
create policy profissionais_update_proprio
on public.profissionais
for update
to authenticated
using (usuario_id = auth.uid())
with check (usuario_id = auth.uid());

drop policy if exists consultorios_select_vinculados on public.consultorios;
create policy consultorios_select_vinculados
on public.consultorios
for select
to authenticated
using (odf_privado.usuario_pode_acessar_consultorio(id));

drop policy if exists consultorios_insert_proprio on public.consultorios;
create policy consultorios_insert_proprio
on public.consultorios
for insert
to authenticated
with check (criado_por_usuario_id = auth.uid());

drop policy if exists consultorios_update_vinculados on public.consultorios;
create policy consultorios_update_vinculados
on public.consultorios
for update
to authenticated
using (odf_privado.usuario_pode_acessar_consultorio(id))
with check (odf_privado.usuario_pode_acessar_consultorio(id));

drop policy if exists profissional_consultorios_select_proprio on public.profissional_consultorios;
create policy profissional_consultorios_select_proprio
on public.profissional_consultorios
for select
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id));

drop policy if exists profissional_consultorios_insert_proprio on public.profissional_consultorios;
create policy profissional_consultorios_insert_proprio
on public.profissional_consultorios
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists profissional_consultorios_update_proprio on public.profissional_consultorios;
create policy profissional_consultorios_update_proprio
on public.profissional_consultorios
for update
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id))
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists pacientes_select_proprio on public.pacientes;
create policy pacientes_select_proprio
on public.pacientes
for select
to authenticated
using (odf_privado.usuario_pode_acessar_paciente(id));

drop policy if exists pacientes_insert_proprio on public.pacientes;
create policy pacientes_insert_proprio
on public.pacientes
for insert
to authenticated
with check (odf_privado.usuario_dono_profissional(criado_por_profissional_id));

drop policy if exists pacientes_update_proprio on public.pacientes;
create policy pacientes_update_proprio
on public.pacientes
for update
to authenticated
using (odf_privado.usuario_pode_acessar_paciente(id))
with check (odf_privado.usuario_pode_acessar_paciente(id));

drop policy if exists paciente_consultorios_select_proprio on public.paciente_consultorios;
create policy paciente_consultorios_select_proprio
on public.paciente_consultorios
for select
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id));

drop policy if exists paciente_consultorios_insert_proprio on public.paciente_consultorios;
create policy paciente_consultorios_insert_proprio
on public.paciente_consultorios
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists paciente_consultorios_update_proprio on public.paciente_consultorios;
create policy paciente_consultorios_update_proprio
on public.paciente_consultorios
for update
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id))
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

drop policy if exists anamneses_select_proprio on public.anamneses;
create policy anamneses_select_proprio
on public.anamneses
for select
to authenticated
using (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
);

drop policy if exists anamneses_insert_proprio on public.anamneses;
create policy anamneses_insert_proprio
on public.anamneses
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
);

drop policy if exists anamneses_update_proprio on public.anamneses;
create policy anamneses_update_proprio
on public.anamneses
for update
to authenticated
using (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
)
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and odf_privado.usuario_pode_acessar_paciente(paciente_id)
);
