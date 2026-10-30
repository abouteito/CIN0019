# Histórico de alterações

Registro das alterações do diagrama de entidade-relacionamento e do projeto lógico, com justificativas e referências conceituais, das mais recentes até as mais antigas.

[README](../README.md) · [Projeto lógico](../projeto_logico.md) · [Dúvidas de modelagem](duvidas.md) · [Checklist do projeto](checklist.md)

## Atualização de 2026-10-29 (terceira revisão do dia)

Diagrama: [2026-10-29_diagrama.drawio](../historico/diagramas/2026-10-29_diagrama.drawio) · Print: [2026-10-29_diagrama.png](../historico/prints/2026-10-29_diagrama.png)

Esta revisão reverte a cardinalidade de `ADMINISTRADO` definida na segunda revisão do dia, que era 1:N com PK de três campos, e substitui essa decisão pela N:M.

### Motivação

Na versão 1:N, cada medicamento podia ser vinculado a uma única associação `Possui`. Na prática, um medicamento administrado a um paciente não poderia ser administrado a nenhum outro, o que não se sustenta, pois `MEDICAMENTO` é um cadastro compartilhado. A equipe aprovou a N:M.

### Alterações no diagrama

- O rótulo `1` do lado de `POSSUI` em `ADMINISTRADO` foi trocado por `M`. O lado de `MEDICAMENTO` continua `N`.
- Nenhuma participação (linhas duplas) ou outro rótulo foi alterado.
- O print de 29/10 foi gerado a partir do print de 28/10 com os rótulos alterados nesta revisão e na anterior, por não haver exportação nativa do draw.io. Convém reexportá-lo pelo draw.io se for necessário um print nativo.

### Alterações no projeto lógico

- A PK de `Administrado` passou de `(Fórmula, Nome, Dosagem)` para `(Fórmula, Nome, Dosagem, ID_Condição, IDP)`, com FKs para `Possui` e `Medicamento`. Os cinco campos são obrigatórios pela PK, por isso os `!` foram retirados.
- A linha correspondente na tabela de mapeamento foi atualizada para N:M.

Exemplo:

| `Fórmula` | `Nome` | `Dosagem` | `ID_Condição` | `IDP` | Situação |
|---|---|---|---|---|---|
| F1 | Medicamento A | D1 | 10 | 123 | Permitido. |
| F2 | Medicamento B | D2 | 10 | 123 | Permitido: mesmo par, outro medicamento. |
| F1 | Medicamento A | D1 | 20 | 456 | Permitido: mesmo medicamento, outro par. |
| F1 | Medicamento A | D1 | 10 | 123 | Não permitido: repete a PK. |

### Dúvidas

- A dúvida de `ADMINISTRADO` foi movida para "Resolvidas" em [duvidas.md](duvidas.md).
- Continua pendente a participação total de `POSSUI` nos dois lados.

## Atualização de 2026-10-29 (segunda revisão do dia)

> **Nota:** a decisão de `ADMINISTRADO` como 1:N descrita nesta seção foi revertida na terceira revisão do dia (ver acima).

Diagrama: [2026-10-29_diagrama.drawio](../historico/diagramas/2026-10-29_diagrama.drawio) · Print: [2026-10-29_diagrama.png](../historico/prints/2026-10-29_diagrama.png)

Resolução das dúvidas registradas em [duvidas.md](duvidas.md) e conclusão do [projeto lógico](../projeto_logico.md). As decisões seguiram as recomendações já registradas e estão sujeitas a confirmação da equipe.

### Alterações no diagrama

**`POSSUI`: cardinalidade N:M**

- Os rótulos de cardinalidade passaram de `1`–`1` para `N` (junto a `CONDIÇÃO`) e `M` (junto a `PRONTUÁRIO PACIENTE`).
- Justificativa: um prontuário pode ter várias condições, e uma condição cadastrada, com nome e descrição, é compartilhada por vários prontuários. O 1:1 anterior impedia isso e divergia da PK composta do lógico.
- Não foram alteradas as participações (linhas duplas), a ligação com `ADMINISTRADO` nem a cardinalidade `1`/`N` desse vínculo. Apenas dois rótulos de texto foram modificados no arquivo.
- O print de 29/10 foi gerado a partir do print de 28/10, trocando os dois rótulos; convém reexportá-lo no draw.io se for necessário um print nativo.

