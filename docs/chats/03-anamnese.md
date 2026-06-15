# OdontoFlow - Anamnese

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - Anamnese`.

## Objetivo Deste Chat

Cuidar da anamnese como parte da ficha do paciente.

Anamnese nao deve ser uma aba solta. Ela pertence ao paciente.

## Estado Atual

O MVP possui:

- anamnese inicial opcional durante cadastro de novo paciente;
- leitura da anamnese na ficha do paciente;
- tabela `anamneses` no Supabase;
- relacao com `paciente_id` e `profissional_id`.

## Campos Atuais

- `queixa_principal`
- `historico_medico`
- `alergias`
- `medicamentos_uso_continuo`
- `possui_diabetes`
- `possui_hipertensao`
- `possui_cardiopatia`
- `gestante`
- `sangramento_excessivo`
- `preenchida_em`
- `atualizado_em`

## Regras Ja Decididas

- Preencher anamnese e opcional no MVP.
- Se preencher, aparece na ficha do paciente.
- Se nao preencher, ficha deve indicar "sem anamnese cadastrada".
- Edicao futura deve ficar em `Meu consultorio > Pacientes > Anamnese` ou dentro da ficha do paciente em contexto claro.
- Nao criar aba global de anamnese.

## Proximas Melhorias

- Criar edicao de anamnese existente.
- Criar versoes/historico de anamnese.
- Separar perguntas por grupos:
  - queixa principal;
  - condicoes sistemicas;
  - medicamentos;
  - alergias;
  - gestacao;
  - risco de sangramento;
  - observacoes do profissional.
- Criar resumo visual de alertas na ficha.

## Cuidado De Produto

Anamnese deve ajudar o dentista rapidamente antes do procedimento. Nao deve virar um formulario longo demais no primeiro atendimento, a menos que o dentista queira preencher.
