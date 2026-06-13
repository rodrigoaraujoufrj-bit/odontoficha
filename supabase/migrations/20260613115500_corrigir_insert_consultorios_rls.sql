-- OdontoFlow MVP - corrige insert de consultorios via cliente autenticado.
-- O usuario dono do consultorio passa a ser definido pelo JWT no banco.

create or replace function public.definir_criador_consultorio()
returns trigger
language plpgsql
security invoker
as $$
begin
  if auth.uid() is null then
    raise exception 'usuario autenticado obrigatorio para criar consultorio';
  end if;

  new.criado_por_usuario_id = auth.uid();
  return new;
end;
$$;

drop trigger if exists consultorios_definir_criador on public.consultorios;
create trigger consultorios_definir_criador
before insert on public.consultorios
for each row execute function public.definir_criador_consultorio();

drop policy if exists consultorios_insert_proprio on public.consultorios;
create policy consultorios_insert_proprio
on public.consultorios
for insert
to authenticated
with check (auth.uid() is not null);
