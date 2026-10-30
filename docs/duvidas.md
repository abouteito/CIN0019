# Dúvidas de modelagem

[README](../README.md) · [Projeto lógico](../projeto_logico.md) · [Histórico de alterações](historico.md) · [Checklist do projeto](checklist.md)

Este documento reúne as questões de modelagem. As **pendentes** ainda não foram decididas; as **resolvidas** foram aplicadas e estão detalhadas no [histórico](historico.md). As decisões abaixo seguiram as recomendações registradas anteriormente e podem ser revistas pela equipe.

## Pendentes

### 2026-10-29 — Cardinalidade de `ADMINISTRADO` com `Medicamento` como catálogo

**Situação: pendente de decisão.**

`MEDICAMENTO` é identificado por `(Fórmula, Nome, Dosagem)`, ou seja, funciona como um cadastro de medicamentos. Em `ADMINISTRADO`, a cardinalidade 1:N entre `POSSUI` e `MEDICAMENTO` faz com que cada medicamento cadastrado só possa ser vinculado a **uma** associação condição–prontuário.

| `Fórmula` | `Nome` | `Dosagem` | `ID_Condição` | `IDP` | Situação |
|---|---|---|---|---|---|
| F1 | Medicamento A | D1 | 10 | 123 | Permitido. |
| F1 | Medicamento A | D1 | 20 | 456 | **Não permitido:** repete a PK do medicamento. |

Na prática, o mesmo medicamento (por exemplo, o mesmo analgésico na mesma dosagem) não poderia ser administrado a dois pacientes diferentes.

**Perguntas:**

1. `MEDICAMENTO` representa um cadastro compartilhado ou uma prescrição específica de um paciente?
2. Se for um cadastro compartilhado, `ADMINISTRADO` deveria ser N:M?

Se a resposta for N:M, o conceitual muda (`1` passa a `M`) e, no lógico, a PK de `Administrado` passa a incluir `ID_Condição` e `IDP`. Nada foi alterado até a decisão.

### 2026-10-29 — Participação total nos dois lados de `POSSUI`

**Situação: pendente de decisão.**

O diagrama desenha `POSSUI` com participação total tanto em `CONDIÇÃO` quanto em `PRONTUÁRIO PACIENTE`. Isso significa que todo prontuário teria ao menos uma condição e toda condição cadastrada teria ao menos um prontuário.

**Perguntas:**

1. Um paciente pode ter o prontuário aberto antes de qualquer condição ser registrada?
2. Uma condição pode ser cadastrada antes de existir paciente associado a ela?

Se alguma resposta for "sim", a linha dupla correspondente deve virar linha simples no conceitual. A estrutura relacional não impõe nenhuma das duas participações; hoje elas estão listadas entre as restrições do [projeto lógico](../projeto_logico.md).

## Resolvidas

### 2026-10-29 — Cardinalidade de `Possui` entre `Condição` e `Prontuário Paciente`

**Situação: resolvida em 2026-10-29 — N:M.**

Um prontuário pode ter várias condições, e uma condição cadastrada (com nome e descrição) é compartilhada por vários prontuários. O conceitual foi corrigido: os rótulos de `POSSUI` passaram de `1`–`1` para `N` (lado `CONDIÇÃO`) e `M` (lado `PRONTUÁRIO PACIENTE`). A PK composta `(ID_Condição, IDP)` do lógico já expressava essa cardinalidade e foi mantida, assim como a FK de `Administrado`. As participações desenhadas não foram alteradas (ver pendência acima).

### 2026-10-29 — Significado de `Tipo` em `Condição`

**Situação: resolvida em 2026-10-29 — atributo removido.**

`Tipo` não existia no conceitual e não tinha definição nem domínio. Como o conceitual é a referência do modelo, `Tipo` foi removido de `Condição` no lógico. Se a equipe quiser classificar condições, o atributo deve ser definido e acrescentado primeiro ao diagrama.

### 2026-10-29 — Identificação de `Paciente_Prontuário`

**Situação: resolvida em 2026-10-29 — PK `IDP`, `CPF` único e obrigatório.**

Cada pessoa tem no máximo um prontuário, e `IDP` é único no hospital inteiro. Assim, `IDP` é a PK (e as FKs existentes continuam válidas) e `CPF` é chave alternativa, escrita como `[CPF]!` no lógico. Isso é compatível com o conceitual, onde `ID_Prontuário` e `CPF` já aparecem sublinhados; o diagrama não precisou mudar. Alternativa descartada: PK composta `(IDP, CPF)`, que exigiria ajustar todas as FKs sem benefício para a regra adotada.

### 2026-10-29 — Mapeamento de `LOTADO`

**Situação: resolvida em 2026-10-29 — FK em `Médico`.**

A relação `Lotado(Coren, IDD)` foi removida: referenciava enfermeiro, enquanto o conceitual liga médico a departamento, e a lotação de enfermeiros já é coberta por `ATUA`. A lotação do médico fica em `Médico.IDD → Departamento(IDD)`, opcional (participação parcial). A coluna `Departamento` foi renomeada para `IDD`, igual às demais referências a departamento. Alternativa descartada: relação separada `Lotado(CRM, IDD!)`, que exigiria uma tabela a mais para a mesma informação.