### Alterações no projeto lógico

**`LOTADO`: FK em `Médico`**

- A relação `Lotado(Coren, IDD)` foi removida. Ela referenciava enfermeiro, enquanto o conceitual liga médico a departamento. A lotação de enfermeiros já é representada por `Atua`.
- `Médico.Departamento` foi renomeada para `Médico.IDD`, mantendo a FK para `Departamento(IDD)` e a opcionalidade (participação parcial do médico).
- Exemplo: os médicos 500 e 600 podem ter `IDD = 10`, e um médico sem lotação tem `IDD` nulo.

**`CONDIÇÃO`: remoção de `Tipo`**

- O atributo não existia no conceitual nem tinha definição ou domínio. Foi removido do lógico, mantendo o conceitual como referência.

**`PACIENTE_PRONTUÁRIO`: `CPF` único e obrigatório**

- `IDP` continua sendo a PK; `CPF` passou a `[CPF]!`. Cada pessoa tem no máximo um prontuário; dois prontuários com o mesmo CPF não são permitidos.
- Nenhuma FK foi alterada, e o conceitual já sublinhava `ID_Prontuário` e `CPF`.

**Complementos ao documento**

- Acrescentadas a legenda da notação, a correspondência de nomes (`IDD`, `IDL`, `IDP`), a tabela de mapeamento do conceitual e a lista de restrições para a implementação física: domínio de `TipoEnfermeiro`, `DT_Atendimento` como `TIMESTAMP`, `CorenChefe` diferente de `CorenChefiado`, `CPF` único e participações totais que exigem gatilho.
- As relações `Possui`, `Administrado`, `Atendimento`, `Gerencia`, `Atua` e `Chefia` não foram alteradas.

### Dúvidas

- As quatro dúvidas anteriores foram movidas para "Resolvidas" em [duvidas.md](duvidas.md).
- Foram registradas duas novas pendências, sem alteração no modelo: a cardinalidade 1:N de `ADMINISTRADO` com `Medicamento` funcionando como catálogo, e a participação total nos dois lados de `POSSUI`.

## Atualização de 2026-10-29

### Alterações no projeto lógico

Foram aplicadas seis correções em [projeto_logico.md](../projeto_logico.md), preservando o diagrama conceitual atual.

**`CHEFIA`: no máximo um chefe atual por enfermeiro chefiado**

- Antes, a PK era `(CorenChefiado, CorenChefe)`. Ela impedia apenas repetir o mesmo par e permitia que o mesmo chefiado tivesse vários chefes.
- A PK passou a ser somente `CorenChefiado`. `CorenChefe` permanece como FK para `Enfermeiro(Coren)` e foi marcado como obrigatório com `!`, pois uma linha de chefia deve identificar o chefe.
- `CorenChefe` pode se repetir em linhas de chefiados diferentes: um chefe pode chefiar vários enfermeiros. `DT_Inicio` permanece como atributo comum.

Exemplo de vínculos permitidos:

| `CorenChefiado` | `CorenChefe` | `DT_Inicio` |
|---|---|---|
| 101 | 900 | 2026-10-01 |
| 102 | 900 | 2026-10-15 |

O chefe 900 pode chefiar os enfermeiros 101 e 102. Adicionar outra linha para o chefiado 101 com o chefe 901 não é permitido, porque repetiria a PK `CorenChefiado = 101`. Para trocar o chefe atual, atualiza-se o vínculo existente; esta relação não guarda o histórico de chefias anteriores.

**`GERENCIA`: preservar o relacionamento 1:1**

- A PK `IDD` foi mantida: cada departamento aparece no máximo uma vez em `Gerencia`.
- `CRM` passou a ser escrito como `[CRM]!`, indicando valor único e obrigatório. Assim, cada médico gerencia no máximo um departamento e toda linha da relação informa qual é o gerente.
- As duas FKs foram preservadas. Um médico ou departamento sem vínculo de gerência é representado pela ausência de linha em `Gerencia`, mantendo as participações parciais do conceitual.

Exemplo de vínculos permitidos:

| `IDD` | `CRM` |
|---|---|
| 10 | 500 |
| 20 | 600 |

Adicionar `(30, 500)` não é permitido, porque o médico de CRM 500 já gerencia o departamento 10. Adicionar `(10, 700)` também não é permitido, porque o departamento 10 já possui gerente.

