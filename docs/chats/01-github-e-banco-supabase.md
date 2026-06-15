# OdontoFlow - GitHub E Banco Supabase

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - GitHub e Banco Supabase`.

## Objetivo Deste Chat

Centralizar assuntos de:

- GitHub;
- deploy no GitHub Pages;
- Supabase;
- migrations;
- RLS;
- estrutura das tabelas;
- variaveis de ambiente e acessos nao secretos.

## Repositorio

- GitHub: `rodrigoaraujoufrj-bit/odontoficha`
- Remote SSH local: `git@github-personal:rodrigoaraujoufrj-bit/odontoficha.git`
- Branch principal: `main`
- GitHub Pages: `https://rodrigoaraujoufrj-bit.github.io/odontoficha/`

## Supabase

- Project URL: `https://wnpezdxwrdesrbqvtuwu.supabase.co`
- Projeto criado com nome: `OdontoFlow`
- Data API habilitada.
- RLS automatico habilitado.

## Seguranca De Acesso

Pode estar documentado no repo:

- Project URL.
- Nome do projeto.
- Nome das tabelas.
- Nome das variaveis publicas.
- Migrations SQL.
- Regras de RLS.

Nao colocar no repo:

- senha do banco;
- `service_role`;
- connection string;
- JWT secret;
- token pessoal do GitHub;
- senha de usuario teste;
- qualquer chave secreta.

Observacao: publishable key e chave publica de front-end, mas mesmo assim preferir documentar o nome da variavel e onde pegar no painel do Supabase. Se ja estiver no `app.html`, tratar como publica e nao confundir com segredo.

## Arquivos Importantes

- `docs/supabase_setup.md`
- `docs/modelo_dados.md`
- `docs/manual_tabelas.md`
- `docs/regras_negocio.md`
- `supabase/migrations/20260613103000_mvp_cadastros_rls.sql`
- `supabase/migrations/20260613115500_corrigir_insert_consultorios_rls.sql`
- `supabase/migrations/20260613120500_relaxar_policy_insert_consultorios.sql`
- `supabase/migrations/20260613141500_restringir_privilegios_authenticated.sql`

## Tabelas Atuais

- `profissionais`
- `consultorios`
- `profissional_consultorios`
- `pacientes`
- `paciente_consultorios`
- `anamneses`

## Proximas Tabelas Provaveis

Ainda nao criar sem discutir regra de negocio:

- `procedimentos`
- `tratamentos`
- `tratamento_itens`
- `orcamentos`
- `orcamento_itens`
- `evolucoes`
- `documentos_gerados`

## Regra Basica

O front-end deve usar apenas chave publica/publishable. Qualquer operacao sensivel deve ser protegida por RLS.

No MVP, evitar `DELETE`. Preferir:

- `ativo`;
- `arquivado_em`;
- historico.

## Checklist Para Mudancas De Banco

Antes de criar migration:

- confirmar nome da tabela em `pt_br`;
- confirmar relacionamento;
- confirmar se precisa de historico;
- confirmar RLS;
- confirmar grants;
- confirmar se o front-end precisa ler/inserir/atualizar;
- atualizar `docs/modelo_dados.md` e `docs/manual_tabelas.md`.
