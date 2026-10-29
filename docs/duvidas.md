# Dúvidas de modelagem

[README](../README.md) · [Projeto lógico](../projeto_logico.md) · [Histórico de alterações](historico.md) · [Checklist do projeto](checklist.md)

## 2026-10-29 — Cardinalidade de `Possui` entre `Condição` e `Prontuário Paciente`

**Situação: pendente de decisão.**

O [diagrama conceitual atual](../diagrama_atual.drawio) apresenta `POSSUI` como um relacionamento **1:1** entre `CONDIÇÃO` e `PRONTUÁRIO PACIENTE`. Isso limita cada prontuário a uma condição e cada condição a um prontuário.

No [projeto lógico](../projeto_logico.md), `Possui` usa a chave primária composta `(ID_Condição, IDP)`. Ela impede repetir o mesmo par, mas permite repetir cada componente em pares diferentes. Dessa forma, permite vínculos **N:M**.

### Exemplo

| `IDP` | `ID_Condição` | Significado |
|---|---|---|
| 123 | 10 | O prontuário 123 está associado à condição 10. |
| 123 | 20 | O mesmo prontuário também está associado à condição 20. |
| 456 | 10 | Outro prontuário também está associado à condição 10. |

Os três pares são diferentes, então a chave composta atual aceita as três linhas. O 1:1 do diagrama não permite esses vínculos simultaneamente.

### Perguntas

1. Um prontuário pode estar associado a várias condições?
2. Uma condição cadastrada pode ser compartilhada por vários prontuários, ou representa uma ocorrência específica de um paciente?

### Alternativas

| Vários vínculos por prontuário? | Vários vínculos por condição? | Cardinalidade correspondente |
|---|---|---|
| Não | Não | 1:1 |
| Sim | Sim | N:M |
| Não | Sim | Uma condição para vários prontuários; no máximo uma condição por prontuário. |
| Sim | Não | Um prontuário para várias condições; no máximo um prontuário por condição. |

- Se a decisão for manter **1:1**, será necessário ajustar as chaves e unicidades no lógico. Uma alternativa é usar `IDP` como PK e tornar `ID_Condição` único e obrigatório. Também será necessário conferir a referência de `Administrado` e a participação total indicada no diagrama.
- Se a decisão for **N:M**, a PK composta atual expressa essa cardinalidade máxima; será necessário corrigir o conceitual e conferir as participações mínimas.
- Se apenas um dos lados puder ter vários vínculos, será necessário alinhar ambos os modelos ao 1:N escolhido.

Nenhuma dessas alternativas foi aplicada, estou esperando o parecer de vocês :)

## 2026-10-29 — Significado de `Tipo` em `Condição`

**Situação: pendente de decisão.**

No [projeto lógico](../projeto_logico.md), `Condição` possui os atributos `ID_Condição`, `Nome`, `Descrição` e `Tipo`. No [diagrama conceitual](../diagrama_atual.drawio), aparecem apenas `ID_Condição`, `Nome` e `Descrição`.

### Perguntas

1. O que o atributo `Tipo` deve informar? Quais valores ele pode receber?
2. Essa informação faz parte das regras que a equipe pretende representar ou o atributo foi incluído por engano?

Se a classificação for necessária, será preciso definir seu significado e acrescentá-la ao conceitual. Se não for necessária, será preciso remover `Tipo` do lógico. O atributo permanece como está até essa definição.

## 2026-10-29 — Identificação de `Paciente_Prontuário`

**Situação: pendente de decisão.**

O projeto lógico usa apenas `IDP` como chave primária, e as relações que referenciam o prontuário apontam para esse atributo. O conceitual apresenta tanto `ID_Prontuário` quanto `CPF` sublinhados, deixando a interpretação da identificação a esclarecer.

### Alternativas

| Regra desejada | Representação no lógico |
|---|---|
| `IDP` identifica o prontuário e um CPF pode aparecer em vários prontuários. | PK `IDP`; CPF como dado, sem unicidade. |
| `IDP` identifica o prontuário e cada CPF só pode aparecer em um prontuário. | PK `IDP`; CPF também único, com obrigatoriedade definida pela regra adotada. |
| Apenas a combinação de `IDP` e `CPF` identifica o prontuário. | PK `(IDP, CPF)`; referências devem conter a combinação inteira. |

### Exemplos

- Se uma pessoa puder ter os prontuários 123 e 456, ambos com o mesmo CPF, não se deve impor unicidade ao CPF nessa relação.
- Na representação atual, não é possível cadastrar dois prontuários com `IDP = 123`, mesmo que os CPFs sejam diferentes: `IDP` é a PK sozinho.
- Se a equipe quiser que o mesmo número de prontuário possa ser usado por pessoas diferentes, será necessário rever a identificação. Uma PK composta permitiria pares como `(123, CPF_A)` e `(123, CPF_B)` e exigiria ajustar as FKs que hoje usam apenas `IDP`.

### Perguntas para decidir

1. Uma mesma pessoa pode ter mais de um prontuário?
2. `IDP` é único no hospital inteiro ou depende do CPF para identificar um prontuário?
3. O sublinhado em `CPF` no conceitual indica uma chave alternativa, uma parte de chave composta ou uma marcação a corrigir?

Nenhuma alternativa foi aplicada. `IDP` continua sendo a PK do lógico, e as referências existentes foram mantidas. O alinhamento com o conceitual depende dessa decisão.

## 2026-10-29 — Mapeamento de `LOTADO`

**Situação: pendente de decisão.**

No [diagrama conceitual](../diagrama_atual.drawio), `LOTADO` liga `MÉDICO` a `DEPARTAMENTO`, com cardinalidade 1:N de departamento para médico. O identificador do médico é `CRM`; `Coren` identifica enfermeiro.

No [projeto lógico](../projeto_logico.md), a relação `Lotado(Coren, IDD)` referencia enfermeiro, divergindo dos participantes desenhados. Ao mesmo tempo, a coluna `Departamento` em `Médico` e sua FK já conseguem representar a lotação do médico.

### Exemplo

| `CRM` | Nome do médico | Departamento |
|---|---|---|
| 500 | Ana | 10 |
| 600 | Bruno | 10 |
| 700 | Carla | 20 |

Dois médicos podem estar no departamento 10; cada médico possui no máximo um departamento de lotação. A coluna `Departamento` em `Médico` já representa esses vínculos. Usar `Coren` em `Lotado` registra vínculos de enfermeiros, não os vínculos de médicos do diagrama.

### Alternativas

| Alternativa | Alterações necessárias | Consequência |
|---|---|---|
| Usar a FK já existente em `Médico` — recomendação para discussão | Manter `Médico.Departamento` e sua referência; remover `Lotado` e suas duas referências. | A informação fica em um único lugar, sem tabela adicional nem junção para obter o identificador do departamento do médico. |
| Manter uma relação separada | Usar `Lotado(CRM, IDD!)`, com PK `CRM` e FKs para `Médico(CRM)` e `Departamento(IDD)`; remover a coluna `Departamento` de `Médico` e sua referência. | A ausência de lotação é representada pela ausência de linha; exige uma relação adicional. |

Na primeira opção, a FK em `Médico` continua opcional, conforme a participação parcial desenhada. Na segunda, `IDD!` é obrigatório dentro de uma linha de lotação, mas um médico pode existir sem linha em `Lotado`.

As duas alternativas podem representar o relacionamento conceitual atual. A decisão é onde guardar a informação, preservando a regra sem duplicar o mesmo vínculo em dois lugares independentes. Nenhuma alternativa foi aplicada; `Lotado` permanece como está até a decisão.