**`TELEFONE`: mapear o atributo multivalorado**

- `Telefone` foi removido da lista de atributos de `Paciente_Prontuário` e passou para a relação `Telefone_Prontuário(IDP, Telefone)`.
- A nova relação tem PK `(IDP, Telefone)` e FK `IDP → Paciente_Prontuário(IDP)`.
- Um prontuário pode ter vários telefones. Um telefone também pode aparecer em prontuários diferentes, mas o mesmo par prontuário–telefone não pode ser repetido. A ausência de telefones é representada pela ausência de linhas para aquele prontuário.

Exemplo de registros permitidos:

| `IDP` | `Telefone` |
|---|---|
| 123 | (81) 99999-1111 |
| 123 | (81) 98888-2222 |
| 456 | (81) 99999-1111 |

Os dois primeiros registros guardam dois telefones do prontuário 123. O terceiro compartilha um número com outro prontuário. Repetir `(123, (81) 99999-1111)` não é permitido, porque duplicaria a PK composta.

**`ADMINISTRADO`: referência composta e cardinalidade conforme o diagrama**

- A coluna `Medicação` foi substituída por `Fórmula`, `Nome` e `Dosagem`, que identificam `Medicamento` em conjunto.
- Foi definida uma FK composta `(Fórmula, Nome, Dosagem) → Medicamento(Fórmula, Nome, Dosagem)`. Os três valores devem corresponder ao mesmo medicamento existente.
- Foi mantida a FK composta `(ID_Condição, IDP) → Possui(ID_Condição, IDP)`. Esses dois atributos foram marcados como obrigatórios com `!`.
- O diagrama apresenta `ADMINISTRADO` como 1:N de `POSSUI` para `MEDICAMENTO`: uma associação condição–prontuário pode se vincular a vários medicamentos, e cada medicamento pode se vincular a no máximo uma dessas associações.
- Para preservar essa cardinalidade em uma relação separada, a PK passou a ser apenas `(Fórmula, Nome, Dosagem)`, correspondente ao lado N. Incluir também `ID_Condição` e `IDP` na PK permitiria repetir o mesmo medicamento em associações diferentes.
- Uma ocorrência de `POSSUI` sem medicamentos e um medicamento sem vínculo de administração são representados pela ausência de linhas correspondentes em `Administrado`.

Exemplo fictício de registros permitidos, supondo que os medicamentos e os pares de `Possui` já existam:

| `Fórmula` | `Nome` | `Dosagem` | `ID_Condição` | `IDP` |
|---|---|---|---|---|
| F1 | Medicamento A | D1 | 10 | 123 |
| F2 | Medicamento B | D2 | 10 | 123 |
| F1 | Medicamento A | D2 | 20 | 456 |

As duas primeiras linhas associam medicamentos diferentes ao mesmo par `(10, 123)`. A terceira usa outro medicamento, porque a dosagem faz parte da identificação. Adicionar `(F1, Medicamento A, D1, 20, 456)` não é permitido: repetiria a PK do medicamento da primeira linha. Essa restrição reproduz a cardinalidade atualmente desenhada.

A cardinalidade interna de `POSSUI` continua em discussão em [duvidas.md](duvidas.md). Quando ela for decidida, será necessário conferir novamente a chave referenciada por `Administrado`.

**`ENDEREÇO`: desdobrar o atributo composto**

- `Endereço` foi substituído por `Rua`, `Número` e `CEP` em `Paciente_Prontuário`, reproduzindo os componentes já existentes no conceitual.
- Os componentes permanecem na própria relação do prontuário; não foi criada uma relação separada para endereço nem foram alteradas a PK `IDP` e suas referências.

Exemplo de preenchimento:

| `IDP` | `Rua` | `Número` | `CEP` |
|---|---|---|---|
| 123 | Rua das Flores | 12 | 50000-000 |

O exemplo guarda separadamente os três componentes, permitindo consultar o CEP ou o número sem extraí-los de um texto de endereço completo.

**Herança de `ENFERMEIRO`: uma única relação com classificação obrigatória**

