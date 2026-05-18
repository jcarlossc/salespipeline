<div align="center">

# SalesPipeline

### Pipeline Analítico de Vendas em R

Sistema completo de ETL, métricas, observabilidade e geração de relatórios e dashboard analíticos utilizando arquitetura profissional de package em R.

<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" />
<img src="https://img.shields.io/badge/STATUS-EM%20DESENVOLVIMENTO-success?style=for-the-badge" />
<img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge" />
<img src="https://img.shields.io/badge/TESTS-testthat-orange?style=for-the-badge" />

</div>

## Sobre o Projeto

O **SalesPipeline** é um projeto desenvolvido com foco em:

- Engenharia de Dados
- Analytics
- Boas práticas em R
- Estrutura profissional de package
- Observabilidade e logging
- Relatórios automatizados
- DashBoard
- Qualidade de código

O sistema executa um pipeline completo de processamento de vendas,
transformando dados brutos em métricas estratégicas, relatórios executivos e DashBoard.

---

## Arquitetura do Projeto

```
salespipeline/
|
├── app/
│     └── app.R
├── script_database/
│     └── loja_informatica.sql
├── .gitignore
├── .RData
├── .Rhistory
├── .Rprofile
├── DESCRIPTION
├── inst
|    └── config/
│           ├── config.yaml
│           ├── db.yaml
│           └── logging.yaml
├── salespipeline.Rproj
├── LICENSE
├── logs/
|     └── app.log
├── man/
│     ├── access_data.Rd
│     ├── access_metrics.Rd
│     ├── get_db_connection.Rd
│     ├── get_log_level.Rd
│     ├── handle_error.Rd
│     ├── read_yaml_safe.Rd
│     ├── retry_manual.Rd
│     ├── run_pipeline.Rd
│     ├── safe_run.Rd
|     └── setup_logger.Rd
├── NAMESPACE
├── README.md
├── main/
├── renv/
├── renv.lock
├── reports/
│       ├── vendas.jpg
│       ├── report.pdf
│       └── report.Rmd
├── R/
│   ├── pipeline.R
│   ├── src-access-data_access.R
│   ├── src-db-db_connection.R
│   ├── src-metrics-metrics_access.R
│   ├── utils-error-error_handler.R
│   ├── utils-helper-log_level.R
│   ├── utils-helper-read_yaml.R
│   ├── utils-helper-retry.R
│   ├── utils-helper-safe.R
│   └── utils-loggers-logger.R
└── tests/
      ├── testthat/
      │     ├── test-pipeline.R
      │     ├── test-src-access-data_access.R
      │     ├── test-src-db-db_connection.R
      │     ├── test-src-metrics-metrics_access.R
      │     ├── test-utils-error-error_handler.R
      │     ├── test-utils-helper-log_level.R
      │     ├── test-utils-helper-read_yaml.R
      │     ├── test-utils-helper-retry.R
      │     ├── test-utils-helper-safe.R
      │     └── test-utils-loggers-logger.R
      └── testthat.R
```
