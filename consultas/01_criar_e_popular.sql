-- =====================================================================
-- PROJETO HOSPITAL (CIN0019) - ORACLE
-- ARQUIVO 1: criar tabelas e inserir dados
-- Rode este arquivo PRIMEIRO. Para refazer do zero, rode-o de novo.
-- =====================================================================

-- ---- limpeza (permite rodar mais de uma vez; exige Oracle 23ai, o do Live SQL) ----
DROP TABLE IF EXISTS log_salario_enfermeiro CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS chefia CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS atua CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS gerencia CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS atendimento CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS administrado CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS possui CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS telefone_prontuario CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS paciente_prontuario CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS condicao CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS medicamento CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS enfermeiro CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS medico CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS leito CASCADE CONSTRAINTS PURGE;
DROP TABLE IF EXISTS departamento CASCADE CONSTRAINTS PURGE;

-- ---- tabelas ----
CREATE TABLE departamento (
  idd        NUMBER PRIMARY KEY,
  nome       VARCHAR2(50) NOT NULL,
  descricao  VARCHAR2(200)
);

CREATE TABLE leito (                         -- entidade fraca
  idl  NUMBER NOT NULL,
  idd  NUMBER NOT NULL REFERENCES departamento(idd),
  PRIMARY KEY (idl, idd)
);

CREATE TABLE medico (
  crm      VARCHAR2(10) PRIMARY KEY,
  cpf      CHAR(11) NOT NULL,
  nome     VARCHAR2(80) NOT NULL,
  salario  NUMBER(10,2) NOT NULL,
  idd      NUMBER REFERENCES departamento(idd)      -- LOTADO (opcional)
);

CREATE TABLE enfermeiro (                    -- heranca total e disjunta (tabela unica)
  coren            VARCHAR2(10) PRIMARY KEY,
  cpf              CHAR(11) NOT NULL,
  nome             VARCHAR2(80) NOT NULL,
  salario          NUMBER(10,2) NOT NULL,
  tipo_enfermeiro  VARCHAR2(12) NOT NULL CHECK (tipo_enfermeiro IN ('PLANTONISTA','EFETIVO'))
);

CREATE TABLE medicamento (
  formula  VARCHAR2(20),
  nome     VARCHAR2(50),
  dosagem  VARCHAR2(20),
  bula     VARCHAR2(200),
  PRIMARY KEY (formula, nome, dosagem)
);

CREATE TABLE condicao (
  id_condicao  NUMBER PRIMARY KEY,
  nome         VARCHAR2(60) NOT NULL,
  descricao    VARCHAR2(200)
);

CREATE TABLE paciente_prontuario (
  idp            NUMBER PRIMARY KEY,
  cpf            CHAR(11) NOT NULL UNIQUE,
  nome           VARCHAR2(80) NOT NULL,
  dt_nascimento  DATE NOT NULL,
  rua            VARCHAR2(80),                -- endereco (composto)
  numero         NUMBER,
  cep            CHAR(8)
);

CREATE TABLE telefone_prontuario (           -- multivalorado
  idp       NUMBER REFERENCES paciente_prontuario(idp),
  telefone  VARCHAR2(15),
  PRIMARY KEY (idp, telefone)
);

CREATE TABLE possui (                        -- N:M
  id_condicao  NUMBER REFERENCES condicao(id_condicao),
  idp          NUMBER REFERENCES paciente_prontuario(idp),
  PRIMARY KEY (id_condicao, idp)
);

CREATE TABLE administrado (
  formula      VARCHAR2(20),
  nome         VARCHAR2(50),
  dosagem      VARCHAR2(20),
  id_condicao  NUMBER,
  idp          NUMBER,
  PRIMARY KEY (formula, nome, dosagem, id_condicao, idp),
  FOREIGN KEY (id_condicao, idp) REFERENCES possui(id_condicao, idp),
  FOREIGN KEY (formula, nome, dosagem) REFERENCES medicamento(formula, nome, dosagem)
);

CREATE TABLE atendimento (                   -- ternario com discriminador
  idp             NUMBER REFERENCES paciente_prontuario(idp),
  crm             VARCHAR2(10) REFERENCES medico(crm),
  coren           VARCHAR2(10) REFERENCES enfermeiro(coren),
  dt_atendimento  TIMESTAMP,
  PRIMARY KEY (idp, crm, coren, dt_atendimento)
);

CREATE TABLE gerencia (                      -- 1:1 parcial-parcial
  idd  NUMBER PRIMARY KEY REFERENCES departamento(idd),
  crm  VARCHAR2(10) NOT NULL UNIQUE REFERENCES medico(crm)
);

CREATE TABLE atua (                          -- N:M
  idd    NUMBER REFERENCES departamento(idd),
  coren  VARCHAR2(10) REFERENCES enfermeiro(coren),
  PRIMARY KEY (idd, coren)
);

CREATE TABLE chefia (                        -- autorrelacionamento 1:N
  coren_chefiado  VARCHAR2(10) PRIMARY KEY REFERENCES enfermeiro(coren),
  coren_chefe     VARCHAR2(10) NOT NULL REFERENCES enfermeiro(coren),
  dt_inicio       DATE NOT NULL,
  CHECK (coren_chefe <> coren_chefiado)
);

-- ---- dados ----
INSERT INTO departamento VALUES (1,'Cardiologia','Doenças do coração');
INSERT INTO departamento VALUES (2,'Pediatria','Atendimento infantil');
INSERT INTO departamento VALUES (3,'Ortopedia','Ossos e articulações');
INSERT INTO departamento VALUES (4,'Neurologia','Sistema nervoso');          -- sem leitos e sem gerente