- Foi acrescentado `TipoEnfermeiro!` à relação `Enfermeiro`, com domínio restrito a `PLANTONISTA` ou `EFETIVO`.
- A PK `Coren`, os atributos existentes e as referências para enfermeiros foram preservados. Não foram criadas relações separadas para as subclasses.
- A classificação obrigatória com exatamente esses dois valores representa a especialização total e disjunta: todo enfermeiro pertence a uma categoria, e não às duas simultaneamente.
- O atributo de classificação resulta do mapeamento da herança já desenhada; não exige alterar o diagrama conceitual.

Exemplo de registros:

| `Coren` | Nome | `TipoEnfermeiro` |
|---|---|---|
| 101 | Ana | PLANTONISTA |
| 102 | João | EFETIVO |

Uma linha sem categoria ou com um valor diferente dos dois previstos não atende ao domínio definido.

A escolha foi comparada à alternativa de manter `Enfermeiro`, `Plantonista` e `Efetivo` como três relações:

| Critério | Uma única relação — escolhida | Superentidade e duas subclasses em relações separadas |
|---|---|---|
| Estrutura atual | As subclasses não possuem atributos nem relacionamentos exclusivos; a classificação cabe na linha de `Enfermeiro`. | As duas relações adicionais guardariam inicialmente apenas `Coren`. |
| Consulta da categoria | O tipo é obtido diretamente na relação de enfermeiros. | Pode exigir consultar ou juntar as relações das subclasses. |
| Totalidade e disjunção | Campo obrigatório com domínio de dois valores expressa uma única categoria para cada linha. | As FKs para `Enfermeiro` não impedem, sozinhas, a presença nas duas subclasses nem garantem presença em pelo menos uma. |
| Evolução | É simples para a estrutura atual; atributos exclusivos futuros podem gerar campos que só se aplicam a uma categoria. | Favorece a organização de atributos e relacionamentos exclusivos que venham a surgir. |

Foi escolhida a relação única por atender à estrutura atual com menos relações e controle mais direto da classificação. O domínio e a obrigatoriedade precisam ser preservados na implementação física.

### Dúvidas registradas

Foi criado [duvidas.md](duvidas.md) para discutir a divergência entre o 1:1 de `POSSUI` no diagrama e os vínculos N:M permitidos pela chave composta no lógico, com exemplos e perguntas para decisão. Esse relacionamento não foi alterado nesta revisão.

Também foram registradas as dúvidas sobre o significado de `Tipo` em `Condição` e sobre a identificação de `Paciente_Prontuário` por `IDP`, `CPF` ou sua combinação. Esses pontos permanecem sem alteração até decisão da equipe.

Foi acrescentada a dúvida sobre `LOTADO`: o lógico referencia enfermeiro enquanto o diagrama liga médico a departamento, e a FK existente em `Médico` já representa a lotação. Foram registradas as alternativas de manter somente essa FK ou usar uma relação separada com `CRM`, sem aplicar nenhuma delas.

### Organização da documentação

O README foi alinhado à organização em `docs/`: [histórico](historico.md), [dúvidas](duvidas.md) e [checklist](checklist.md). As referências relativas e os links de navegação entre os documentos foram corrigidos. O diagrama atual e o projeto lógico permanecem na raiz, e os arquivos históricos de diagramas e imagens continuam em `historico/`.

## Atualização de 2026-10-28

### Alterações no diagrama

Foram corrigidas três representações de atributos conforme a notação adotada na disciplina:

**`TELEFONE`: atributo multivalorado**

- As duas linhas horizontais internas foram removidas e substituídas por uma segunda elipse, mantendo o nome e a ligação com `PRONTUÁRIO PACIENTE`.
- A elipse dupla representa a possibilidade de um paciente ter vários telefones. As linhas internas da versão anterior não expressavam essa propriedade na notação adotada.

**`DT_ATENDIMENTO`: discriminador em relacionamento**

- O nome passou a usar sublinhado tracejado, mantendo a elipse simples e a ligação com `ATENDIMENTO`.
- A marcação permite distinguir atendimentos que envolvem o mesmo médico, enfermeiro e prontuário em instantes diferentes. A identificação da ocorrência considera os participantes e `DT_ATENDIMENTO`.
- Foi definido que o valor representa data e hora (`TIMESTAMP`), sem criar um atributo separado para hora. Essa é uma definição semântica; a alteração gráfica consiste no sublinhado tracejado.
- O instante não precisa ser único no hospital inteiro, mas deve ter precisão suficiente para distinguir atendimentos com os mesmos participantes. O tipo `TIMESTAMP`, sozinho, não garante essa unicidade.
- O tracejado pertence ao sublinhado do nome, e não ao contorno da elipse.

