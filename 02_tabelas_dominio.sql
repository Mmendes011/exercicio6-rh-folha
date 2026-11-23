USE rh_folha;
SET NAMES utf8mb4;

CREATE TABLE Departamentos (
    id_departamento  INT AUTO_INCREMENT,
    nome             VARCHAR(60) NOT NULL,
    sigla            VARCHAR(10) NOT NULL,
    CONSTRAINT pk_departamentos       PRIMARY KEY (id_departamento),
    CONSTRAINT uq_departamentos_nome  UNIQUE (nome),
    CONSTRAINT uq_departamentos_sigla UNIQUE (sigla)
);

CREATE TABLE Cargos (
    id_cargo  INT AUTO_INCREMENT,
    nome      VARCHAR(60) NOT NULL,
    CONSTRAINT pk_cargos      PRIMARY KEY (id_cargo),
    CONSTRAINT uq_cargos_nome UNIQUE (nome)
);

CREATE TABLE Beneficios (
    id_beneficio  INT AUTO_INCREMENT,
    nome          VARCHAR(60)   NOT NULL,
    valor_mensal  DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_beneficios       PRIMARY KEY (id_beneficio),
    CONSTRAINT uq_beneficios_nome  UNIQUE (nome),
    CONSTRAINT ck_beneficios_valor CHECK (valor_mensal >= 0)
);

INSERT INTO Departamentos (nome, sigla) VALUES
('Tecnologia da Informação', 'TI'),
('Recursos Humanos',         'RH'),
('Financeiro',               'FIN');

INSERT INTO Cargos (nome) VALUES
('Analista de Sistemas'),
('Desenvolvedor'),
('Gerente de TI'),
('Analista de RH'),
('Assistente de RH'),
('Analista Financeiro'),
('Assistente Financeiro');

INSERT INTO Beneficios (nome, valor_mensal) VALUES
('Vale-Refeição',    880.00),
('Vale-Transporte',  220.00),
('Plano de Saúde',   450.00),
('Auxílio Academia', 120.00);
