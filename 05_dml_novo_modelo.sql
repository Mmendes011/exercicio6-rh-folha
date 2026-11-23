USE rh_folha;
SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;

CREATE OR REPLACE VIEW vw_funcionarios AS
SELECT f.id_funcionario,
       f.nome,
       f.cpf,
       c.nome  AS cargo,
       d.nome  AS departamento,
       d.sigla AS sigla_departamento,
       GROUP_CONCAT(b.nome ORDER BY b.nome SEPARATOR ', ') AS beneficios,
       f.salario,
       f.data_admissao
FROM Funcionarios f
JOIN Cargos c             ON c.id_cargo = f.id_cargo
JOIN Departamentos d      ON d.id_departamento = f.id_departamento
LEFT JOIN Funcionario_Beneficio fb ON fb.id_funcionario = f.id_funcionario
LEFT JOIN Beneficios b    ON b.id_beneficio = fb.id_beneficio
GROUP BY f.id_funcionario, f.nome, f.cpf, c.nome, d.nome, d.sigla,
         f.salario, f.data_admissao;

CREATE OR REPLACE VIEW vw_folha_pagamento AS
SELECT fp.id_folha,
       fp.mes_referencia,
       f.nome   AS funcionario,
       d.nome   AS departamento,
       fp.salario_base,
       fp.descontos,
       fp.salario_liquido
FROM Folha_Pagamento fp
JOIN Funcionarios f  ON f.id_funcionario = fp.id_funcionario
JOIN Departamentos d ON d.id_departamento = f.id_departamento;

INSERT INTO Funcionarios (nome, cpf, id_cargo, id_departamento, salario, data_admissao)
VALUES ('Marina Costa', '333.444.555-66',
        (SELECT id_cargo        FROM Cargos        WHERE nome  = 'Desenvolvedor'),
        (SELECT id_departamento FROM Departamentos WHERE sigla = 'TI'),
        5000.00, '2026-11-03');

INSERT INTO Funcionario_Beneficio (id_funcionario, id_beneficio)
SELECT f.id_funcionario, b.id_beneficio
FROM Funcionarios f
JOIN Beneficios b ON b.nome IN ('Vale-Refeição', 'Vale-Transporte')
WHERE f.cpf = '333.444.555-66';

UPDATE Funcionarios
SET id_cargo = (SELECT id_cargo FROM Cargos WHERE nome = 'Analista de Sistemas'),
    salario  = 5600.00
WHERE cpf = '456.789.012-34';

UPDATE Beneficios SET valor_mensal = 920.00 WHERE nome = 'Vale-Refeição';

INSERT INTO Folha_Pagamento (id_funcionario, mes_referencia, salario_base, descontos)
SELECT id_funcionario, '2026-11', salario, ROUND(salario * 0.15, 2)
FROM Funcionarios;

SET SQL_SAFE_UPDATES = 1;
