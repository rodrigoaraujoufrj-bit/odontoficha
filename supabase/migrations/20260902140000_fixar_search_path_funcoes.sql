-- OdontoFlow - fixa search_path nas funcoes de trigger em plpgsql
--
-- O linter de seguranca do Supabase (function_search_path_mutable) apontou que as
-- funcoes de trigger abaixo nao fixam `search_path`, ao contrario das funcoes SQL em
-- `odf_privado.*` (que ja usam `set search_path = public` desde a primeira migracao).
-- Sem isso fixado, uma funcao pode, em teoria, resolver um nome de objeto (tabela,
-- funcao) de um schema inesperado se o search_path da sessao for manipulado. O risco
-- pratico aqui e baixo (sao funcoes de trigger, nao chamaveis diretamente por RPC),
-- mas o custo de corrigir e minimo e mantem o padrao consistente em todo o projeto.

create or replace function public.tocar_atualizado_em()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.atualizado_em = now();
  return new;
end;
$$;

create or replace function public.definir_criador_consultorio()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'usuario autenticado obrigatorio para criar consultorio';
  end if;

  new.criado_por_usuario_id = auth.uid();
  return new;
end;
$$;

create or replace function public.preservar_criado_por_profissional()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.criado_por_profissional_id = old.criado_por_profissional_id;
  return new;
end;
$$;

create or replace function public.preservar_criado_por_usuario()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.criado_por_usuario_id = old.criado_por_usuario_id;
  return new;
end;
$$;

create or replace function public.preservar_identidade_vinculo_paciente()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.paciente_id = old.paciente_id;
  new.consultorio_id = old.consultorio_id;
  new.profissional_id = old.profissional_id;
  return new;
end;
$$;

create or replace function public.preservar_identidade_vinculo_profissional()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.profissional_id = old.profissional_id;
  new.consultorio_id = old.consultorio_id;
  return new;
end;
$$;
