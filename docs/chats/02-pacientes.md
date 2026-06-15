# OdontoFlow - Pacientes

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - Pacientes`.

## Objetivo Deste Chat

Cuidar da experiencia de:

- cadastro de paciente;
- busca de paciente;
- ficha resumida;
- vinculo com profissional e consultorio;
- edicao/arquivamento;
- acesso rapido para atendimento.

## Estado Atual

O MVP ja possui:

- cadastro de paciente em `Meu consultorio > Pacientes > Novo paciente`;
- campos basicos: nome, telefone, e-mail, CPF, data de nascimento, observacoes;
- anamnese inicial opcional no cadastro;
- paciente vinculado ao profissional e ao consultorio atual;
- aba `Pacientes` para buscar paciente e abrir ficha;
- ficha com telefone, e-mail, CPF, observacoes, anamnese e tratamento em andamento.

Arquivo principal:

- `app.html`

Tabelas relacionadas:

- `pacientes`
- `paciente_consultorios`
- `profissionais`
- `consultorios`
- `anamneses`

## Regras Ja Decididas

- Paciente e dado clinico sensivel.
- Paciente deve sempre estar ligado a um profissional.
- Paciente pode estar ligado a um consultorio.
- Se cadastrar no consultorio errado, o ideal e corrigir o vinculo, nao duplicar paciente.
- CPF e opcional no MVP, mas se informado deve ter 11 digitos.
- Telefone deve ter DDD e 11 digitos quando informado.
- E-mail deve conter `@` quando informado.
- Telefone ou e-mail devem ser obrigatorios para contato.

## Fluxo Desejado

1. Dentista abre `Pacientes`.
2. Busca por nome, telefone, e-mail ou CPF.
3. Abre a ficha.
4. A ficha mostra dados essenciais e status clinico.
5. A partir da ficha, o dentista inicia `Consulta`.

## Pontos A Melhorar

- Editar contato do paciente.
- Arquivar paciente.
- Trocar consultorio vinculado.
- Melhorar busca com destaque de resultado.
- Criar tela/modal de dados completos do paciente.
- Mostrar historico resumido de atendimentos.

## Cuidado De Produto

`Pacientes` nao deve virar uma tela administrativa pesada. O dentista chega ali porque vai atender alguem. Cadastro novo e manutencao devem ficar em `Meu consultorio`.
