-- =====================================================================
-- PROJETO HOSPITAL (CIN0019) - ORACLE
-- ARQUIVO 2: consultas (9 tipos x 3 exemplos)
-- Rode o arquivo 1 antes. Pode rodar tudo de uma vez ou uma consulta por vez.
-- =====================================================================

-- #####################################################################
-- 1. GROUP BY / HAVING
-- Coringa: SELECT col_grupo, AGREGACAO(col) FROM t [WHERE ...]
--          GROUP BY col_grupo HAVING AGREGACAO(col) op valor;
-- #####################################################################

-- [G1] Medicos com 2 ou mais atendimentos
SELECT m.nome, COUNT(*) AS qtd_atendimentos
FROM atendimento a JOIN medico m ON m.crm = a.crm
GROUP BY m.crm, m.nome
HAVING COUNT(*) >= 2;

-- [G2] Departamentos com media salarial dos medicos acima de 10000
SELECT d.nome AS departamento, COUNT(*) AS qtd_medicos,
       ROUND(AVG(m.salario), 2) AS salario_medio
FROM medico m JOIN departamento d ON d.idd = m.idd
GROUP BY d.idd, d.nome
HAVING AVG(m.salario) > 10000
ORDER BY salario_medio DESC;

-- [G3] Condicoes que acometem 2 ou mais pacientes
SELECT c.nome AS condicao, COUNT(*) AS qtd_pacientes
FROM condicao c JOIN possui p ON p.id_condicao = c.id_condicao
GROUP BY c.id_condicao, c.nome
HAVING COUNT(*) >= 2
ORDER BY qtd_pacientes DESC, c.nome;

-- #####################################################################
-- 2. JUNCAO INTERNA
-- Coringa: SELECT a.col, b.col FROM ta a INNER JOIN tb b ON a.fk = b.pk;
-- #####################################################################

-- [I1] Atendimentos com paciente, medico e enfermeiro (ternario)
SELECT p.nome AS paciente, m.nome AS medico, e.nome AS enfermeiro, a.dt_atendimento
FROM atendimento a
JOIN paciente_prontuario p ON p.idp = a.idp
JOIN medico m ON m.crm = a.crm
JOIN enfermeiro e ON e.coren = a.coren
ORDER BY a.dt_atendimento;

-- [I2] Medicos e o departamento que gerenciam (1:1)
SELECT m.nome AS medico, d.nome AS departamento_gerenciado
FROM medico m
JOIN gerencia g ON g.crm = m.crm
JOIN departamento d ON d.idd = g.idd;

-- [I3] Paciente, condicao e medicamento administrado (chaves compostas)
SELECT p.nome AS paciente, c.nome AS condicao, md.nome AS medicamento, md.dosagem
FROM administrado ad
JOIN possui ps ON ps.id_condicao = ad.id_condicao AND ps.idp = ad.idp
JOIN paciente_prontuario p ON p.idp = ps.idp
JOIN condicao c ON c.id_condicao = ps.id_condicao
JOIN medicamento md ON md.formula = ad.formula AND md.nome = ad.nome AND md.dosagem = ad.dosagem
ORDER BY p.nome, md.nome;

-- #####################################################################
-- 3. JUNCAO EXTERNA
-- Coringa: SELECT a.col, b.col FROM ta a LEFT [RIGHT|FULL] OUTER JOIN tb b ON a.pk = b.fk;
-- #####################################################################

-- [O1] Todos os departamentos com qtd de leitos (inclusive zero)
SELECT d.nome AS departamento, COUNT(l.idl) AS qtd_leitos
FROM departamento d LEFT JOIN leito l ON l.idd = d.idd
GROUP BY d.idd, d.nome
ORDER BY d.idd;

-- [O2] Todos os medicos, mesmo sem departamento
SELECT m.nome AS medico, COALESCE(d.nome, '(sem departamento)') AS departamento
FROM medico m LEFT JOIN departamento d ON d.idd = m.idd
ORDER BY m.crm;

-- [O3] Enfermeiros e seus chefes (autorrelacionamento)
SELECT e.nome AS enfermeiro, ch.nome AS chefe
FROM enfermeiro e
LEFT JOIN chefia c ON c.coren_chefiado = e.coren
LEFT JOIN enfermeiro ch ON ch.coren = c.coren_chefe
ORDER BY e.coren;

-- [O4 bonus] FULL JOIN: medicos x departamentos (sem par dos dois lados)
SELECT m.nome AS medico, d.nome AS departamento
FROM medico m FULL JOIN departamento d ON d.idd = m.idd;

-- #####################################################################
-- 4. SEMI JUNCAO (EXISTS / IN)
-- Coringa: SELECT a.* FROM ta a WHERE EXISTS (SELECT 1 FROM tb b WHERE b.fk = a.pk);
-- #####################################################################

-- [S1] Medicos que ja realizaram algum atendimento
SELECT m.crm, m.nome
FROM medico m
WHERE EXISTS (SELECT 1 FROM atendimento a WHERE a.crm = m.crm);

-- [S2] Pacientes que possuem ao menos uma condicao
SELECT p.nome
FROM paciente_prontuario p
WHERE p.idp IN (SELECT idp FROM possui);

-- [S3] Enfermeiros que chefiam alguem
SELECT e.nome
FROM enfermeiro e
WHERE EXISTS (SELECT 1 FROM chefia c WHERE c.coren_chefe = e.coren);

-- #####################################################################
-- 5. ANTI-JUNCAO (NOT EXISTS / LEFT JOIN IS NULL / NOT IN)
-- Coringa: SELECT a.* FROM ta a WHERE NOT EXISTS (SELECT 1 FROM tb b WHERE b.fk = a.pk);
-- #####################################################################

