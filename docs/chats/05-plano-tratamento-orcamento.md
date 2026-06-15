# OdontoFlow - Plano De Tratamento E Orcamento

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - Plano de Tratamento e Orcamento`.

## Objetivo Deste Chat

Cuidar do fluxo:

- novo tratamento;
- procedimentos por dente/face;
- plano de tratamento;
- orcamento;
- edicao/exclusao de itens;
- envio futuro por PDF/WhatsApp.

## Estado Atual

No `app.html`, o fluxo ja permite:

1. Abrir paciente.
2. Clicar em `Consulta`.
3. Clicar em `Novo tratamento`.
4. Selecionar dente no odontograma.
5. Selecionar uma ou mais faces.
6. Escolher procedimento sugerido.
7. Informar valor estimado.
8. Adicionar ao plano.
9. Ver tabela `Plano de tratamento` abaixo do odontograma.
10. Editar item.
11. Excluir item.
12. Ver resumo financeiro lateral.

Tudo isso ainda e local no front-end. Ainda nao persiste no Supabase.

## Regras Ja Decididas

- Botao deve ser `Adicionar ao plano`, nao apenas `Adicionar ao orcamento`.
- Orcamento deriva do plano.
- Plano de tratamento deve aparecer abaixo do odontograma.
- Cada item precisa ter editar/excluir.
- Se o dentista errar, precisa corrigir rapido.
- O plano deve ser visual o suficiente para virar PDF/WhatsApp depois.
- A tabela de procedimentos deve ser editavel em `Meu consultorio`.
- O dentista nao deve depender de tabela impressa de valores.
- Ao selecionar um procedimento, o preco sugerido deve aparecer automaticamente.
- Procedimentos podem exigir dente, exigir face ou nao depender de dente.
- Se nenhum dente estiver selecionado, o atendimento deve mostrar apenas procedimentos gerais, como avaliacao, profilaxia e clareamento.
- Se um dente estiver selecionado, o atendimento deve mostrar procedimentos aplicaveis a dente/face.
- Numero do dente e face ajudam o filtro e devem permanecer na logica do plano.
- Ao abrir o paciente para atendimento, a ficha deve ficar compacta: nome, telefone, idade e botao `+` para detalhes.
- `Continuar tratamento`, `Nova consulta` e `Historico` devem ficar claros, com poucos botoes e contexto clinico.

## Dados De Um Item

Um item de tratamento deve ter no minimo:

- paciente;
- profissional;
- consultorio;
- dente;
- faces;
- procedimento;
- valor;
- observacao;
- status;
- ordem;
- criado_em;
- atualizado_em.

Status provaveis:

- `planejado`
- `aceito`
- `em_andamento`
- `concluido`
- `cancelado`
- `urgente`

## Proximas Tabelas Provaveis

Ainda precisam ser desenhadas:

- `procedimentos`
- `tratamentos`
- `tratamento_itens`
- `orcamentos`
- `orcamento_itens`

## Proximas Melhorias

- Persistir plano no Supabase.
- Criar tabela de procedimentos por consultorio.
- Permitir status do item.
- Gerar PDF.
- Preparar texto para WhatsApp Web.
- Criar opcoes de pagamento.
- Mostrar historico de planos anteriores.

## Cuidado De Produto

O dentista deve montar o plano sem pensar em "sistema". O fluxo ideal e:

`dente > face > procedimento > valor > adicionar`

O paciente deve receber uma explicacao visual, nao apenas uma lista fria de valores.
