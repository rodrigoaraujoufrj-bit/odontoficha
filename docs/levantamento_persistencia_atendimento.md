# OdontoFlow - Levantamento: Persistência do Atendimento (Plano de Tratamento e Histórico)

Última atualização: 2026-09-02

Este levantamento nasceu de um teste de uso real da plataforma (login de teste,
comportamento de dentista real, ver `docs/chats/` se houver registro da sessão).
O teste confirmou um problema estrutural: **o plano de tratamento montado numa
consulta não sobrevive à troca de paciente nem a um recarregamento de página**, e
o botão "Histórico" não mostra nenhum histórico de verdade.

## Resumo executivo

A causa raiz **não é falta de modelagem de dados**. O banco de produção já tem as
tabelas `planos_tratamento` e `itens_plano_tratamento`, migradas com RLS desde
14/06/2026 (`supabase/migrations/20260614213000_procedimentos_precos_planos.sql`),
com todas as políticas de acesso, triggers de `atualizado_em` e um status já bem
definido. **O `app.html` nunca foi atualizado para gravar nelas.** Hoje o "plano de
tratamento" que aparece na tela é só a variável JavaScript `treatmentItems`, um
array em memória: existe enquanto a aba está aberta naquele paciente e desaparece
ao trocar de paciente, recarregar a página ou fechar o navegador.

Isso muda o tamanho do problema: não precisamos desenhar banco novo para o caso
principal, precisamos **conectar o front-end ao schema que já existe**.

## 1. Tabelas que já existem em produção (migradas)

| Tabela | Usada pelo `app.html` hoje? |
|---|---|
| `profissionais` | Sim |
| `consultorios` | Sim |
| `profissional_consultorios` | Sim |
| `pacientes` | Sim |
| `paciente_consultorios` | Sim |
| `anamneses` | Sim |
| `procedimentos` | Sim |
| `regras_preco_procedimento` | Sim |
| **`planos_tratamento`** | **Não — existe, tem RLS pronta, nunca é lida nem gravada** |
| **`itens_plano_tratamento`** | **Não — existe, tem RLS pronta, nunca é lida nem gravada** |

Schema completo dessas duas em `supabase/migrations/20260614213000_procedimentos_precos_planos.sql`
e documentação de preenchimento em `docs/manual_tabelas.md`. Resumo do que já
temos prontos para usar:

- `planos_tratamento`: `paciente_id`, `consultorio_id`, `profissional_id`, `titulo`,
  `status` (`rascunho` / `apresentado` / `aprovado_parcial` / `aprovado` /
  `em_execucao` / `concluido` / `cancelado` / `substituido`), `observacoes`,
  `valor_total_estimado`.
- `itens_plano_tratamento`: `plano_tratamento_id`, `procedimento_id`,
  `regra_preco_procedimento_id`, `numero_dente`, `faces_dente` (array),
  `procedimento_nome`, `regra_preco_nome`, `valor_estimado`, `valor_final`,
  `observacao`, `status` (`planejado` / `aprovado` / `em_andamento` / `realizado`
  / `cancelado` / `urgente`), `ordem`.
- RLS já cobre: leitura/escrita só por quem tem vínculo ativo com o paciente E com
  o consultório; só o profissional dono do plano (`profissional_id`) pode
  inserir/alterar itens — já prevê a regra de "reatribuir plano para si mesmo"
  descrita em `docs/regras_negocio.md` > Regras De Plano De Tratamento.

## 2. O que o `app.html` realmente faz hoje

- `let treatmentItems = [];` — variável global, nunca persistida.
- `resetTreatmentDraft()` zera esse array toda vez que `showPatientSummary()` é
  chamada (ou seja, toda vez que o dentista abre a ficha de outro paciente).
- `addTreatmentItem` (listener) só faz `treatmentItems.push(...)` / atualiza o
  índice em memória.
- Nenhum `supabase.from("planos_tratamento")` ou `supabase.from("itens_plano_tratamento")`
  existe no arquivo — confirmado por busca no código inteiro.
- O botão "Continuar tratamento" só troca dois textos da tela (`kicker` e título);
  ele reabre o mesmo painel de "Nova consulta", com o mesmo array em memória — não
  busca nada do paciente.