-- [A1] Pacientes que nunca foram atendidos (NOT EXISTS)
SELECT p.idp, p.nome
FROM paciente_prontuario p
WHERE NOT EXISTS (SELECT 1 FROM atendimento a WHERE a.idp = p.idp);

-- [A2] Medicamentos nunca administrados (LEFT JOIN + IS NULL)
SELECT md.nome, md.dosagem
FROM medicamento md
LEFT JOIN administrado ad
       ON ad.formula = md.formula AND ad.nome = md.nome AND ad.dosagem = md.dosagem
WHERE ad.formula IS NULL;

-- [A3] Departamentos sem gerente (NOT IN; gerencia.idd e PK, nunca NULL)
SELECT d.nome
FROM departamento d
WHERE d.idd NOT IN (SELECT idd FROM gerencia);

-- #####################################################################
-- 6. SUBCONSULTA ESCALAR (1 linha, 1 coluna)
-- Coringa: SELECT col FROM t WHERE coluna > (SELECT AVG(coluna) FROM t2);
-- #####################################################################

-- [E1] Medicos com salario acima da media geral
SELECT nome, salario
FROM medico
WHERE salario > (SELECT AVG(salario) FROM medico);

-- [E2] Departamentos com qtd de leitos (escalar correlacionada no SELECT)
SELECT d.nome,
       (SELECT COUNT(*) FROM leito l WHERE l.idd = d.idd) AS qtd_leitos
FROM departamento d
ORDER BY d.idd;

-- [E3] Paciente mais velho
SELECT nome, dt_nascimento
FROM paciente_prontuario
WHERE dt_nascimento = (SELECT MIN(dt_nascimento) FROM paciente_prontuario);

-- #####################################################################
-- 7. SUBCONSULTA LINHA (1 linha, varias colunas)
-- Coringa: SELECT * FROM t WHERE (c1, c2) = (SELECT x1, x2 FROM t2 ... FETCH FIRST 1 ROW ONLY);
-- #####################################################################

-- [L1] Medico mais bem pago da Cardiologia (departamento 1)
SELECT crm, nome, idd, salario
FROM medico
WHERE (idd, salario) = (SELECT idd, MAX(salario)
                        FROM medico
                        WHERE idd = 1
                        GROUP BY idd);

-- [L2] O atendimento mais recente (PK composta de 4 colunas)
SELECT *
FROM atendimento
WHERE (idp, crm, coren, dt_atendimento) =
      (SELECT idp, crm, coren, dt_atendimento
       FROM atendimento
       ORDER BY dt_atendimento DESC
       FETCH FIRST 1 ROW ONLY);

-- [L3] O medicamento mais administrado (PK composta de 3 colunas)
SELECT *
FROM medicamento
WHERE (formula, nome, dosagem) =
      (SELECT formula, nome, dosagem
       FROM administrado
       GROUP BY formula, nome, dosagem
       ORDER BY COUNT(*) DESC, nome
       FETCH FIRST 1 ROW ONLY);

-- #####################################################################
-- 8. SUBCONSULTA TABELA (varias linhas: FROM, IN, ANY, ALL)
-- Coringa: FROM (SELECT g, AVG(x) AS m FROM t GROUP BY g) t2   |   WHERE col IN/ >ALL/ >ANY (SELECT ...)
-- #####################################################################

-- [T1] Medicos que ganham acima da media do proprio departamento (tabela derivada)
SELECT m.nome, m.salario, ROUND(t.media_dep, 2) AS media_departamento
FROM medico m
JOIN (SELECT idd, AVG(salario) AS media_dep
      FROM medico
      WHERE idd IS NOT NULL
      GROUP BY idd) t ON t.idd = m.idd
WHERE m.salario > t.media_dep;

-- [T2] Pacientes atendidos por medicos da Cardiologia (IN)
SELECT nome
FROM paciente_prontuario
WHERE idp IN (SELECT a.idp
              FROM atendimento a
              JOIN medico m ON m.crm = a.crm
              JOIN departamento d ON d.idd = m.idd
              WHERE d.nome = 'Cardiologia');

-- [T3] Medicos que ganham mais que TODOS os da Cardiologia (ALL)
SELECT nome, salario
FROM medico
WHERE salario > ALL (SELECT salario FROM medico WHERE idd = 1);

-- [T3b] Enfermeiros que ganham mais que ALGUM plantonista (ANY)
SELECT nome, salario
FROM enfermeiro
WHERE salario > ANY (SELECT salario FROM enfermeiro WHERE tipo_enfermeiro = 'PLANTONISTA');

-- #####################################################################
-- 9. OPERACAO DE CONJUNTO (UNION / INTERSECT / MINUS)
-- Coringa: SELECT cols FROM A  UNION | INTERSECT | MINUS  SELECT cols FROM B;
-- #####################################################################

-- [C1] UNION: todos os profissionais
SELECT nome, cpf, 'MÉDICO' AS papel FROM medico
UNION
SELECT nome, cpf, 'ENFERMEIRO' FROM enfermeiro
ORDER BY nome;

-- [C2] INTERSECT: pacientes atendidos pelo CRM01 e tambem pelo CRM02
SELECT idp FROM atendimento WHERE crm = 'CRM01'
INTERSECT
SELECT idp FROM atendimento WHERE crm = 'CRM02';

-- [C3] MINUS: condicoes cadastradas que nenhum paciente possui
SELECT id_condicao, nome FROM condicao
MINUS
SELECT c.id_condicao, c.nome
FROM condicao c JOIN possui p ON p.id_condicao = c.id_condicao;
