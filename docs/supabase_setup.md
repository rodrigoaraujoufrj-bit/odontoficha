# OdontoFlow - Setup Supabase

Status: rascunho operacional

Projeto Supabase:

```text
https://wnpezdxwrdesrbqvtuwu.supabase.co
```

## Chaves

Pode ficar no front-end:

- Project URL
- Publishable key

Nao colocar no front-end, GitHub Pages ou commit:

- database password
- service_role key
- connection string
- JWT secret

## Configuracao Inicial

No projeto Supabase:

- Data API pode ficar habilitada.
- RLS deve ficar habilitado em todas as tabelas clinicas.
- Tabelas expostas pela Data API ainda dependem de RLS e policies para proteger linhas.
- O usuario anonimo nao deve acessar dados clinicos.

## Como Aplicar A Migration

1. Abrir o projeto no Supabase.
2. Ir em `SQL Editor`.
3. Criar uma nova query.
4. Colar o conteudo de:

```text
supabase/migrations/20260613103000_mvp_cadastros_rls.sql
```

5. Executar.
6. Conferir no Table Editor se as tabelas foram criadas.
7. Conferir em Authentication se o login por e-mail esta habilitado antes de testar o front.

## Tabelas Criadas Na Primeira Versao

- `profissionais`
- `consultorios`
- `profissional_consultorios`
- `pacientes`
- `paciente_consultorios`
- `anamneses`

## Regra De Seguranca Inicial

O modelo assume que:

- cada usuario autenticado cria um registro em `profissionais`;
- dados sensiveis ficam ligados a esse profissional;
- consultorios sao acessados pelo criador ou por vinculo ativo;
- pacientes sao acessados pelo profissional que criou ou pelo vinculo em `paciente_consultorios`;
- anamnese fica ligada ao paciente e ao profissional.

Usuario sem login nao deve ler nem gravar dados clinicos.

A migration tambem cria o schema privado `odf_privado` com funcoes auxiliares de RLS. Essas funcoes nao sao parte do produto nem devem ser usadas pelo front-end; elas existem para o banco responder com seguranca se o usuario logado pode acessar determinado profissional, consultorio ou paciente.

As tabelas clinicas devem liberar para `authenticated` apenas:

- `SELECT`
- `INSERT`
- `UPDATE`

Nao liberar `DELETE` nem `TRUNCATE` no MVP. Remocoes devem ser tratadas por arquivamento ou campo `ativo`.

## Validacoes No Banco

O banco ja bloqueia:

- telefone fora do padrao de 11 digitos quando informado;
- CPF fora do padrao de 11 digitos quando informado;
- e-mail sem `@`, com espaco ou fora de minusculo;
- UF diferente de 2 letras maiusculas.

O front-end ainda deve limpar mascara antes de salvar:

```text
(21) 99999-9999 -> 21999999999
123.456.789-09 -> 12345678909
```

## Proximo Teste Obrigatorio

Antes de usar dados reais:

- criar um usuario de teste;
- criar profissional, consultorio, paciente e anamnese;
- confirmar que usuario deslogado nao ve dados;
- confirmar que outro usuario de teste nao ve os dados do primeiro.
