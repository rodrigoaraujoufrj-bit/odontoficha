-- OdontoFlow - consentimento para comunicacao por WhatsApp (LGPD)
--
-- O app ja usa wa.me para enviar orcamento ao paciente (ver
-- envios_plano_tratamento, canal 'whatsapp'). Esse uso pontual e
-- transacional - sobre o proprio tratamento do paciente - se apoia em
-- tutela da saude/legitimo interesse (Art. 11 par. 4 / Art. 7 IX da LGPD) e
-- nao exige consentimento.
--
-- Mas se um dia o consultorio quiser usar o mesmo telefone para algo alem do
-- tratamento do proprio paciente (lembrete de consulta com texto mais amplo,
-- qualquer marketing futuro), a LGPD exige consentimento registrado. Esta
-- coluna guarda exatamente isso, pronta para quando/se essa necessidade
-- aparecer - nao muda em nada o fluxo atual de envio de orcamento.
alter table public.pacientes
  add column if not exists consentimento_whatsapp_em timestamptz;

comment on column public.pacientes.consentimento_whatsapp_em is
  'null = sem consentimento registrado (o uso transacional atual de WhatsApp para orcamento nao depende disso). Timestamp = quando o paciente consentiu em receber comunicacao por WhatsApp deste consultorio, para LGPD se um uso mais amplo (ex.: alem do proprio tratamento) exigir consentimento. Consentimento e revogavel: desmarcar limpa de volta para null, sem deixar timestamp historico falso.';
