-- OdontoFlow - historico de envio de orcamento (PDF/WhatsApp)
--
-- Nao e a tabela "orcamentos" completa (com fluxo de aprovacao/recusa) prevista
-- em docs/modelo_dados.md como "Tabela Futura" - essa continua fora de escopo,
-- por decisao ja registrada. Isto e mais simples: um log imutavel de quando um
-- orcamento foi gerado em PDF ou preparado/aberto no WhatsApp, com um retrato
-- dos itens naquele momento, para o dentista conseguir ver depois o que foi
-- enviado ao paciente sem precisar confiar na memoria.
--
-- Envio nao e edicao do plano: qualquer profissional com acesso legitimo ao
-- paciente/consultorio pode gerar e registrar um envio, mesmo sem ser o dono
-- atual do plano (mesma logica de "so leitura, nao mutacao do item").

create table if not exists public.envios_plano_tratamento (
  id uuid primary key default gen_random_uuid(),
  plano_tratamento_id uuid not null references public.planos_tratamento(id) on delete cascade,
  profissional_id uuid not null references public.profissionais(id) on delete restrict,
  canal text not null,
  valor_total numeric(12,2) not null default 0,
  quantidade_itens integer not null default 0,
  itens_snapshot jsonb not null default '[]'::jsonb,
  destinatario_telefone text,
  criado_em timestamptz not null default now(),

  constraint envios_plano_canal_valido check (canal in ('pdf', 'whatsapp')),
  constraint envios_plano_valor_nao_negativo check (valor_total >= 0)
);

create index if not exists idx_envios_plano_tratamento_plano_id on public.envios_plano_tratamento(plano_tratamento_id);

alter table public.envios_plano_tratamento enable row level security;

revoke all on table public.envios_plano_tratamento from anon;
grant select, insert on table public.envios_plano_tratamento to authenticated;

drop policy if exists envios_plano_select_paciente on public.envios_plano_tratamento;
create policy envios_plano_select_paciente
on public.envios_plano_tratamento
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

drop policy if exists envios_plano_insert_paciente on public.envios_plano_tratamento;
create policy envios_plano_insert_paciente
on public.envios_plano_tratamento
for insert
to authenticated
with check (
  odf_privado.usuario_dono_profissional(profissional_id)
  and exists (
    select 1
    from public.planos_tratamento pt
    where pt.id = plano_tratamento_id
      and odf_privado.usuario_pode_acessar_paciente(pt.paciente_id)
      and odf_privado.usuario_pode_acessar_consultorio(pt.consultorio_id)
  )
);

comment on table public.envios_plano_tratamento is
  'Log imutavel de geracao/envio de orcamento (PDF ou WhatsApp). Sem update/delete: e historico, nao dado editavel.';
comment on column public.envios_plano_tratamento.itens_snapshot is
  'Copia dos itens do plano no momento do envio (dente, face, procedimento, valor, status) - o plano pode mudar depois.';
