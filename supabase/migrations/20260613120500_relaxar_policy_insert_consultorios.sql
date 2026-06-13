-- OdontoFlow MVP - relaxa a policy de insert porque o dono e definido por trigger.
-- A trigger `consultorios_definir_criador` forca `criado_por_usuario_id = auth.uid()`.

drop policy if exists consultorios_insert_proprio on public.consultorios;
create policy consultorios_insert_proprio
on public.consultorios
for insert
to authenticated
with check (true);
