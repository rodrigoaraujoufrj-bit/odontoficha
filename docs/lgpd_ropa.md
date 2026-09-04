# OdontoFlow — Registro das Operações de Tratamento (ROPA)

Última atualização: 2026-09-03

## O que é este documento

Inventário interno de quais dados o OdontoFlow trata, para quê, com qual base legal (LGPD, Lei 13.709/2018) e por quanto tempo. É o documento que sustenta o Aviso de Privacidade (`docs/lgpd_aviso_privacidade_modelo.md`) e que qualquer dentista/clínica que usa o OdontoFlow pode consultar para responder a ANPD ou a um paciente que exerça seus direitos.

**Papéis no modelo SaaS multi-tenant do OdontoFlow:**

- **Controlador**: cada dentista/clínica que usa o OdontoFlow é o controlador dos dados dos seus próprios pacientes. Decide o quê cadastrar, por quanto tempo manter vínculo ativo, e responde diretamente ao paciente.
- **Operador**: o OdontoFlow (software + equipe técnica) trata os dados em nome de cada controlador, para viabilizar o serviço. Contato do encarregado/suporte do operador, nesta fase: Rodrigo Araújo — rodrigoaraujo.ufrj@gmail.com (contato provisório, ver observação no Aviso de Privacidade).
- **Suboperador**: Supabase (infraestrutura de banco de dados e autenticação), região `sa-east-1` (São Paulo) — dado permanece em território brasileiro/América do Sul.

**Nota sobre acesso do operador**: a equipe técnica do OdontoFlow tem acesso administrativo à infraestrutura (via painel Supabase) para manutenção, suporte e correção de problemas. Esse acesso é técnico e excepcional — não é usado para consultar dado clínico de paciente por curiosidade ou para finalidade própria do OdontoFlow, e cada consultório é isolado dos demais por controle de acesso (RLS) na operação normal do app. Esta observação existe para que o documento seja honesto sobre a capacidade técnica real, não só sobre a intenção de uso.

## Convenções da tabela

- **Base legal "tutela da saúde"** = LGPD Art. 11, II, "h": tratamento de dado sensível de saúde sem exigir consentimento, quando indispensável à tutela da saúde e exercido por profissional/serviço de saúde. Cobre o núcleo clínico do produto (ficha, plano de tratamento, evolução).
- **Base legal "execução de contrato"** = LGPD Art. 7, V: necessário para o dentista usar o serviço (cadastro do profissional, do consultório) ou para a relação comercial entre paciente e clínica (agendamento, cobrança).
- **Base legal "legítimo interesse"** = LGPD Art. 7, IX: uso compatível com a finalidade para a qual o dado foi coletado, sem exigir consentimento à parte (ex.: registrar que um orçamento foi enviado, para o próprio controle do consultório).
- **Base legal "consentimento"** = LGPD Art. 7, I: só entra em jogo se o consultório usar o telefone do paciente para algo além do próprio tratamento (ex.: lembrete genérico, marketing). O envio de orçamento por WhatsApp em si é transacional e já coberto por tutela da saúde/legítimo interesse (Art. 11 §4 / Art. 7 IX), sem exigir consentimento.
- Retenção de dado clínico segue a Resolução CFO-SEC-91/2009 e a Lei 13.787/18: mínimo 20 anos a partir do último registro; o CFO recomenda guarda indefinida para prontuário eletrônico. Por isso o OdontoFlow nunca apaga dado clínico de verdade — só marca como cancelado (`status`), preservando o histórico.

## Inventário

