-- OdontoFlow - fecha um contorno de dois passos na correcao anterior
-- (20260902110000_corrigir_compartilhamento_pacientes.sql).
--
-- O ramo de "vinculo proprio" da policy de insert em paciente_consultorios exigia so
-- acesso generico ao paciente + acesso generico ao consultorio - nao exigia que o
-- chamador ja atendesse aquele paciente ESPECIFICAMENTE naquele consultorio. Isso
-- permitia fabricar a evidencia usada pelo ramo de convite:
--
--   1) Profissional P atende de verdade o paciente X so no consultorio A, mas tambem
--      trabalha (normalmente) no consultorio B, sem nenhuma relacao com X.
--      P insere um vinculo proprio (paciente_id=X, consultorio_id=B, profissional_id=P).
--      Isso passava porque so exigia acesso generico a X (via A) e acesso generico a B.
--   2) Agora existe uma linha real em paciente_consultorios para (X, B, P), entao
--      `usuario_atende_paciente_no_consultorio(X, B)` fica verdadeiro - mesmo sem
--      nenhuma relacao legitima entre X e o consultorio B. P convida o colega Y de B
--      para X, e o ramo de convite aceita porque essa evidencia (fabricada no passo 1)
--      e identica a uma evidencia legitima.
--
-- Resultado: o paciente X, que so era atendido em A, vaza para o consultorio B - o
-- mesmo problema que a migracao anterior queria fechar, so que em dois passos.
--
-- Correcao: o ramo de "vinculo proprio" para abrir um NOVO consultorio (um par
-- paciente+consultorio ainda sem nenhum vinculo) so pode ser usado pelo profissional
-- que e o CRIADOR do cadastro do paciente (`pacientes.criado_por_profissional_id`,
-- imutavel desde a migracao 20260902100000). O criador ja tem acesso irrestrito ao
-- paciente de qualquer forma (e o ancora de confianca do cadastro); qualquer outro
-- profissional - mesmo com vinculo legitimo em outro consultorio - so pode convidar
-- colegas para o MESMO par (paciente, consultorio) onde ja tem um vinculo real, nunca
-- abrir um consultorio novo para esse paciente.

create or replace function odf_privado.usuario_e_criador_paciente(paciente_uuid uuid)
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
  );
$$;

revoke all on function odf_privado.usuario_e_criador_paciente(uuid) from public;
revoke all on function odf_privado.usuario_e_criador_paciente(uuid) from anon;
grant execute on function odf_privado.usuario_e_criador_paciente(uuid) to authenticated;

drop policy if exists paciente_consultorios_insert_proprio on public.paciente_consultorios;
create policy paciente_consultorios_insert_proprio
on public.paciente_consultorios
for insert
to authenticated
with check (
  odf_privado.usuario_pode_acessar_paciente(paciente_id)
  and odf_privado.usuario_pode_acessar_consultorio(consultorio_id)
  and (
    -- so o criador do cadastro do paciente pode abrir um vinculo proprio em QUALQUER
    -- consultorio onde ele atenda (inclui o cadastro inicial do paciente)
    (
      odf_privado.usuario_e_criador_paciente(paciente_id)
      and odf_privado.usuario_dono_profissional(profissional_id)
    )
    -- convite a um colega: so vale para o MESMO par (paciente, consultorio) onde o
    -- chamador ja tem um vinculo real e ativo, e o colega precisa pertencer aquele
    -- mesmo consultorio
    or (
      odf_privado.usuario_atende_paciente_no_consultorio(paciente_id, consultorio_id)
      and odf_privado.profissional_vinculado_consultorio(profissional_id, consultorio_id)
    )
  )
);
