-- OdontoFlow - compartilhamento de paciente entre profissionais do mesmo consultorio
--
-- Contexto de negocio confirmado: mais de um dentista pode dividir o mesmo paciente
-- dependendo do tratamento (ex.: casal de dentistas no mesmo consultorio). O mecanismo
-- de vinculo (paciente_consultorios) ja existia e ja e usado no cadastro do paciente,
-- mas faltava: (1) proteger as colunas de auditoria "criado_por_*" contra reatribuicao
-- via UPDATE, (2) permitir que quem ja acessa um paciente convide um colega do mesmo
-- consultorio para ele, e (3) permitir que colegas do mesmo consultorio se enxerguem
-- (hoje cada profissional so ve a propria linha em `profissionais`).

-- 1) "criado_por_*" vira auditoria imutavel: nunca muda depois do insert.
-- Mesma logica do trigger `consultorios_definir_criador` (que fixa o valor no insert),
-- agora tambem travando o valor no update.

create or replace function public.preservar_criado_por_profissional()
returns trigger
language plpgsql
as $$
begin
  new.criado_por_profissional_id = old.criado_por_profissional_id;
  return new;
end;
$$;

drop trigger if exists pacientes_preservar_criador on public.pacientes;
create trigger pacientes_preservar_criador
before update on public.pacientes
for each row execute function public.preservar_criado_por_profissional();

create or replace function public.preservar_criado_por_usuario()
returns trigger
language plpgsql
as $$
begin
  new.criado_por_usuario_id = old.criado_por_usuario_id;
  return new;
end;
$$;

drop trigger if exists consultorios_preservar_criador on public.consultorios;
create trigger consultorios_preservar_criador
before update on public.consultorios
for each row execute function public.preservar_criado_por_usuario();

-- 2) Colegas do mesmo consultorio precisam se enxergar (nome, CRO) para a colaboracao
-- funcionar: hoje `profissionais_select_proprio` so deixa cada um ver a propria linha.

create or replace function odf_privado.usuario_e_colega(profissional_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.profissional_consultorios minha
    join public.profissionais eu on eu.id = minha.profissional_id
    join public.profissional_consultorios dele
      on dele.consultorio_id = minha.consultorio_id
     and dele.profissional_id = profissional_uuid
     and dele.ativo = true
    where eu.usuario_id = auth.uid()
      and minha.ativo = true
  );
$$;

revoke all on function odf_privado.usuario_e_colega(uuid) from public;
revoke all on function odf_privado.usuario_e_colega(uuid) from anon;
grant execute on function odf_privado.usuario_e_colega(uuid) to authenticated;

drop policy if exists profissionais_select_proprio on public.profissionais;
create policy profissionais_select_proprio
on public.profissionais
for select
to authenticated
using (
  usuario_id = auth.uid()
  or odf_privado.usuario_e_colega(id)
);

-- O vinculo profissional-consultorio tambem precisa ficar visivel entre colegas do
-- mesmo consultorio (antes, cada um so via a propria linha em profissional_consultorios).

drop policy if exists profissional_consultorios_select_proprio on public.profissional_consultorios;
create policy profissional_consultorios_select_proprio
on public.profissional_consultorios
for select
to authenticated
using (
  odf_privado.usuario_dono_profissional(profissional_id)
  or odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
);

-- 3) Compartilhar paciente com um colega: quem ja acessa o paciente e o consultorio
-- pode vincular outro profissional do MESMO consultorio a esse paciente. Antes, a
-- policy exigia que o vinculo so pudesse ser criado para o proprio profissional
-- (impossivel convidar um colega).

create or replace function odf_privado.profissional_vinculado_consultorio(profissional_uuid uuid, consultorio_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.profissional_consultorios pc
    where pc.profissional_id = profissional_uuid
      and pc.consultorio_id = consultorio_uuid
      and pc.ativo = true
  );
$$;

revoke all on function odf_privado.profissional_vinculado_consultorio(uuid, uuid) from public;
revoke all on function odf_privado.profissional_vinculado_consultorio(uuid, uuid) from anon;
grant execute on function odf_privado.profissional_vinculado_consultorio(uuid, uuid) to authenticated;

drop policy if exists paciente_consultorios_insert_proprio on public.paciente_consultorios;
create policy paciente_consultorios_insert_proprio
on public.paciente_consultorios
for insert
to authenticated
with check (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
  and odf_privado.profissional_vinculado_consultorio(profissional_id, consultorio_id)
);

-- O vinculo compartilhado tambem precisa ficar visivel para toda a equipe que ja
-- atende o paciente naquele consultorio, nao so para o dono da linha do vinculo
-- (necessario para a tela mostrar "compartilhado com: fulano, beltrana").

drop policy if exists paciente_consultorios_select_proprio on public.paciente_consultorios;
create policy paciente_consultorios_select_proprio
on public.paciente_consultorios
for select
to authenticated
using (
  odf_privado.usuario_dono_profissional(profissional_id)
  or (
    odf_privado.usuario_pode_acessar_paciente(paciente_id)
    and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
  )
);
