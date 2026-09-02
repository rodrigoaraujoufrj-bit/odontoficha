# OdontoFlow

Organizador de fluxo clínico-operacional para dentistas e equipes: ficha do
paciente, anamnese, odontograma, plano de tratamento e orçamento — pensado
para poucos dentistas por consultório, não para ser um ERP odontológico
completo.

Última atualização: 2026-09-02

## Onde ver o projeto

- **App em produção (GitHub Pages):** https://rodrigoaraujoufrj-bit.github.io/odontoficha/
- **App:** `app.html` — login, cadastro de paciente, atendimento, odontograma, orçamento (integrado ao Supabase).
- **Landing page:** `index.html` — página institucional de validação com dentistas.
- **Questionário de descoberta:** `questionario.html` — pesquisa aplicada a dentistas para priorizar o MVP. Não tem nenhuma ligação com o app nem com dados de pacientes reais.

## Estrutura do repositório

```
app.html                  App funcional (HTML + CSS + JS vanilla, sem build)
index.html                Landing page institucional
questionario.html         Pesquisa de descoberta de produto (dentistas)
assets/                   Logo (SVG) e mockups (assets/mockups/) usados na landing page
supabase/migrations/      Schema do banco e políticas de RLS, em ordem cronológica
docs/                     Regras de negócio, modelo de dados, manual de tabelas, setup do Supabase
docs/chats/               Histórico das decisões de produto, por tema
```

## Stack

HTML, CSS e JavaScript puros (sem framework, sem bundler, sem build). Backend
em [Supabase](https://supabase.com) (Postgres + autenticação + Row Level
Security). Publicado como site estático no GitHub Pages.

## Banco de dados (Supabase)

As migrações em `supabase/migrations/` são a fonte de verdade do schema e das
políticas de segurança (RLS), aplicadas em ordem pelo nome do arquivo
(`AAAAMMDDHHMMSS_descricao.sql`). Nunca editar uma migração já commitada —
uma correção sempre entra como um novo arquivo, mesmo que corrija algo criado
minutos antes. Ver `docs/supabase_setup.md` para como configurar um projeto
Supabase do zero e `docs/modelo_dados.md` para as tabelas e relacionamentos.

## Documentação

| Arquivo | Conteúdo |
|---|---|
| `docs/regras_negocio.md` | Regras e decisões de produto por área (cadastro, agenda, plano de tratamento, acesso e permissões, etc.) |
| `docs/modelo_dados.md` | Tabelas, campos e relacionamentos — implementados e propostos |
| `docs/manual_tabelas.md` | Como cada tabela deve ser preenchida |
| `docs/supabase_setup.md` | Passo a passo para configurar o projeto Supabase |
| `docs/chats/` | Histórico das conversas de design que geraram essas decisões, um arquivo por tema |

Cada documento tem uma linha `Última atualização: AAAA-MM-DD` logo no topo —
atualize essa data sempre que editar o conteúdo.
