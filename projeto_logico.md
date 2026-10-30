# Projeto lógico — Hospital

**LEGENDA**

- <u>Sublinhado</u>: chave primária (PK). Seus componentes são sempre obrigatórios.
- `→`: chave estrangeira (FK) para a relação indicada.
- `[ ]`: atributo único (chave alternativa).
- `!`: atributo obrigatório (não nulo), indicado onde a obrigatoriedade decorre de uma regra do modelo.
- Correspondência de nomes com o conceitual: `IDD` = `ID_Departamento`, `IDL` = `ID_Leito`, `IDP` = `ID_Prontuário`.

**ENTIDADES**

Departamento(<u>IDD</u>, Nome, Descrição)

Leito(<u>IDL, IDD</u>)  
IDD → Departamento(IDD)

Médico(<u>CRM</u>, CPF, Nome, Salário, IDD)  
IDD → Departamento(IDD)  
*(`IDD` implementa `LOTADO`: opcional, pois um médico pode não estar lotado em nenhum departamento.)*

Enfermeiro(<u>Coren</u>, CPF, Nome, Salário, TipoEnfermeiro!)

Domínio de `TipoEnfermeiro`: `PLANTONISTA` ou `EFETIVO`.

Medicamento(<u>Fórmula, Nome, Dosagem</u>, Bula)

Condição(<u>ID\_Condição</u>, Nome, Descrição)

Paciente\_Prontuário(<u>IDP</u>, [CPF]!, Nome, DT\_Nascimento, Rua, Número, CEP)

Telefone\_Prontuário(<u>IDP, Telefone</u>)  
IDP → Paciente\_Prontuário(IDP)

**RELACIONAMENTOS**

Possui(<u>ID\_Condição, IDP</u>)  
ID\_Condição → Condição(ID\_Condição)  
IDP → Paciente\_Prontuário(IDP)

Administrado(<u>Fórmula, Nome, Dosagem</u>, ID\_Condição!, IDP!)  
(ID\_Condição, IDP) → Possui(ID\_Condição, IDP)  
(Fórmula, Nome, Dosagem) → Medicamento(Fórmula, Nome, Dosagem)

Atendimento(<u>IDP, CRM, Coren, DT\_Atendimento</u>)  
IDP → Paciente\_Prontuário(IDP)  
CRM → Médico(CRM)  
Coren → Enfermeiro(Coren)

Gerencia(<u>IDD</u>, [CRM]!)  
IDD → Departamento(IDD)  
CRM → Médico(CRM)

Atua(<u>IDD, Coren</u>)  
IDD → Departamento(IDD)  
Coren → Enfermeiro(Coren)

Chefia(<u>CorenChefiado</u>, CorenChefe!, DT\_Inicio)  
CorenChefe → Enfermeiro(Coren)  
CorenChefiado → Enfermeiro(Coren)

**MAPEAMENTO DO CONCEITUAL**

| Elemento do conceitual | Representação no lógico |
|---|---|
| `LEITO` / `TEM` (entidade fraca, 1:N identificador) | `Leito(IDL, IDD)`: PK composta, com `IDD` herdado de `Departamento`. |
| `ENDEREÇO` (atributo composto) | `Rua`, `Número` e `CEP` em `Paciente_Prontuário`. |
| `TELEFONE` (multivalorado) | Relação `Telefone_Prontuário`. |
| Herança de `ENFERMEIRO` (total, disjunta) | Relação única com `TipoEnfermeiro!`. |
| `LOTADO` (1:N, médico parcial) | FK `IDD` em `Médico`; não há relação separada. |
| `GERENCIA` (1:1, parcial–parcial) | Relação `Gerencia`: PK `IDD` e `CRM` único e obrigatório. |
| `ATUA` (N:M) | Relação `Atua`. |
| `CHEFIA` (autorrelacionamento 1:N) | Relação `Chefia`: PK `CorenChefiado`. |
| `POSSUI` (N:M) | Relação `Possui`: PK composta. |
| `ADMINISTRADO` (1:N entre `POSSUI` e `MEDICAMENTO`) | Relação `Administrado`: PK do lado N e FK composta para `Possui`. |
| `ATENDIMENTO` (ternário N:N:N com discriminador) | Relação `Atendimento`: PK com os três identificadores e `DT_Atendimento`. |

**RESTRIÇÕES PARA A IMPLEMENTAÇÃO FÍSICA**

1. `Enfermeiro.TipoEnfermeiro` é obrigatório e restrito a `PLANTONISTA` ou `EFETIVO`.
2. `Atendimento.DT_Atendimento` é data e hora (`TIMESTAMP`), com precisão suficiente para distinguir atendimentos com os mesmos participantes.
3. `Chefia`: `CorenChefe` deve ser diferente de `CorenChefiado` (ninguém chefia a si mesmo).
4. `Paciente_Prontuário.CPF` é único e obrigatório: cada pessoa possui no máximo um prontuário.
5. Participações totais do conceitual que a estrutura das relações não garante sozinha, exigindo gatilho ou controle na transação:
   - todo prontuário possui ao menos um `Atendimento`;
   - em `Possui`, todo prontuário se associa a ao menos uma condição e toda condição a ao menos um prontuário, conforme desenhado (ver [duvidas.md](docs/duvidas.md)).
6. A participação total de `Leito` em `TEM` já é garantida: `IDD` faz parte da PK e da FK.

**Documentação de apoio**

[README](README.md) · [Histórico de alterações](docs/historico.md) · [Dúvidas de modelagem](docs/duvidas.md) · [Checklist do projeto](docs/checklist.md)