- O botão "Histórico" (e a opção "Histórico" dentro de "O que vai acontecer
  agora?") só expande/rola até o painel de detalhes do paciente
  (anamnese/tratamento em andamento/compartilhado) — não existe nenhuma consulta
  a dados de atendimentos passados.
- "Gerar orçamento" e a prévia de WhatsApp/PDF são calculados na hora, a partir do
  mesmo array — não ficam gravados em lugar nenhum depois de fechados.

## 3. Lacunas confirmadas no teste de uso real

1. **Plano de tratamento não persiste** — confirmado ao vivo: montei plano com 2
   itens para um paciente, troquei para outro paciente, voltei e cliquei
   "Continuar tratamento" → 0 itens, mensagem "Nenhum procedimento adicionado
   ainda.". Reproduzível sempre.
2. **"Histórico" não existe como funcionalidade** — testado num paciente sem
   nenhum atendimento anterior; o botão abre o mesmo painel genérico de detalhes,
   não uma lista de consultas/planos passados.
3. **Sem busca/filtro de procedimento por categoria/especialidade** — confirmado
   com 9 procedimentos cadastrados em 8 categorias diferentes; a tabela é uma
   lista corrida, sem campo de busca nem filtro.
4. **Feedback de "paciente cadastrado" fica invisível** — bug confirmado via
   inspeção do DOM: a mensagem de sucesso é criada com a classe certa, mas o
   container que a contém (`#clinicPatientFormSection`) já foi escondido
   (`display:none`) no mesmo instante, então ninguém vê a confirmação.
5. **Anamnese não pode ser editada depois do cadastro inicial** — o botão
   "Editar em Meu consultório" no card de anamnese está desabilitado
   (`disabled`) no código; hoje só dá pra preencher anamnese no momento do
   cadastro do paciente.
6. **Orçamento não vira registro** — mesmo problema de raiz do item 1: não existe
   tabela `orcamentos` migrada ainda (está em `docs/modelo_dados.md` como
   proposta), então mesmo depois de consertar o plano de tratamento, "gerar
   orçamento" continua sendo só uma tela calculada, sem histórico de propostas
   enviadas/aprovadas/recusadas.
7. **Lista de material / estoque — isto não é uma lacuna acidental.** Já está
   decidido em `docs/regras_negocio.md` > Regras De Estoque: *"Estoque não parece
   prioridade máxima... Controle completo de estoque deve ficar para fase
   posterior."* As tabelas (`estoques`, `itens_estoque`, `movimentacoes_estoque`)
   estão listadas em `docs/modelo_dados.md` como "Tabelas Futuras", de propósito.

## 4. O que ainda não existe em lugar nenhum (nem banco, nem app)

- `orcamentos` — necessário para o orçamento ter status e histórico.
- `evolucoes_clinicas` — necessário para um histórico *por atendimento* (o que
  foi feito, o que ficou pendente, próximo passo), separado do plano.
- `estoques` / `itens_estoque` / `movimentacoes_estoque` — fora de escopo por
  decisão já registrada (ver item 7 acima).
- `agendamentos` — mencionado no modelo de dados, sem relação direta com este
  levantamento.

## 5. Divergências que encontrei de passagem (vale corrigir na documentação)

- `docs/regras_negocio.md` > Regras De Plano De Tratamento lista o "status mínimo
  do item" com 5 valores (`planejado`, `aprovado`, `em_andamento`, `realizado`,
  `cancelado`) — falta `urgente`, que já está na constraint do banco
  (`itens_plano_status_valido`) e é exatamente o vocabulário que usamos esta
  semana no seletor de status do procedimento.
- `docs/modelo_dados.md` descreve uma tabela `fichas_clinicas` que **nunca foi
  migrada**; o que existe de fato e cobre esse papel é `anamneses` (com campos
  diferentes: `queixa_principal`, `historico_medico`, `doencas_sistemicas`,
  `gestante`, `sangramento_excessivo`, `possui_diabetes`, `possui_hipertensao`,
  `possui_cardiopatia`, `observacoes_clinicas`). Não há uso real de
  `fichas_clinicas` para eu levar em conta.

## 6. Proposta de ordem de execução (aguardando sua decisão — nada implementado ainda)

**Fase A — persistência básica do plano de tratamento** (reaproveita 100% do
schema já migrado, sem nenhuma migration nova):
- Ao abrir "Nova consulta" ou "Continuar tratamento", buscar/criar um
  `planos_tratamento` (status `rascunho`) daquele paciente.
- "Adicionar ao plano" grava em `itens_plano_tratamento`, não só no array.
- Ao abrir a ficha do paciente, carregar os itens do plano em rascunho mais
  recente (se existir) para popular a tela — isso sozinho já resolve o bug nº 1.
- "Continuar tratamento" passa a de fato reabrir o plano existente em vez de uma
  tela vazia.

**Fase B — "Histórico" de verdade, ainda sem tabela nova**:
- Lista dos `planos_tratamento` do paciente (independente do status), com data e
  itens de cada um — dá pra fazer só com o que já existe no banco.

**Fase C — correções pequenas e independentes** (podem entrar a qualquer momento,
não dependem da Fase A/B):
- Corrigir o feedback escondido no cadastro de paciente (achado nº 4).
- Busca/filtro por categoria no catálogo de procedimentos (achado nº 3).
- Habilitar edição de anamnese de paciente já cadastrado (achado nº 5).

**Fase D — fora do MVP por decisão já tomada, não mexer agora**:
- Orçamento como registro (`orcamentos`).
- Estoque/material.

## 7. Perguntas para decidir antes de eu implementar

1. **Gatilho de "novo plano" vs. "continuar o mesmo":** quando o dentista clica
   "Nova consulta" num paciente que já tem um plano em rascunho aberto, o sistema
   deve criar um **segundo** plano (a regra de negócio já permite "um paciente
   pode ter vários planos") ou continuar editando o mesmo rascunho? Isso muda a
   lógica de "Nova consulta" vs. "Continuar tratamento" precisar ser
   comportamentos realmente diferentes.
2. **Vocabulário de status na tela:** hoje o seletor mostra 3 opções (Planejado /
   Em tratamento / Urgente); o banco já suporta 6 (`planejado`, `aprovado`,
   `em_andamento`, `realizado`, `cancelado`, `urgente`). Ampliamos a tela para os
   6 valores reais do banco, ou mantemos as 3 opções simplificadas na interface e
   fazemos o mapeamento por baixo dos panos (ex.: "Em tratamento" grava como
   `em_andamento`)?
3. **Reatribuição de plano entre colegas:** a regra já está escrita
   (`docs/regras_negocio.md`: um profissional pode assumir um plano criado por um
   colega do mesmo consultório, só pra si mesmo). Confirma que isso deve valer já
   nesta primeira fase, ou fica pra depois?
