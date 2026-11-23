USE rh_folha;
SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE Funcionarios
    MODIFY nome             VARCHAR(100)  NOT NULL,
    MODIFY cpf              CHAR(14)      NOT NULL,
    MODIFY id_cargo         INT           NOT NULL,
    MODIFY id_departamento  INT           NOT NULL,
    MODIFY salario          DECIMAL(10,2) NOT NULL,
    MODIFY data_admissao    DATE          NOT NULL;

ALTER TABLE Funcionarios
    DROP COLUMN cargo,
    DROP COLUMN departamento,
    DROP COLUMN beneficios;

CREATE INDEX idx_funcionarios_cargo        ON Funcionarios (id_cargo);
CREATE INDEX idx_funcionarios_departamento ON Funcionarios (id_departamento);
CREATE INDEX idx_funcionarios_nome         ON Funcionarios (nome);

ALTER TABLE Funcionarios
    ADD CONSTRAINT uq_funcionarios_cpf     UNIQUE (cpf),
    ADD CONSTRAINT ck_funcionarios_salario CHECK (salario > 0);

ALTER TABLE Funcionarios
    ADD CONSTRAINT fk_funcionarios_cargo
        FOREIGN KEY (id_cargo) REFERENCES Cargos (id_cargo);

ALTER TABLE Funcionarios
    ADD CONSTRAINT fk_funcionarios_departamento
        FOREIGN KEY (id_departamento) REFERENCES Departamentos (id_departamento);

SELECT funcionario_id, nome_funcionario, salario_base, descontos,
       salario_liquido               AS liquido_digitado,
       salario_base - descontos      AS liquido_correto
FROM Folha_Pagamento
WHERE salario_liquido <> salario_base - descontos;

ALTER TABLE Folha_Pagamento
    ADD COLUMN id_folha INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE Folha_Pagamento RENAME COLUMN funcionario_id TO id_funcionario;

ALTER TABLE Folha_Pagamento
    DROP COLUMN nome_funcionario,
    DROP COLUMN departamento;

ALTER TABLE Folha_Pagamento
    MODIFY id_funcionario  INT           NOT NULL,
    MODIFY mes_referencia  CHAR(7)       NOT NULL,
    MODIFY salario_base    DECIMAL(10,2) NOT NULL,
    MODIFY descontos       DECIMAL(10,2) NOT NULL DEFAULT 0;

ALTER TABLE Folha_Pagamento DROP COLUMN salario_liquido;
ALTER TABLE Folha_Pagamento
    ADD COLUMN salario_liquido DECIMAL(10,2)
        GENERATED ALWAYS AS (salario_base - descontos) STORED;

ALTER TABLE Folha_Pagamento
    ADD CONSTRAINT uq_folha_funcionario_mes UNIQUE (id_funcionario, mes_referencia),
    ADD CONSTRAINT ck_folha_valores
        CHECK (salario_base > 0 AND descontos >= 0 AND descontos <= salario_base);

ALTER TABLE Folha_Pagamento
    ADD CONSTRAINT fk_folha_funcionario
        FOREIGN KEY (id_funcionario) REFERENCES Funcionarios (id_funcionario);

CREATE INDEX idx_folha_mes ON Folha_Pagamento (mes_referencia);

DROP TABLE DePara_Departamento;
DROP TABLE DePara_Cargo;
DROP TABLE DePara_Beneficio;

SET SQL_SAFE_UPDATES = 1;
