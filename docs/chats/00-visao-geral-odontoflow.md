# OdontoFlow - Visao Geral Do Projeto

Use este arquivo como contexto inicial quando abrir um chat novo sobre o OdontoFlow.

## Identidade Do Produto

OdontoFlow e um produto em construcao para ajudar dentistas a conduzir atendimento clinico com menos friccao.

A ideia central nao e competir como ERP odontologico completo. O diferencial deve ser:

- atendimento visual;
- memoria clinica do paciente;
- odontograma como retrato da boca;
- plano de tratamento claro;
- orcamento facil de explicar e enviar ao paciente.

## Repositorio

- GitHub: `rodrigoaraujoufrj-bit/odontoficha`
- Remote local: `git@github-personal:rodrigoaraujoufrj-bit/odontoficha.git`
- GitHub Pages: `https://rodrigoaraujoufrj-bit.github.io/odontoficha/`
- App MVP: `https://rodrigoaraujoufrj-bit.github.io/odontoficha/app.html`
- Questionario: `https://rodrigoaraujoufrj-bit.github.io/odontoficha/questionario.html`

## Estado Atual

Arquivos principais:

- `index.html`: landing page.
- `questionario.html`: questionario de descoberta com exportacao JSON.
- `app.html`: MVP operacional com login Supabase, primeiro acesso, pacientes, anamnese inicial e inicio do fluxo de tratamento.
- `docs/`: documentacao de regras, modelo de dados e setup.
- `supabase/migrations/`: migrations SQL.

## Modulos Ja Iniciados

- Landing page OdontoFlow.
- Questionario de descoberta para dentistas.
- Primeiro acesso do profissional.
- Cadastro de consultorio.
- Cadastro de paciente.
- Anamnese inicial opcional vinculada ao paciente.
- Busca de paciente.
- Ficha resumida do paciente.
- Consulta / novo tratamento.
- Odontograma SVG clicavel com dentes, faces e quadrantes.
- Plano de tratamento local com editar/excluir.
- Resumo de orcamento local.

## Decisoes Importantes

- Nomes das tabelas devem ficar em `pt_br`.
- RLS e obrigatorio nas tabelas clinicas.
- Nada sensivel deve ficar exposto no front-end.
- Sem custo no MVP: usar GitHub Pages e plano gratuito do Supabase.
- `service_role`, senha do banco e connection string nunca devem ir para o GitHub.
- O OdontoFlow deve ser vendido como fluxo clinico/assistente de atendimento, nao como "IA".
- O odontograma e mais que input: e memoria clinica e material visual para o paciente.

## Como Trabalhar Nos Proximos Chats

Cada novo chat deve focar em uma funcionalidade.

Sugestao:

- `OdontoFlow - GitHub e Banco Supabase`
- `OdontoFlow - Pacientes`
- `OdontoFlow - Anamnese`
- `OdontoFlow - Odontograma`
- `OdontoFlow - Plano de Tratamento e Orcamento`
- `OdontoFlow - PDF e WhatsApp`
- `OdontoFlow - UI e Design`
- `OdontoFlow - Questionario e Pesquisa`

Antes de implementar qualquer mudanca grande, alinhar a regra de negocio e o fluxo esperado.
