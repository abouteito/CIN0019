**ENTIDADES**

Departamento(<u>IDD</u>, Nome, Descrição)

Leito(<u>IDL, IDD</u>)  
IDD → Departamento(IDD)

Médico(<u>CRM</u>, CPF, Nome, Salário, Departamento)  
Departamento → Departamento(IDD)

Enfermeiro(<u>Coren</u>, CPF, Nome, Salário)

Medicamento(<u>Fórmula, Nome, Dosagem</u>, Bula)

Condição(<u>ID\_Condição</u>, Nome, Descrição, Tipo)

Paciente\_Prontuário(<u>IDP</u>, CPF, Nome, DT\_Nascimento, Endereço, Telefone)

**RELACIONAMENTOS**

Possui(<u>ID\_Condição, IDP</u>)  
ID\_Condição → Condição(ID\_Condição)  
IDP → Paciente\_Prontuário(IDP)

Administrado(<u>ID\_Condição, IDP, Medicação</u>)  
(ID\_Condição, IDP) → Possui(ID\_Condição, IDP)  
Medicação → Medicamento(Fórmula, Nome, Dosagem)

Atendimento(<u>IDP, CRM, Coren, DT\_Atendimento</u>)  
IDP → Paciente\_Prontuário(IDP)  
CRM → Médico(CRM)  
Coren → Enfermeiro(Coren)

Gerencia(<u>IDD</u>, CRM)  
IDD → Departamento(IDD)  
CRM → Médico(CRM)

Lotado(<u>Coren</u>, IDD)  
Coren → Enfermeiro(Coren)  
IDD → Departamento(IDD)

Atua(<u>IDD, Coren</u>)  
IDD → Departamento(IDD)  
Coren → Enfermeiro(Coren)

Chefia(<u>CorenChefiado, CorenChefe</u>, DT\_Inicio)  
CorenChefe → Enfermeiro(Coren)  
CorenChefiado → Enfermeiro(Coren)

