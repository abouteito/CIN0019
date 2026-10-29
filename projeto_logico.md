**ENTIDADES**

Departamento(IDD, Nome, Descrição)

Leito(IDL, IDD)  
IDD → Departamento(IDD)

Médico(CRM, CPF, Nome, Salário, Departamento)  
Departamento → Departamento(IDD)

Enfermeiro(Coren, CPF, Nome, Salário)

Medicamento(Fórmula, Nome, Dosagem, Bula)

Condição(ID\_Condição, Nome, Descrição, Tipo)

Paciente\_Prontuário(IDP, CPF, Nome, DT\_Nascimento, Endereço, Telefone)

**RELACIONAMENTOS**

Possui(ID\_Condição, IDP)  
ID\_Condição → Condição(ID\_Condição)  
IDP → Paciente\_Prontuário(IDP)

Administrado(ID\_Condição, IDP, Medicação)  
(ID\_Condição, IDP) → Possui(ID\_Condição, IDP)  
Medicação → Medicamento(Fórmula, Nome, Dosagem)

Atendimento(IDP, CRM, Coren, DT\_Atendimento)  
IDP → Paciente\_Prontuário(IDP)  
CRM → Médico(CRM)  
Coren → Enfermeiro(Coren)

Gerencia(IDD, CRM)  
IDD → Departamento(IDD)  
CRM → Médico(CRM)

Lotado(Coren, IDD)  
Coren → Enfermeiro(Coren)  
IDD → Departamento(IDD)

Atua(IDD, Coren)  
IDD → Departamento(IDD)  
Coren → Enfermeiro(Coren)

Chefia(CorenChefiado, CorenChefe, DT\_Inicio)  
CorenChefe → Enfermeiro(Coren)  
CorenChefiado → Enfermeiro(Coren)

