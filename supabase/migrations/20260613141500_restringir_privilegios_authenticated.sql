-- OdontoFlow MVP - restringe privilegios de authenticated nas tabelas clinicas.
-- RLS continua sendo a barreira por linha; estes grants reduzem a superficie de acesso.

revoke all on table public.profissionais from authenticated;
revoke all on table public.consultorios from authenticated;
revoke all on table public.profissional_consultorios from authenticated;
revoke all on table public.pacientes from authenticated;
revoke all on table public.paciente_consultorios from authenticated;
revoke all on table public.anamneses from authenticated;

grant select, insert, update on table public.profissionais to authenticated;
grant select, insert, update on table public.consultorios to authenticated;
grant select, insert, update on table public.profissional_consultorios to authenticated;
grant select, insert, update on table public.pacientes to authenticated;
grant select, insert, update on table public.paciente_consultorios to authenticated;
grant select, insert, update on table public.anamneses to authenticated;