**`ID_Leito`: chave parcial de entidade fraca**

- O sublinhado contínuo foi substituído por tracejado, indicando um identificador local ao departamento.
- `ID_Leito` pode se repetir entre departamentos, mas deve distinguir os leitos de um mesmo departamento. Por exemplo, o departamento 10 e o departamento 20 podem ter um leito `01`, identificados por `(10, 01)` e `(20, 01)`.
- A identificação completa do leito é `(ID_Departamento, ID_Leito)`. O nome `ID_Leito` foi mantido.
- Foram preservados o retângulo duplo de `LEITO`, o losango duplo de `TEM`, a participação total do leito e a cardinalidade `1:N` de departamento para leito.
- Cada leito depende de exatamente um departamento proprietário para sua identificação. A participação do departamento continua parcial, pois um departamento pode existir sem leitos.
- A dependência de identificação justifica a entidade fraca, pois apenas pertencer obrigatoriamente a um departamento não seria suficiente. O relacionamento identificador já expressa essa dependência no modelo conceitual, sem necessidade de copiar `ID_Departamento` para uma nova elipse em `LEITO`.

Referências conceituais utilizadas na revisão: slides de Robson (Aula 02 - slide 21, Aula 04 - slide 25)

## Atualização de 2026-10-19

### Alterações no diagrama

- `DOENÇA` foi renomeada para `CONDIÇÃO`. A justificativa registrada no commit foi ampliar o conceito para abranger também síndromes e outras condições.
- Foram adicionados `ID_Condição`, `Nome` e `Descrição` a `CONDIÇÃO`.
- `ACOMPANHANTE` foi substituído por `MEDICAMENTO`, e `ACOMPANHA` passou a se chamar `ADMINISTRADO`, mantendo a ligação com a associação `POSSUI` entre condição e prontuário.
- A cardinalidade junto a `MEDICAMENTO` nesse vínculo passou de `1` para `N`.
- Foram adicionados `Nome`, `Fórmula`, `Dosagem` e `Bula` a `MEDICAMENTO`. Os três primeiros foram sublinhados, e o commit os descreveu como uma chave composta provisória, sujeita a revisão.
- Foram adicionados `ID_Departamento`, `Nome` e `Descrição` a `DEPARTAMENTO`.
- Foi adicionado `ID_Leito` a `LEITO`, então representado com sublinhado contínuo. A interpretação como chave parcial foi explicitada na revisão de 28/10.
- Foi adicionado `ID_Prontuário` a `PRONTUÁRIO PACIENTE`, e `CPF` passou a aparecer sublinhado. O commit registrou a avaliação de alternativas de identificação para o prontuário, sem documentar uma resolução definitiva dessa discussão.
- Foram adicionados `COREN`, `NOME` e `CPF` a `ENFERMEIRO`, e `CPF` a `MÉDICO`. `COREN` aparece sublinhado nessa versão.
- O sublinhado de `CRM` passou a integrar o próprio texto do atributo, substituindo o traço desenhado separadamente.
- Houve reposicionamento de atributos do prontuário, de seus dados de contato e do salário de enfermeiro, além de ajustes nos pontos de conexão.

## Versão de 2026-10-08

### Alterações no diagrama

Primeira versão do diagrama disponível nos arquivos históricos.
Estrutura já presente nessa versão:

- Entidades `MÉDICO`, `ENFERMEIRO`, `DEPARTAMENTO`, `LEITO`, `PRONTUÁRIO PACIENTE`, `DOENÇA` e `ACOMPANHANTE`.
- Relacionamentos `GERENCIA`, `LOTADO`, `ATUA`, `TEM`, `ATENDIMENTO`, `POSSUI`, `ACOMPANHA` e o autorrelacionamento `CHEFIA`.
- Especialização de `ENFERMEIRO` em `PLANTONISTA` e `EFETIVO`, com indicação de totalidade e disjunção.
- `LEITO` com retângulo duplo e `TEM` com losango duplo.
- `POSSUI` representado como associação que participa de outro relacionamento.
- `ENDEREÇO` composto por `RUA`, `NÚMERO` e `CEP`, além de `TELEFONE`, datas, salários e atributos de identificação pessoal e profissional.
