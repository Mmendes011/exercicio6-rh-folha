USE rh_folha;
SET NAMES utf8mb4;

SELECT d.sigla, d.nome AS departamento, COUNT(f.id_funcionario) AS qtd_funcionarios
FROM Departamentos d
LEFT JOIN Funcionarios f ON f.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.sigla, d.nome
ORDER BY d.sigla;

SELECT * FROM vw_funcionarios ORDER BY id_funcionario;

SELECT * FROM vw_folha_pagamento
WHERE mes_referencia = '2026-10'
ORDER BY funcionario;

SELECT d.nome AS departamento,
       SUM(b.valor_mensal) AS custo_beneficios_mes
FROM Funcionario_Beneficio fb
JOIN Beneficios b    ON b.id_beneficio = fb.id_beneficio
JOIN Funcionarios f  ON f.id_funcionario = fb.id_funcionario
JOIN Departamentos d ON d.id_departamento = f.id_departamento
GROUP BY d.nome
ORDER BY custo_beneficios_mes DESC;

SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME,
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'rh_folha'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

SHOW INDEX FROM Funcionarios;
SHOW INDEX FROM Folha_Pagamento;
