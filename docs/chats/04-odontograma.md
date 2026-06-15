# OdontoFlow - Odontograma

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - Odontograma`.

## Objetivo Deste Chat

Cuidar do odontograma como centro visual do atendimento.

O odontograma deve ser:

- ferramenta clinica;
- memoria da boca do paciente;
- base para plano de tratamento;
- material visual para o paciente entender o orcamento.

## Estado Atual

No `app.html`, o fluxo atual e:

`Pacientes > Abrir ficha > Consulta > Novo tratamento`

O odontograma atual:

- e SVG;
- possui dentes clicaveis;
- usa numeracao FDI;
- tem arcada superior e inferior;
- tem quadrantes Q1, Q2, Q3, Q4;
- permite selecionar dente;
- permite selecionar multiplas faces;
- colore faces selecionadas;
- permite deselecionar dente clicando novamente.

## Faces

Faces usadas no MVP:

- `Vestibular`
- `Lingual/Palatina`
- `Mesial`
- `Distal`
- `Oclusal`
- `Raiz`

## Decisoes De Produto

- O odontograma nao e detalhe tecnico; ele e parte da percepcao de cuidado.
- O paciente deve conseguir olhar um resumo visual e entender que existe criterio no plano.
- A visao oclusal/por cima do dente e importante para impacto visual e navegacao.
- O desenho nao precisa ser perfeito de anatomia no MVP, mas precisa parecer clinico e confiavel.

## Pontos A Melhorar

- Refinar desenho das coroas/raizes.
- Criar legenda de cores por status:
  - higido;
  - em tratamento;
  - cariado;
  - ausente;
  - planejado;
  - concluido;
  - urgente.
- Diferenciar dente com historico de dente com procedimento planejado.
- Permitir abrir historico por dente.
- Exibir tratamentos antigos ao clicar no dente.
- Persistir odontograma no Supabase.

## Cuidado Tecnico

O SVG esta em `app.html`. Antes de grandes mudancas, revisar:

- CSS de `.tooth-node`, `.tooth-shape`, `.tooth-face`;
- funcao `renderToothGrid()`;
- estados `selectedTooth` e `selectedFaces`;
- evento de clique em `toothGrid`;
- evento de clique em `faceGrid`.