| Tabela | Dado tratado | Finalidade | Base legal | Quem acessa | Retenção | Compartilhamento |
|---|---|---|---|---|---|---|
| `profissionais` | Nome, telefone, e-mail, CRO/UF do dentista | Identificar e autenticar o profissional que usa o app | Execução de contrato | O próprio profissional; colegas do mesmo consultório veem nome/CRO para fins de compartilhamento de paciente | Duração do contrato + prazo fiscal/contratual razoável após encerramento | Supabase (infraestrutura) |
| `consultorios` | Nome, endereço, telefone, e-mail do local de atendimento | Organizar onde o atendimento acontece | Execução de contrato | Profissionais vinculados ao consultório | Igual a `profissionais` | Supabase |
| `profissional_consultorios` | Vínculo profissional × consultório | Controlar quem atende onde | Execução de contrato | Profissionais do consultório | Igual a `profissionais` | Supabase |
| `pacientes` | Nome, telefone, e-mail, CPF, data de nascimento, observações, consentimento para comunicação por WhatsApp (timestamp, quando registrado) | Identificar o paciente e viabilizar o atendimento | Tutela da saúde (uma vez vinculado a atendimento clínico); consentimento apenas para o campo de WhatsApp, se/quando usado além do envio transacional de orçamento | Profissional(is) vinculado(s) ao paciente no consultório | Mínimo 20 anos após o último registro; recomendação de guarda indefinida; consentimento de WhatsApp é revogável a qualquer momento (some do banco, não fica arquivado) | Supabase |
| `paciente_consultorios` | Vínculo paciente × consultório × profissional | Controlar em qual consultório/com qual profissional o paciente é atendido | Tutela da saúde | Profissionais vinculados | Igual a `pacientes` | Supabase |
| `anamneses` | Queixa principal, alergias, medicamentos, histórico médico, condições de saúde (diabetes, hipertensão, cardiopatia, gestação) | Segurança clínica do atendimento | Tutela da saúde | Profissional(is) vinculado(s) ao paciente | Igual a `pacientes` | Supabase |
| `procedimentos` / `regras_preco_procedimento` | Nome, categoria e regras de preço dos procedimentos oferecidos | Montar planos de tratamento e orçamentos | Execução de contrato / legítimo interesse | Profissionais do consultório | Igual a `profissionais` (não é dado de paciente) | Supabase |
| `planos_tratamento` / `itens_plano_tratamento` | Procedimentos planejados/realizados por dente e face, valores, status, datas de execução | Planejar e acompanhar o tratamento odontológico | Tutela da saúde | Profissional(is) vinculado(s) ao paciente | Igual a `pacientes` | Supabase |
| `envios_plano_tratamento` | Registro de que um orçamento foi gerado em PDF ou aberto no WhatsApp (canal, data, quantidade/valor, telefone quando WhatsApp) | Permitir ao dentista consultar o que já foi enviado ao paciente | Legítimo interesse (controle interno do consultório) | Profissional(is) vinculado(s) ao paciente | Igual a `pacientes` | Supabase; o conteúdo da mensagem de WhatsApp em si trafega pelo WhatsApp/Meta, fora do OdontoFlow — o app só abre o link `wa.me`, não envia a mensagem pela API oficial |
| `agendamentos` | Data/hora, tipo de consulta, observações, confirmação por WhatsApp | Controlar consultas e retornos | Execução de contrato / tutela da saúde | Profissional dono do agendamento (colegas veem, não editam) | Igual a `pacientes` | Supabase |

## Dados que NÃO são tratados hoje

Para deixar claro o que está fora do escopo atual (evita alarme falso em auditoria): o OdontoFlow não processa pagamento (não há gateway de cobrança integrado), não envia mensagens de WhatsApp pela API oficial (só abre o link manual `wa.me`), não usa dado de paciente para treinar modelo de IA, não compartilha dado de paciente entre consultórios diferentes, e não vende ou compartilha dado com terceiros para fins comerciais.

## Quando revisar este documento

Sempre que uma tabela nova for criada ou um campo novo passar a guardar dado pessoal — mesmo mudança pequena, como a introdução de `data_execucao` ou `registrado_como_historico` em `itens_plano_tratamento` neste ano, deve gerar uma linha/nota aqui. Trate como parte do mesmo hábito já existente de manter `docs/manual_tabelas.md` atualizado a cada migration.
