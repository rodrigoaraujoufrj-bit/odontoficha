-- OdontoFlow - trava a identidade do vinculo paciente_consultorios contra UPDATE
--
-- As correcoes anteriores (20260902110000, 20260902120000) travaram o INSERT em
-- paciente_consultorios, mas a policy de UPDATE ja existente desde 20260613103000
-- (`paciente_consultorios_update_proprio`) deixa o dono do vinculo
-- (odf_privado.usuario_dono_profissional(profissional_id)) atualizar qualquer coluna
-- da propria linha - inclusive `consultorio_id` e `paciente_id`. Isso reabre o mesmo
-- vazamento por outro caminho:
--
--   Profissional P tem um vinculo legitimo (paciente X, consultorio A). Ele executa
--     update paciente_consultorios set consultorio_id = B where profissional_id = P ...
--   Depois do update, `usuario_pode_acessar_paciente(X)` continua verdadeiro (essa
--   funcao so verifica se existe QUALQUER vinculo ativo de P com X, nao em qual
--   consultorio) e `usuario_pode_acessar_consultorio(B)` so verifica se P trabalha
--   em B. O vinculo "pulou" de A para B sem passar pela regra mais rigorosa do
--   insert (que exige ser o criador do paciente para abrir um consultorio novo).
--   O mesmo vale para trocar `paciente_id` ou `profissional_id` de uma linha existente.
--
-- Correcao: `paciente_id`, `consultorio_id` e `profissional_id` passam a ser
-- imutaveis depois do insert - mesmo padrao ja usado para `criado_por_profissional_id`
-- (pacientes) e `criado_por_usuario_id` (consultorios). Um vinculo e definido por essa
-- tripla; para mudar quem atende onde, cria-se um vinculo novo (sujeito a regra mais
-- rigorosa do insert) e desativa-se o antigo (`ativo = false`, que continua editavel
-- normalmente).

create or replace function public.preservar_identidade_vinculo_paciente()
returns trigger
language plpgsql
as $$
begin
  new.paciente_id = old.paciente_id;
  new.consultorio_id = old.consultorio_id;
  new.profissional_id = old.profissional_id;
  return new;
end;
$$;

drop trigger if exists paciente_consultorios_preservar_identidade on public.paciente_consultorios;
create trigger paciente_consultorios_preservar_identidade
before update on public.paciente_consultorios
for each row execute function public.preservar_identidade_vinculo_paciente();

-- O mesmo padrao (funcao de acesso que consulta a propria tabela sendo alterada)
-- existe em `profissional_consultorios`: `odf_privado.usuario_pode_acessar_consultorio`
-- consulta essa tabela, e a policy de update so exige `usuario_dono_profissional`
-- (dono da linha) + acesso ao consultorio *pos-update* - o mesmo vinculo sendo
-- alterado pode se auto-satisfazer. Um profissional poderia atualizar a propria
-- linha trocando `consultorio_id` para um consultorio onde nunca teve vinculo algum.
-- Mesma correcao: `profissional_id` e `consultorio_id` viram imutaveis apos o insert.

create or replace function public.preservar_identidade_vinculo_profissional()
returns trigger
language plpgsql
as $$
begin
  new.profissional_id = old.profissional_id;
  new.consultorio_id = old.consultorio_id;
  return new;
end;
$$;

drop trigger if exists profissional_consultorios_preservar_identidade on public.profissional_consultorios;
create trigger profissional_consultorios_preservar_identidade
before update on public.profissional_consultorios
for each row execute function public.preservar_identidade_vinculo_profissional();
