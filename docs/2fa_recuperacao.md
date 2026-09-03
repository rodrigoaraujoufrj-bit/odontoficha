# OdontoFlow — Recuperação de acesso à verificação em duas etapas (2FA)

Última atualização: 2026-09-03

## O que é a 2FA no OdontoFlow

Cada profissional pode, **opcionalmente**, ativar a verificação em duas etapas (2FA) no card "Segurança da conta", na página inicial do dashboard. Uma vez ativada, cada novo login exige, além da senha, um código de 6 dígitos gerado por um aplicativo autenticador (Google Authenticator, Authy, etc.), usando o padrão TOTP.

A 2FA é gerenciada inteiramente pelo Supabase Auth (API `auth.mfa`) — não existe tabela própria no schema `public` do OdontoFlow para fatores ou desafios de 2FA; o Supabase guarda isso no seu próprio schema interno `auth`.

Um profissional que nunca ativa a 2FA continua com exatamente o mesmo fluxo de login de sempre, sem nenhuma tela ou fricção adicional.

## Esta versão NÃO tem códigos de backup

Diferente de muitos apps com 2FA, **esta primeira versão do OdontoFlow não gera códigos de backup/recuperação** no momento da ativação. Isso é uma limitação real e conhecida, não um bug: adicionar códigos de backup exige desenho próprio (geração, armazenamento seguro, UI de exibição única, reemissão) que ficou fora do escopo deste round.

Na prática, isso significa: **se o profissional perder o acesso ao aplicativo autenticador** (trocou de celular sem migrar o app, desinstalou o app, perdeu o aparelho), **ele fica sem conseguir logar sozinho** — não há nenhum fluxo de autoatendimento para recuperar o acesso.

## Como funciona a recuperação (processo manual, feito pelo operador)

Como não há recuperação por autoatendimento, o desbloqueio depende de uma ação manual do operador do OdontoFlow (hoje, Rodrigo Araújo — rodrigoaraujo.ufrj@gmail.com, mesmo contato do Aviso de Privacidade em `docs/lgpd_aviso_privacidade_modelo.md`):

1. **O profissional entra em contato** com o operador relatando que perdeu acesso ao aplicativo autenticador.
2. **O operador verifica a identidade do profissional fora de banda** — ou seja, por um canal diferente do próprio OdontoFlow, já que o profissional não consegue logar. Ex.: ligação telefônica para o número já cadastrado no consultório, videochamada, confirmação de dados que só o profissional legítimo saberia. O critério de "verificação razoável" fica a critério do operador; não há uma checklist rígida definida ainda.
3. **Depois de confirmar a identidade, o operador remove o fator de 2FA travado**, usando um dos dois caminhos abaixo (qualquer um funciona; o efeito é o mesmo):
   - **Painel do Supabase**: Dashboard do projeto → *Authentication* → *Users* → localizar o usuário pelo e-mail → gerenciar/remover o fator MFA listado para aquele usuário.
   - **API administrativa do Supabase** (para quem preferir/precisar scriptar): `supabase.auth.admin.mfa.deleteFactor({ id: "<factor_id>" })`, usando a service role key (nunca a chave pública do app) a partir de um ambiente de confiança do operador — nunca embutido no `app.html`.
4. **O profissional faz login normalmente com e-mail e senha.** Como o fator de 2FA foi removido, o OdontoFlow não pede mais o código — o login volta a ser o de sempre, sem nenhum resquício da 2FA anterior.
5. Se o profissional quiser voltar a usar 2FA, ele ativa de novo do zero (novo QR code, novo fator) no card "Segurança da conta".

Este processo é deliberadamente manual — não existe (nem deveria existir, sem desenho próprio) um botão de "esqueci minha 2FA" dentro do app: qualquer atalho de autoatendimento aqui viraria uma forma de contornar a própria proteção que a 2FA existe para dar, então a verificação de identidade fora de banda é o ponto central da segurança deste processo, não um detalhe.

## Quando isso deve virar um round próprio

Se o volume de pedidos de recuperação virar um incômodo recorrente para o operador, ou se o OdontoFlow ganhar mais de um operador respondendo por esses pedidos, vale desenhar um round dedicado a códigos de backup (geração de um conjunto de códigos de uso único no momento da ativação, exibidos uma vez, com opção de gerar um novo conjunto) — reduzindo a dependência deste processo manual sem enfraquecer a proteção que a 2FA oferece.
