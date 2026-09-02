-- OdontoFlow - corrige a migracao de compartilhamento de pacientes
-- (20260902100000_compartilhamento_pacientes_entre_profissionais.sql), apos revisao
-- adversarial encontrar dois problemas:
--
-- 1) CRITICO: a policy de insert em paciente_consultorios exigia so "acesso ao
--    paciente" + "acesso ao consultorio" (dois checks independentes). Um profissional
--    vinculado a dois consultorios distintos (cenario normal, ja suportado) podia
--    convidar um colega do consultorio B para um paciente que so era atendido no
--    consultorio A - vazando o paciente para uma clinica sem nenhuma relacao com ele.
--    Corrigido: convidar outro profissional so e permitido quando o proprio chamador
--    ja atende aquele paciente especificamente NAQUELE consultorio (nao em qualquer
--    consultorio que ele acesse por outro motivo).
--
-- 2) `profissionais_select_proprio` abria a linha inteira do colega (telefone, email,
--    observacoes), quando a intencao era so nome e CRO para fins de colaboracao. RLS e
--    por linha, nao por coluna, entao a policy nao tinha como filtrar so essas colunas.
--    Corrigido: a visibilidade tabela-a-tabela volta a ser so a propria linha; nome/CRO
--    de colegas agora sao expostos so por duas funcoes (RPC) dedicadas, que devolvem
--    apenas as colunas necessarias e nunca a linha inteira de terceiros.
--
-- 3) Bug de interface (corrigido no app.html, nao aqui): a lista "compartilhado com"
--    incluia o proprio profissional, entao o aviso "so voce atende este paciente"
--    nunca aparecia.

-- 1) Corrige o insert de paciente_consultorios: exige vinculo ja existente do
-- chamador exatamente naquele par (paciente, consultorio) antes de convidar outro
-- profissional para esse mesmo par.

create or replace function odf_privado.usuario_atende_paciente_no_consultorio(paciente_uuid uuid, consultorio_uuid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.paciente_consultorios pc
    join public.profissionais p on p.id = pc.profissional_id
    where pc.paciente_id = paciente_uuid
      and pc.consultorio_id = consultorio_uuid
      and pc.ativo = true
      and p.usuario_id = auth.uid()
  );
$$;

revoke all on function odf_privado.usuario_atende_paciente_no_consultorio(uuid, uuid) from public;
revoke all on function odf_privado.usuario_atende_paciente_no_consultorio(uuid, uuid) from anon;
grant execute on function odf_privado.usuario_atende_paciente_no_consultorio(uuid, uuid) to authenticated;

drop policy if exists paciente_consultorios_insert_proprio on public.paciente_consultorios;
create policy paciente_consultorios_insert_proprio
on public.paciente_consultorios
for insert
to authenticated
with check (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
  and (
    -- vinculo proprio (ex.: cadastro inicial do paciente, ou o profissional se
    -- adicionando a um segundo consultorio onde ja atende esse paciente)
    odf_privado.usuario_dono_profissional(profissional_id)
    -- convite a um colega: so vale para o MESMO par (paciente, consultorio) onde o
    -- chamador ja atende, e o colega precisa pertencer aquele mesmo consultorio
    or (
      odf_privado.usuario_atende_paciente_no_consultorio(paciente_id, consultorio_id)
      and odf_privado.profissional_vinculado_consultorio(profissional_id, consultorio_id)
    )
  )
);

-- 2) Reverte a visibilidade tabela-a-tabela para "so a propria linha" e move a
-- listagem de colegas para funcoes que devolvem so as colunas necessarias.

drop policy if exists profissionais_select_proprio on public.profissionais;
create policy profissionais_select_proprio
on public.profissionais
for select
to authenticated
using (usuario_id = auth.uid());

drop policy if exists profissional_consultorios_select_proprio on public.profissional_consultorios;
create policy profissional_consultorios_select_proprio
on public.profissional_consultorios
for select
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id));

drop policy if exists paciente_consultorios_select_proprio on public.paciente_consultorios;
create policy paciente_consultorios_select_proprio
on public.paciente_consultorios
for select
to authenticated
using (odf_privado.usuario_dono_profissional(profissional_id));

drop function if exists odf_privado.usuario_e_colega(uuid);

create or replace function public.colegas_do_consultorio(consultorio_uuid uuid)
returns table (id uuid, nome text, cro text, cro_uf text)
language sql
security definer
set search_path = public
stable
as $$
  select p.id, p.nome, p.cro, p.cro_uf
  from public.profissionais p
  join public.profissional_consultorios pc on pc.profissional_id = p.id
  where pc.consultorio_id = consultorio_uuid
    and pc.ativo = true
    and odf_privado.usuario_pode_acessar_consultorio(consultorio_uuid);
$$;

revoke all on function public.colegas_do_consultorio(uuid) from public;
revoke all on function public.colegas_do_consultorio(uuid) from anon;
grant execute on function public.colegas_do_consultorio(uuid) to authenticated;

create or replace function public.profissionais_vinculados_paciente(paciente_uuid uuid, consultorio_uuid uuid)
returns table (id uuid, nome text)
language sql
security definer
set search_path = public
stable
as $$
  select p.id, p.nome
  from public.profissionais p
  join public.paciente_consultorios pc on pc.profissional_id = p.id
  where pc.paciente_id = paciente_uuid
    and pc.consultorio_id = consultorio_uuid
    and pc.ativo = true
    and odf_privado.usuario_pode_acessar_paciente(paciente_uuid)
    and odf_privado.usuario_pode_acessar_consultorio(consultorio_uuid);
$$;

revoke all on function public.profissionais_vinculados_paciente(uuid, uuid) from public;
revoke all on function public.profissionais_vinculados_paciente(uuid, uuid) from anon;
grant execute on function public.profissionais_vinculados_paciente(uuid, uuid) to authenticated;
