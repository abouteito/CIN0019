**ENTIDADES**

Departamento(<u>IDD</u>, Nome, Descrição)

Leito(<u>IDL, IDD</u>)  
IDD → Departamento(IDD)

Médico(<u>CRM</u>, CPF, Nome, Salário, Departamento)  
Departamento → Departamento(IDD)

Enfermeiro(<u>Coren</u>, CPF, Nome, Salário, TipoEnfermeiro!)

Domínio de `TipoEnfermeiro`: `PLANTONISTA` ou `EFETIVO`.

Medicamento(<u>Fórmula, Nome, Dosagem</u>, Bula)

Condição(<u>ID\_Condição</u>, Nome, Descrição, Tipo)

Paciente\_Prontuário(<u>IDP</u>, CPF, Nome, DT\_Nascimento, Rua, Número, CEP)

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

Lotado(<u>Coren</u>, IDD)  
Coren → Enfermeiro(Coren)  
IDD → Departamento(IDD)

Atua(<u>IDD, Coren</u>)  
IDD → Departamento(IDD)  
Coren → Enfermeiro(Coren)

Chefia(<u>CorenChefiado</u>, CorenChefe!, DT\_Inicio)  
CorenChefe → Enfermeiro(Coren)  
CorenChefiado → Enfermeiro(Coren)

**Documentação de apoio**

[README](README.md) · [Histórico de alterações](docs/historico.md) · [Dúvidas de modelagem](docs/duvidas.md) · [Checklist do projeto](docs/checklist.md)

