# Exercício 6 – Sprint Ágil de Refatoração de Banco de Dados

**Turma:** 1CDD1
**Cenário 11:** Sistema de RH e Folha de Pagamento
**Dupla:**

| Integrante | Papel |
| --- | --- |
| Murilo Mendes | Product Owner / Revisor |
| Felipe Mira | Scrum Master / Desenvolvedor |

**Quadro Kanban (Trello):** _(colar o link aqui)_

## O problema

Cargos, departamentos e benefícios eram digitados à mão na tabela `Funcionarios`,
sem tabela de domínio. O mesmo departamento aparecia como "TI", "T.I.", "ti ",
"Tecnologia" e "Tecnologia da Informação". Os benefícios ficavam todos em uma
coluna só ("VR, VT; Plano de Saúde"). A `Folha_Pagamento` não tinha chave
primária nem estrangeira, repetia nome e departamento e guardava o salário
líquido digitado à mão.

## A solução

| Antes (2 tabelas) | Depois (6 tabelas + 2 views) |
| --- | --- |
| `Funcionarios` com cargo, departamento e benefícios em texto | `Departamentos`, `Cargos`, `Beneficios` (tabelas de domínio) |
| `Folha_Pagamento` sem PK/FK e com dados repetidos | `Funcionarios` ligada por FK a cargo e departamento |
| | `Funcionario_Beneficio` (relação N:N) |
| | `Folha_Pagamento` com PK, FK, `UNIQUE (funcionário, mês)` e líquido calculado |
| | `vw_funcionarios` e `vw_folha_pagamento` (formato antigo para relatórios) |

## Scripts (rodar nesta ordem)

| Arquivo | O que faz | User stories |
| --- | --- | --- |
| `01_legado.sql` | Cria o banco `rh_folha` como ele era, com os dados problemáticos | T01 |
| `02_tabelas_dominio.sql` | Cria `Departamentos`, `Cargos` e `Beneficios` com os valores oficiais | US01, US02, US03 |
| `03_migracao_dados.sql` | Converte cada grafia antiga no ID oficial (tabelas DE-PARA) e separa os benefícios | US03, US04 |
| `04_refatoracao_estrutura.sql` | Chaves estrangeiras, índices, CPF único, folha sem redundância, líquido calculado | US05, US06 |
| `05_dml_novo_modelo.sql` | Views de compatibilidade e exemplos de INSERT/UPDATE no novo modelo | US07 |
| `06_validacao.sql` | Consultas que conferem o resultado | US08 |

### Como executar

**MySQL Workbench:** abra cada arquivo (File → Open SQL Script) e execute com o
raio ⚡, na ordem 01 → 06.

**Terminal:**

```bash
mysql -u root -p < 01_legado.sql
mysql -u root -p < 02_tabelas_dominio.sql
mysql -u root -p < 03_migracao_dados.sql
mysql -u root -p < 04_refatoracao_estrutura.sql
mysql -u root -p < 05_dml_novo_modelo.sql
mysql -u root -p < 06_validacao.sql
```

Testado do zero em banco limpo. Requer MySQL 8.0.16 ou mais novo (por causa do `CHECK`).

## Como trabalhamos (Git)

- Uma branch por etapa (`feature/...`), nada direto na `main`.
- Todo merge passa por Pull Request revisado pelo outro integrante.
- Antes de aprovar, o revisor roda os scripts em banco limpo e confere se as
  consultas de conferência do script 03 voltam vazias.
