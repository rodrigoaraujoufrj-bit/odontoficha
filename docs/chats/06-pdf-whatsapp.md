# OdontoFlow - PDF E WhatsApp

Use este arquivo como primeira mensagem/contexto do chat `OdontoFlow - PDF e WhatsApp`.

## Objetivo Deste Chat

Cuidar da geracao de documentos e comunicacao com paciente:

- resumo do atendimento;
- plano de tratamento;
- orcamento;
- PDF;
- envio orientado pelo WhatsApp Web.

## Ideia Do Produto

Quando o dentista terminar a consulta, ele deve conseguir enviar algo como:

- nome do paciente;
- resumo visual do odontograma;
- dentes e faces envolvidos;
- procedimentos planejados;
- valores;
- total;
- observacoes;
- instrucoes ou proximos passos.

Isso aumenta a percepcao de cuidado e pode melhorar a aceitacao do tratamento.

## Estado Atual

Ainda nao existe PDF real.

No `app.html`, existem botoes desabilitados/previstos:

- `Imprimir orcamento`
- `Enviar por WhatsApp`
- `Enviar resumo`

O plano de tratamento e o resumo financeiro ja existem localmente no front-end.

## Decisoes Ja Tomadas

- WhatsApp nao deve ser "magico" no MVP.
- Pode comecar gerando texto e abrindo WhatsApp Web com mensagem pronta.
- PDF deve ser visual e simples.
- Odontograma deve entrar no PDF/plano quando possivel.

## Possivel MVP

1. Gerar texto do resumo.
2. Gerar link `https://wa.me/55NUMERO?text=...`.
3. Abrir WhatsApp Web em nova aba.
4. Gerar HTML imprimivel como "PDF manual" pelo navegador.

## Cuidado Tecnico

Nao enviar dados sensiveis automaticamente sem acao clara do usuario.

Antes de integrar WhatsApp:

- confirmar telefone do paciente;
- formatar DDD + numero;
- mostrar previa da mensagem;
- usuario clica para enviar/abrir WhatsApp.

## Proximas Melhorias

- Template de PDF com logo OdontoFlow.
- Template com logo do consultorio.
- Exportar odontograma como imagem/SVG no PDF.
- Salvar documento gerado.
- Historico de envios.
