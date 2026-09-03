# Modelo de Aviso de Privacidade — OdontoFlow

Última atualização: 2026-09-03

## Para quem é este documento

Este é um **modelo** que cada dentista/clínica que usa o OdontoFlow deve preencher com seus próprios dados e apresentar aos SEUS pacientes (impresso na recepção, enviado por e-mail, ou publicado num link). O OdontoFlow é o software (operador); quem atende o paciente — você — é o responsável legal pelos dados dele (controlador) perante a LGPD.

Os campos entre colchetes `[ASSIM]` precisam ser preenchidos por cada consultório antes de usar o documento. A seção final ("O OdontoFlow como operador") já vem preenchida e não deve ser alterada pelo consultório — ela descreve o papel do software, não o do consultório.

---

## AVISO DE PRIVACIDADE — [NOME DA CLÍNICA/CONSULTÓRIO]

### 1. Quem trata seus dados

**[NOME DA CLÍNICA/CONSULTÓRIO]**, CNPJ/CPF **[NÚMERO]**, localizada em **[ENDEREÇO]**, é a responsável (controladora) pelos dados pessoais tratados neste atendimento, nos termos da Lei Geral de Proteção de Dados (LGPD, Lei 13.709/2018).

**Encarregado de Proteção de Dados (DPO):** [NOME DO ENCARREGADO — pode ser o próprio dentista]
Contato: [E-MAIL OU TELEFONE DO ENCARREGADO]

### 2. Quais dados coletamos

- Dados de identificação e contato: nome, telefone, e-mail, CPF, data de nascimento.
- Dados de saúde (dado sensível, conforme Art. 5º, II da LGPD): queixas, alergias, medicamentos em uso, condições de saúde relevantes (diabetes, hipertensão, cardiopatia, gestação), histórico e plano de tratamento odontológico, procedimentos realizados por dente/face, evolução clínica.
- Dados de agendamento: datas e horários de consulta, tipo de atendimento.
- Registro de comunicações: se enviamos um orçamento em PDF ou por WhatsApp, guardamos o registro de que isso aconteceu (não o conteúdo da conversa de WhatsApp em si).

### 3. Por que tratamos esses dados

- **Cuidado com sua saúde bucal**: diagnóstico, planejamento e execução de tratamento odontológico. Base legal: tutela da saúde, exercida por profissional de saúde (LGPD, Art. 11, II, "h") — **para essa finalidade, a lei não exige seu consentimento**, mas exige que você seja informado, o que este documento faz.
- **Viabilizar o atendimento**: agendar consultas, retornos, cobrar por serviços prestados. Base legal: execução de contrato/relação com o paciente (Art. 7º, V).
- **Comunicação sobre seu tratamento** (ex.: enviar um orçamento por WhatsApp): legítimo interesse do consultório em manter você informado (Art. 7º, IX). Se um dia usarmos seu contato para comunicação que vá além do seu próprio atendimento (ex.: divulgação/marketing), pediremos seu consentimento específico antes.

### 4. Por quanto tempo guardamos

Prontuário odontológico (mesmo digital) tem prazo mínimo de guarda de **20 anos a partir do último registro**, conforme Resolução CFO-SEC-91/2009 e Lei 13.787/18 — por isso, mesmo que você peça a exclusão de um dado clínico, ele pode precisar ser mantido (ou apenas marcado como cancelado, sem uso ativo) para cumprir essa obrigação legal. Dados puramente administrativos (ex.: só um cadastro sem atendimento) podem ser removidos mais cedo, a seu pedido.

### 5. Com quem compartilhamos

Seus dados ficam armazenados na infraestrutura do **OdontoFlow** (o sistema que usamos para gerenciar o consultório), que atua como operador em nosso nome — ver seção 8 abaixo. Não vendemos nem compartilhamos seus dados com terceiros para fins comerciais. Não usamos gateway de pagamento integrado ao sistema.

### 6. Seus direitos

Você pode, a qualquer momento, solicitar diretamente a nós (contato acima):
- Confirmação de que tratamos seus dados, e acesso a eles.
- Correção de dado incompleto, inexato ou desatualizado.
- Anonimização, bloqueio ou eliminação de dado desnecessário, excessivo ou tratado em desacordo com a lei.
- Portabilidade dos seus dados a outro fornecedor, mediante requisição expressa.
- Informação sobre com quem compartilhamos seus dados.
- Revogação de consentimento, quando o tratamento depender dele.

Responderemos em prazo razoável, observando que alguns dados clínicos precisam ser mantidos por obrigação legal (ver seção 4) mesmo após um pedido de exclusão.

### 7. Segurança

Seus dados ficam em um banco de dados com controle de acesso por perfil (só profissionais autorizados e vinculados a você veem seus dados), conexão criptografada, e nunca são apagados de forma que perca o histórico de auditoria exigido para prontuário de saúde.

---

### 8. O OdontoFlow como operador (não editar esta seção)

O **OdontoFlow** é o software usado por este consultório para registrar e organizar o atendimento. Nessa relação, o OdontoFlow atua como **operador** (processa dados em nome do consultório, que é o controlador) — não como dono dos dados do paciente.

- **Infraestrutura**: os dados são armazenados via Supabase, com servidores na região `sa-east-1` (São Paulo, Brasil) — o dado não é transferido para fora do Brasil/América do Sul.
- **Segurança técnica**: controle de acesso por linha (RLS) isolando cada consultório e cada vínculo profissional-paciente; sem exclusão real de dado clínico (apenas cancelamento), preservando o histórico exigido.
- **Acesso pelo operador**: a equipe técnica do OdontoFlow tem acesso administrativo à infraestrutura para manutenção e suporte, mas não usa dado de paciente para finalidade própria do OdontoFlow (marketing, treinamento de modelo, revenda).
- **Contato do encarregado/suporte do OdontoFlow** (para questões sobre o papel do software como operador, não para pedidos de titular de dados de um consultório específico, que devem ir direto ao consultório): Rodrigo Araújo — rodrigoaraujo.ufrj@gmail.com. *Contato provisório desta fase do produto — pode e deve ser substituído por um canal dedicado (e-mail comercial, formulário de suporte) assim que existir.*
- **Suboperadores**: Supabase (banco de dados e autenticação).

