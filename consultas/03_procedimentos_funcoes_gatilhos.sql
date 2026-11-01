-- =====================================================================
-- PROJETO HOSPITAL (CIN0019) - ORACLE
-- ARQUIVO 3: procedimentos, funcoes e gatilhos (PL/SQL)
-- Rode o arquivo 1 antes. Cada bloco PL/SQL termina com "/" sozinho na linha.
-- Se usar SQL*Plus ou SQL Developer, rode antes: SET SERVEROUTPUT ON
-- =====================================================================

-- ---- limpeza (Oracle 23ai) ----
DROP FUNCTION IF EXISTS fn_pacientes_do_medico;
DROP TYPE IF EXISTS t_paciente_atend_tab FORCE;
DROP TYPE IF EXISTS t_paciente_atend FORCE;

-- #####################################################################
-- PROCEDIMENTOS (executados com BEGIN nome(...); END;)
-- Coringa:
--   CREATE OR REPLACE PROCEDURE nome(p1 IN tipo, p2 IN tipo) AS
--     v_var tipo;
--   BEGIN
--     INSERT/UPDATE/DELETE/SELECT ... INTO v_var ... (usando p1, p2);
--   END;
--   /
-- #####################################################################

-- [P1] Registrar um atendimento (INSERT com validacao)
CREATE OR REPLACE PROCEDURE sp_registrar_atendimento(
  p_idp   IN NUMBER,
  p_crm   IN VARCHAR2,
  p_coren IN VARCHAR2,
  p_dt    IN TIMESTAMP DEFAULT SYSTIMESTAMP)
AS
  v_qtd NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_qtd FROM paciente_prontuario WHERE idp = p_idp;
  IF v_qtd = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Prontuário ' || p_idp || ' não existe');
  END IF;
  INSERT INTO atendimento (idp, crm, coren, dt_atendimento)
  VALUES (p_idp, p_crm, p_coren, p_dt);
  DBMS_OUTPUT.PUT_LINE('Atendimento registrado para o prontuário ' || p_idp);
END;
/

-- [P2] Reajustar o salario de todos os medicos de um departamento (UPDATE)
CREATE OR REPLACE PROCEDURE sp_reajustar_salario_departamento(
  p_idd        IN NUMBER,
  p_percentual IN NUMBER)
AS
BEGIN
  UPDATE medico
     SET salario = ROUND(salario * (1 + p_percentual / 100), 2)
   WHERE idd = p_idd;
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' médico(s) reajustado(s) em ' || p_percentual || '%');
END;
/

-- [P3] Prescrever medicamento a um par paciente-condicao (valida a FK composta)
CREATE OR REPLACE PROCEDURE sp_prescrever_medicamento(
  p_idp         IN NUMBER,
  p_id_condicao IN NUMBER,
  p_formula     IN VARCHAR2,
  p_nome        IN VARCHAR2,
  p_dosagem     IN VARCHAR2)
AS
  v_qtd NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_qtd FROM possui
   WHERE idp = p_idp AND id_condicao = p_id_condicao;
  IF v_qtd = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'O prontuário ' || p_idp || ' não possui a condição ' || p_id_condicao);
  END IF;
  INSERT INTO administrado (formula, nome, dosagem, id_condicao, idp)
  VALUES (p_formula, p_nome, p_dosagem, p_id_condicao, p_idp);
END;
/

-- ---- chamadas dos procedimentos ----
BEGIN
  sp_registrar_atendimento(5, 'CRM02', 'COR01', TIMESTAMP '2026-10-30 10:00:00');
END;
/

BEGIN
  sp_reajustar_salario_departamento(1, 10);
END;
/

SELECT nome, salario FROM medico WHERE idd = 1 ORDER BY crm;   -- Ana 16500, Bruno 13200

BEGIN
  sp_prescrever_medicamento(2, 10, 'C8H9NO2', 'Paracetamol', '750mg');   -- OK
END;
/

BEGIN   -- erro esperado: paciente 2 nao possui a condicao 20
  sp_prescrever_medicamento(2, 20, 'C8H9NO2', 'Paracetamol', '750mg');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERRO ESPERADO: ' || SQLERRM);
END;
/

-- #####################################################################
-- FUNCOES (usadas dentro de SELECT)
-- Coringa:
--   CREATE OR REPLACE FUNCTION nome(p1 IN tipo) RETURN tipo_retorno AS
--     v_res tipo_retorno;
--   BEGIN
--     SELECT AGREGACAO(col) INTO v_res FROM t WHERE chave = p1;
--     RETURN v_res;
--   END;
--   /
--   SELECT nome(valor) FROM DUAL;
-- #####################################################################

-- [F1] Quantidade de atendimentos de um medico
CREATE OR REPLACE FUNCTION fn_qtd_atendimentos_medico(p_crm IN VARCHAR2)
RETURN NUMBER
AS
  v_qtd NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_qtd FROM atendimento WHERE crm = p_crm;
  RETURN v_qtd;
END;
/

-- [F2] Idade de um paciente em anos completos
CREATE OR REPLACE FUNCTION fn_idade_paciente(p_idp IN NUMBER)
RETURN NUMBER
AS
  v_idade NUMBER;
BEGIN
  SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, dt_nascimento) / 12)
    INTO v_idade
    FROM paciente_prontuario
   WHERE idp = p_idp;
  RETURN v_idade;
END;
/

