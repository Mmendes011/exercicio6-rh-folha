SET NAMES utf8mb4;

DROP DATABASE IF EXISTS rh_folha;
CREATE DATABASE rh_folha
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE rh_folha;

CREATE TABLE Funcionarios (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(100),
    cpf            VARCHAR(14),
    cargo          VARCHAR(50),
    departamento   VARCHAR(50),
    beneficios     VARCHAR(200),
    salario        DECIMAL(10,2),
    data_admissao  DATE
);

CREATE TABLE Folha_Pagamento (
    funcionario_id    INT,
    nome_funcionario  VARCHAR(100),
    departamento      VARCHAR(50),
    mes_referencia    CHAR(7),
    salario_base      DECIMAL(10,2),
    descontos         DECIMAL(10,2),
    salario_liquido   DECIMAL(10,2)
);

INSERT INTO Funcionarios (nome, cpf, cargo, departamento, beneficios, salario, data_admissao) VALUES
('Ana Souza',       '123.456.789-01', 'Analista de Sistemas',  'TI',                       'VR, VT, Plano de Saúde',          6500.00, '2021-03-15'),
('Bruno Lima',      '234.567.890-12', 'Analista de sistemas',  'T.I.',                     'VR; Plano de Saude',              6300.00, '2022-07-01'),
('Carla Mendes',    '345.678.901-23', 'Desenvolvedor',         'Tecnologia',               'Vale Refeição, VT',               5200.00, '2023-01-10'),
('Diego Rocha',     '456.789.012-34', 'Dev',                   'ti ',                      'VR,VT',                           4800.00, '2024-02-05'),
('Eduarda Alves',   '567.890.123-45', 'Gerente de TI',         'Tecnologia da Informação', 'VR, Plano de Saúde, Academia',    12500.00, '2019-09-23'),
('Felipe Castro',   '678.901.234-56', 'Analista de RH',        'RH',                       'VR, VT',                          4200.00, '2020-05-18'),
('Gabriela Nunes',  '789.012.345-67', 'Analista RH',           'R.H.',                     'vale transporte; VR',             4100.00, '2023-08-14'),
('Henrique Dias',   '890.123.456-78', 'Assistente de RH',      'Recursos Humanos',         'VT',                              2900.00, '2024-11-04'),
('Isabela Freitas', '901.234.567-89', 'Analista Financeiro',   'Financeiro',               'VR, VT, Plano de Saúde',          5600.00, '2021-10-11'),
('João Pereira',    '012.345.678-90', 'Analista financeiro',   'Finanças',                 'VR',                              5400.00, '2022-12-01'),
('Karina Lopes',    '111.222.333-44', 'Assistente Financeiro', 'financeiro',               'Vale-Refeição; Vale-Transporte',  3100.00, '2025-04-07'),
('Lucas Martins',   '222.333.444-55', 'Desenvolvedor',         'TI',                       'VR, VT, Plano de Saúde, Academia', 5900.00, '2023-05-22');

INSERT INTO Folha_Pagamento
    (funcionario_id, nome_funcionario, departamento, mes_referencia, salario_base, descontos, salario_liquido) VALUES
( 1, 'Ana S. Souza',    'TI',               '2026-10',  6500.00, 1410.00, 5090.00),
( 2, 'Bruno Lima',      'T.I.',             '2026-10',  6300.00, 1352.00, 4948.00),
( 3, 'Carla Mendes',    'Tecnologia',       '2026-10',  5200.00, 1020.00, 4180.00),
( 4, 'Diego Rocha',     'TI',               '2026-10',  4800.00,  900.00, 3900.00),
( 5, 'Eduarda Alves',   'TI',               '2026-10', 12500.00, 3150.00, 9350.00),
( 6, 'Felipe Castro',   'RH',               '2026-10',  4200.00,  720.00, 3480.00),
( 7, 'Gabriela Nunes',  'RH',               '2026-10',  4100.00,  700.00, 3400.00),
( 8, 'Henrique Dias',   'Recursos Humanos', '2026-10',  2900.00,  380.00, 2520.00),
( 9, 'Isabela Freitas', 'Financeiro',       '2026-10',  5600.00, 1080.00, 4520.00),
(10, 'João Pereira',    'Financeiro',       '2026-10',  5400.00, 1030.00, 4370.00),
(11, 'Karina Lopes',    'Finanças',         '2026-10',  3100.00,  420.00, 2860.00),
(12, 'Lucas Martins',   'TI',               '2026-10',  5900.00, 1190.00, 4710.00);

SELECT departamento, COUNT(*) AS qtd_funcionarios
FROM Funcionarios
GROUP BY departamento
ORDER BY departamento;
