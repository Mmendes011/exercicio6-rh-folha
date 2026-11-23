USE rh_folha;
SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE Funcionarios RENAME COLUMN id TO id_funcionario;

CREATE TABLE Funcionario_Beneficio (
    id_funcionario  INT NOT NULL,
    id_beneficio    INT NOT NULL,
    CONSTRAINT pk_funcionario_beneficio PRIMARY KEY (id_funcionario, id_beneficio),
    CONSTRAINT fk_fb_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES Funcionarios (id_funcionario) ON DELETE CASCADE,
    CONSTRAINT fk_fb_beneficio   FOREIGN KEY (id_beneficio)
        REFERENCES Beneficios (id_beneficio)
);

CREATE TABLE DePara_Departamento (
    texto_original   VARCHAR(60) PRIMARY KEY,
    id_departamento  INT NOT NULL
);
CREATE TABLE DePara_Cargo (
    texto_original   VARCHAR(60) PRIMARY KEY,
    id_cargo         INT NOT NULL
);
CREATE TABLE DePara_Beneficio (
    texto_original   VARCHAR(60) PRIMARY KEY,
    id_beneficio     INT NOT NULL
);

SET @ti  = (SELECT id_departamento FROM Departamentos WHERE sigla = 'TI');
SET @rh  = (SELECT id_departamento FROM Departamentos WHERE sigla = 'RH');
SET @fin = (SELECT id_departamento FROM Departamentos WHERE sigla = 'FIN');

INSERT INTO DePara_Departamento (texto_original, id_departamento) VALUES
('TI', @ti), ('T.I.', @ti), ('TECNOLOGIA', @ti), ('TECNOLOGIA DA INFORMAÇÃO', @ti),
('RH', @rh), ('R.H.', @rh), ('RECURSOS HUMANOS', @rh),
('FINANCEIRO', @fin), ('FINANÇAS', @fin);

SET @c_sistemas  = (SELECT id_cargo FROM Cargos WHERE nome = 'Analista de Sistemas');
SET @c_dev       = (SELECT id_cargo FROM Cargos WHERE nome = 'Desenvolvedor');
SET @c_gerente   = (SELECT id_cargo FROM Cargos WHERE nome = 'Gerente de TI');
SET @c_anl_rh    = (SELECT id_cargo FROM Cargos WHERE nome = 'Analista de RH');
SET @c_ass_rh    = (SELECT id_cargo FROM Cargos WHERE nome = 'Assistente de RH');
SET @c_anl_fin   = (SELECT id_cargo FROM Cargos WHERE nome = 'Analista Financeiro');
SET @c_ass_fin   = (SELECT id_cargo FROM Cargos WHERE nome = 'Assistente Financeiro');

INSERT INTO DePara_Cargo (texto_original, id_cargo) VALUES
('ANALISTA DE SISTEMAS', @c_sistemas),
('DESENVOLVEDOR', @c_dev), ('DEV', @c_dev),
('GERENTE DE TI', @c_gerente),
('ANALISTA DE RH', @c_anl_rh), ('ANALISTA RH', @c_anl_rh),
('ASSISTENTE DE RH', @c_ass_rh),
('ANALISTA FINANCEIRO', @c_anl_fin),
('ASSISTENTE FINANCEIRO', @c_ass_fin);

SET @b_vr       = (SELECT id_beneficio FROM Beneficios WHERE nome = 'Vale-Refeição');
SET @b_vt       = (SELECT id_beneficio FROM Beneficios WHERE nome = 'Vale-Transporte');
SET @b_saude    = (SELECT id_beneficio FROM Beneficios WHERE nome = 'Plano de Saúde');
SET @b_academia = (SELECT id_beneficio FROM Beneficios WHERE nome = 'Auxílio Academia');

INSERT INTO DePara_Beneficio (texto_original, id_beneficio) VALUES
('VR', @b_vr), ('VALE REFEIÇÃO', @b_vr), ('VALE-REFEIÇÃO', @b_vr),
('VT', @b_vt), ('VALE TRANSPORTE', @b_vt), ('VALE-TRANSPORTE', @b_vt),
('PLANO DE SAÚDE', @b_saude),
('ACADEMIA', @b_academia), ('AUXÍLIO ACADEMIA', @b_academia);

ALTER TABLE Funcionarios
    ADD COLUMN id_cargo        INT NULL AFTER cpf,
    ADD COLUMN id_departamento INT NULL AFTER id_cargo;

UPDATE Funcionarios f
JOIN DePara_Departamento dp ON dp.texto_original = UPPER(TRIM(f.departamento))
SET f.id_departamento = dp.id_departamento;

UPDATE Funcionarios f
JOIN DePara_Cargo dp ON dp.texto_original = UPPER(TRIM(f.cargo))
SET f.id_cargo = dp.id_cargo;

INSERT INTO Funcionario_Beneficio (id_funcionario, id_beneficio)
SELECT DISTINCT f.id_funcionario, dp.id_beneficio
FROM Funcionarios f
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
      UNION ALL SELECT 4 UNION ALL SELECT 5) seq
  ON seq.n <= 1 + LENGTH(REPLACE(f.beneficios, ';', ','))
               - LENGTH(REPLACE(REPLACE(f.beneficios, ';', ','), ',', ''))
JOIN DePara_Beneficio dp
  ON dp.texto_original = UPPER(TRIM(
         SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(f.beneficios, ';', ','), ',', seq.n), ',', -1)
     ));

SELECT id_funcionario, nome, departamento AS sem_departamento_mapeado
FROM Funcionarios WHERE id_departamento IS NULL;

SELECT id_funcionario, nome, cargo AS sem_cargo_mapeado
FROM Funcionarios WHERE id_cargo IS NULL;

SELECT f.id_funcionario, f.nome, f.beneficios AS beneficio_sem_mapeamento
FROM Funcionarios f
WHERE (1 + LENGTH(REPLACE(f.beneficios, ';', ','))
          - LENGTH(REPLACE(REPLACE(f.beneficios, ';', ','), ',', '')))
      <> (SELECT COUNT(*) FROM Funcionario_Beneficio fb
          WHERE fb.id_funcionario = f.id_funcionario);

SET SQL_SAFE_UPDATES = 1;