INSERT INTO leito VALUES (1,1);
INSERT INTO leito VALUES (2,1);
INSERT INTO leito VALUES (3,1);
INSERT INTO leito VALUES (1,2);
INSERT INTO leito VALUES (2,2);
INSERT INTO leito VALUES (1,3);

INSERT INTO medico VALUES ('CRM01','11111111111','Ana Souza',  15000.00, 1);
INSERT INTO medico VALUES ('CRM02','22222222222','Bruno Lima', 12000.00, 1);
INSERT INTO medico VALUES ('CRM03','33333333333','Carla Dias', 18000.00, 2);
INSERT INTO medico VALUES ('CRM04','44444444444','Diego Rocha', 9000.00, 3);
INSERT INTO medico VALUES ('CRM05','55555555555','Elisa Mota', 11000.00, NULL);   -- sem departamento

INSERT INTO enfermeiro VALUES ('COR01','66666666666','Fabio Nunes', 5000.00,'EFETIVO');
INSERT INTO enfermeiro VALUES ('COR02','77777777777','Gina Alves',  4000.00,'PLANTONISTA');
INSERT INTO enfermeiro VALUES ('COR03','88888888888','Hugo Pires',  4500.00,'EFETIVO');
INSERT INTO enfermeiro VALUES ('COR04','99999999999','Iris Costa',  3800.00,'PLANTONISTA');

INSERT INTO medicamento VALUES ('C9H8O4','Aspirina','500mg','Analgésico');
INSERT INTO medicamento VALUES ('C8H9NO2','Paracetamol','750mg','Antitérmico');
INSERT INTO medicamento VALUES ('C13H18O2','Ibuprofeno','400mg','Anti-inflamatório');
INSERT INTO medicamento VALUES ('C16H13ClN2O','Diazepam','10mg','Ansiolítico');   -- nunca administrado

INSERT INTO condicao VALUES (10,'Hipertensão','Pressão arterial elevada');
INSERT INTO condicao VALUES (20,'Diabetes','Glicemia elevada');
INSERT INTO condicao VALUES (30,'Fratura','Lesão óssea');
INSERT INTO condicao VALUES (40,'Enxaqueca','Dor de cabeça recorrente');          -- nenhum paciente

INSERT INTO paciente_prontuario VALUES (1,'10000000001','João Pereira',  DATE '1980-05-10','Rua A',100,'50000001');
INSERT INTO paciente_prontuario VALUES (2,'10000000002','Maria Santos',  DATE '1995-08-21','Rua B',200,'50000002');
INSERT INTO paciente_prontuario VALUES (3,'10000000003','Pedro Gomes',   DATE '2010-01-15','Rua C',300,'50000003');
INSERT INTO paciente_prontuario VALUES (4,'10000000004','Lucia Ramos',   DATE '1975-12-02','Rua D',400,'50000004');
INSERT INTO paciente_prontuario VALUES (5,'10000000005','Marcos Vieira', DATE '2001-03-30','Rua E',500,'50000005');  -- sem atendimento

INSERT INTO telefone_prontuario VALUES (1,'81999990001');
INSERT INTO telefone_prontuario VALUES (1,'81999990002');
INSERT INTO telefone_prontuario VALUES (2,'81999990003');
INSERT INTO telefone_prontuario VALUES (3,'81999990004');

INSERT INTO possui VALUES (10,1);
INSERT INTO possui VALUES (20,1);
INSERT INTO possui VALUES (10,2);
INSERT INTO possui VALUES (30,3);
INSERT INTO possui VALUES (30,4);
INSERT INTO possui VALUES (10,4);

INSERT INTO administrado VALUES ('C9H8O4','Aspirina','500mg',10,1);
INSERT INTO administrado VALUES ('C8H9NO2','Paracetamol','750mg',10,1);
INSERT INTO administrado VALUES ('C9H8O4','Aspirina','500mg',10,2);
INSERT INTO administrado VALUES ('C13H18O2','Ibuprofeno','400mg',30,3);
INSERT INTO administrado VALUES ('C13H18O2','Ibuprofeno','400mg',30,4);

INSERT INTO atendimento VALUES (1,'CRM01','COR01',TIMESTAMP '2026-10-01 09:00:00');
INSERT INTO atendimento VALUES (1,'CRM01','COR01',TIMESTAMP '2026-10-15 10:30:00');
INSERT INTO atendimento VALUES (1,'CRM02','COR02',TIMESTAMP '2026-10-20 14:00:00');
INSERT INTO atendimento VALUES (2,'CRM01','COR02',TIMESTAMP '2026-10-05 08:15:00');
INSERT INTO atendimento VALUES (3,'CRM03','COR03',TIMESTAMP '2026-10-10 11:00:00');
INSERT INTO atendimento VALUES (4,'CRM04','COR03',TIMESTAMP '2026-10-12 16:45:00');
INSERT INTO atendimento VALUES (4,'CRM04','COR04',TIMESTAMP '2026-10-25 09:30:00');

INSERT INTO gerencia VALUES (1,'CRM01');
INSERT INTO gerencia VALUES (2,'CRM03');
INSERT INTO gerencia VALUES (3,'CRM04');

INSERT INTO atua VALUES (1,'COR01');
INSERT INTO atua VALUES (1,'COR02');
INSERT INTO atua VALUES (2,'COR03');
INSERT INTO atua VALUES (3,'COR03');
INSERT INTO atua VALUES (3,'COR04');

INSERT INTO chefia VALUES ('COR02','COR01',DATE '2026-01-10');
INSERT INTO chefia VALUES ('COR03','COR01',DATE '2026-02-15');
INSERT INTO chefia VALUES ('COR04','COR03',DATE '2026-03-20');

COMMIT;
