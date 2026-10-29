# Histórico de alterações

Registro das alterações do diagrama de entidade-relacionamento, com justificativas e referências conceituais, das mais recentes até as mais antigas.

## Atualização de 2026-10-28

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

Primeira versão do diagrama disponível nos arquivos históricos.
Estrutura já presente nessa versão:

- Entidades `MÉDICO`, `ENFERMEIRO`, `DEPARTAMENTO`, `LEITO`, `PRONTUÁRIO PACIENTE`, `DOENÇA` e `ACOMPANHANTE`.
- Relacionamentos `GERENCIA`, `LOTADO`, `ATUA`, `TEM`, `ATENDIMENTO`, `POSSUI`, `ACOMPANHA` e o autorrelacionamento `CHEFIA`.
- Especialização de `ENFERMEIRO` em `PLANTONISTA` e `EFETIVO`, com indicação de totalidade e disjunção.
- `LEITO` com retângulo duplo e `TEM` com losango duplo.
- `POSSUI` representado como associação que participa de outro relacionamento.
- `ENDEREÇO` composto por `RUA`, `NÚMERO` e `CEP`, além de `TELEFONE`, datas, salários e atributos de identificação pessoal e profissional.