-- [F3] Pacientes atendidos por um medico (retorna TABELA: precisa de tipos)
CREATE OR REPLACE TYPE t_paciente_atend AS OBJECT (
  id_paciente      NUMBER,
  nome_paciente    VARCHAR2(80),
  qtd_atendimentos NUMBER
);
/

CREATE OR REPLACE TYPE t_paciente_atend_tab AS TABLE OF t_paciente_atend;
/

CREATE OR REPLACE FUNCTION fn_pacientes_do_medico(p_crm IN VARCHAR2)
RETURN t_paciente_atend_tab
AS
  v_res t_paciente_atend_tab;
BEGIN
  SELECT t_paciente_atend(p.idp, p.nome, COUNT(*))
    BULK COLLECT INTO v_res
    FROM atendimento a
    JOIN paciente_prontuario p ON p.idp = a.idp
   WHERE a.crm = p_crm
   GROUP BY p.idp, p.nome;
  RETURN v_res;
END;
/

-- ---- chamadas das funcoes ----
SELECT fn_qtd_atendimentos_medico('CRM01') AS qtd FROM DUAL;                       -- 3
SELECT nome, fn_qtd_atendimentos_medico(crm) AS qtd FROM medico ORDER BY crm;      -- 3,2,1,2,0
SELECT nome, fn_idade_paciente(idp) AS idade FROM paciente_prontuario ORDER BY idp;
SELECT * FROM TABLE(fn_pacientes_do_medico('CRM01'));                              -- Joao 2, Maria 1

-- #####################################################################
-- GATILHOS
-- Coringa:
--   CREATE OR REPLACE TRIGGER trg_nome
--   {BEFORE | AFTER} {INSERT | UPDATE [OF col] | DELETE} ON tabela
--   FOR EACH ROW
--   [WHEN (condicao usando OLD/NEW, SEM dois-pontos)]
--   [DECLARE ...]
--   BEGIN
--     -- dentro do corpo: :OLD.col e :NEW.col (COM dois-pontos)
--     RAISE_APPLICATION_ERROR(-20xxx, 'mensagem');
--   END;
--   /
-- #####################################################################

-- [TR1] BEFORE UPDATE: o salario do medico nao pode diminuir
CREATE OR REPLACE TRIGGER trg_medico_salario_nao_diminui
BEFORE UPDATE OF salario ON medico
FOR EACH ROW
WHEN (NEW.salario < OLD.salario)
BEGIN
  RAISE_APPLICATION_ERROR(-20010,
    'Salário não pode diminuir (de ' || :OLD.salario || ' para ' || :NEW.salario || ')');
END;
/

BEGIN   -- erro esperado
  UPDATE medico SET salario = salario - 1000 WHERE crm = 'CRM04';
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERRO ESPERADO: ' || SQLERRM);
END;
/

UPDATE medico SET salario = salario + 500 WHERE crm = 'CRM04';   -- permitido
SELECT crm, salario FROM medico WHERE crm = 'CRM04';              -- 9500

-- [TR2] AFTER UPDATE: auditoria de mudanca de salario do enfermeiro
CREATE TABLE log_salario_enfermeiro (
  id_log          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  coren           VARCHAR2(10) NOT NULL,
  salario_antigo  NUMBER(10,2),
  salario_novo    NUMBER(10,2),
  dt_alteracao    TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE OR REPLACE TRIGGER trg_enfermeiro_audita_salario
AFTER UPDATE OF salario ON enfermeiro
FOR EACH ROW
WHEN (OLD.salario <> NEW.salario)
BEGIN
  INSERT INTO log_salario_enfermeiro (coren, salario_antigo, salario_novo)
  VALUES (:OLD.coren, :OLD.salario, :NEW.salario);
END;
/

UPDATE enfermeiro SET salario = 4200 WHERE coren = 'COR02';
UPDATE enfermeiro SET salario = 4200 WHERE coren = 'COR02';   -- mesmo valor: nao gera log
SELECT coren, salario_antigo, salario_novo FROM log_salario_enfermeiro;   -- 1 linha

-- [TR3] BEFORE INSERT/UPDATE: o gerente de um departamento deve ser lotado nele
--       (consulta outra tabela, MEDICO, entao nao ha problema de tabela mutante)
CREATE OR REPLACE TRIGGER trg_gerencia_gerente_lotado
BEFORE INSERT OR UPDATE ON gerencia
FOR EACH ROW
DECLARE
  v_idd NUMBER;
BEGIN
  SELECT idd INTO v_idd FROM medico WHERE crm = :NEW.crm;
  IF v_idd IS NULL OR v_idd <> :NEW.idd THEN
    RAISE_APPLICATION_ERROR(-20011,
      'O médico ' || :NEW.crm || ' não está lotado no departamento ' || :NEW.idd);
  END IF;
END;
/

BEGIN   -- erro esperado: CRM05 (Elisa) nao tem departamento
  INSERT INTO gerencia VALUES (4, 'CRM05');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERRO ESPERADO: ' || SQLERRM);
END;
/

-- NOTA sobre participacao total (todo prontuario ter >= 1 atendimento):
-- o PostgreSQL resolve com CONSTRAINT TRIGGER adiado (esta no guia). No Oracle nao existe
-- gatilho adiado ate o COMMIT; a solucao usual e um PROCEDIMENTO que insere o prontuario
-- e o primeiro atendimento na mesma transacao (controle na transacao, como o
-- projeto_logico.md ja preve).
