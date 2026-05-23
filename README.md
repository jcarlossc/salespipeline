<div align="center">

# SalesPipeline

### Pipeline Analítico de Vendas em R

Sistema completo de ETL, métricas, observabilidade e geração de relatórios e dashboard analíticos utilizando arquitetura profissional de package em R.

<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" />
<img src="https://img.shields.io/badge/STATUS-EM%20DESENVOLVIMENTO-success?style=for-the-badge" />
<img src="https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge" />
<img src="https://img.shields.io/badge/TESTS-testthat-orange?style=for-the-badge" />

</div>

---

## Imagens 
Relatório:
<table>
  <tr>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_01.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_02.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_03.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_04.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_05.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_06.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_07.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_08.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_09.png" alt="Imagem Relatório" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/report/report_10.png" alt="Imagem Relatório" width="200"/> </td>
  </tr>
</table>
DashBoard:
<table>
  <tr>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/dashboard/dashboard_01.png" alt="Imagem DashBoard" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/dashboard/dashboard_02.png" alt="Imagem DashBoard" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/dashboard/dashboard_03.png" alt="Imagem DashBoard" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/dashboard/dashboard_04.png" alt="Imagem DashBoard" width="200"/> </td>
    <td><img src="https://github.com/jcarlossc/salespipeline/blob/main/images/dashboard/dashboard_05.png" alt="Imagem DashBoard" width="200"/> </td>
  </tr>
</table>


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

## Estrutura do Projeto

⚠️Observação: os projetos em linguagem R se diferenciam de outras linguagens no que diz respeito à estrutura de diretórios. Em linguagens como Python ou Php, por exemplo, modulariza-se o sistema, geralmente, por intermédio de diretórios, por exemplo: utils, src, db, logger, helpers, entre outros. No R, entretanto, é mais indicado manter as funções principais em um único diretório chamado 'R'. Este estilo de construção é chamado 'package', ou seja, é construído como um pacote da linguagem R. Com isso, além de muitos outros benefícios, a aplicação pode ser documentada (documentação dinâmica com roxygen2) e testada (testes unitários com testthat) com maior consistência. 
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
│       ├── report_sales_pipeline.pdf
│       └── report_sales_pipeline.Rmd
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

## Arquitetura do Projeto

```
          ┌──────────────────┐
          │   Banco de Dados │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │   Access Layer   │
          │  access_data()   │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │ Business Metrics │
          │access_metrics()  │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │   Reporting      │
          │ RMarkdown / PDF  │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │    DashBoard     │
          │  Shiny / html    │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │ Logs + Monitoring│
          └──────────────────┘
```

## Stack Tecnológica

| Tecnologia | Finalidade |
|---|---|
| R | Linguagem principal |
| dplyr | Manipulação de dados |
| ggplot2 | Visualização |
| logger | Logging |
| rmarkdown | Relatórios |
| testthat | Testes |
| yaml | Configuração |
| glue | Mensagens dinâmicas |
| devtools | Desenvolvimento |
| roxygen2 | Documentação |
| testthat | Testes unitários |
| RStudio | IDE |
| RMySQL | Driver MySQL |
| shiny | DashBoard |
| apache | Servidor |
| MariaDB | Banco de Dados |

## Observabilidade

O projeto possui logging estruturado com rastreamento completo da execução.

### Exemplo de log
```
[2026-05-18 22:23:35.180915] INFO - Início do Pipeline
[2026-05-18 22:23:35.20733] DEBUG - Lendo arquivo config.yaml
[2026-05-18 22:23:35.272283] DEBUG - Configurações carregadas: retries = 3 | timeout = 5
[2026-05-18 22:23:35.28029] INFO - Realizando conexão com banco de dados
[2026-05-18 22:23:35.291884] INFO - Iniciando conexão com banco de dados
[2026-05-18 22:23:35.32901] DEBUG - Arquivo de configuração localizado em: C:/workspace/r/salespipeline/inst/config/db.yaml
[2026-05-18 22:23:35.375257] DEBUG - Configuração do banco carregada com sucesso
[2026-05-18 22:23:35.393164] DEBUG - Validação de configuração concluída
[2026-05-18 22:23:35.407017] INFO - Conectando em ambiente local (localhost)
[2026-05-18 22:23:36.096705] DEBUG - Abrindo conexão MySQL em localhost:3306
```

## Diferenciais do Projeto

* Arquitetura desacoplada (pipeline vs relatório vs dashboard)
* Implementação de retentativas (retry) 
* Tratamento de error
* Automação completa da análise
* Código organizado e escalável
* Foco em insight de negócio, não apenas código

## Documentação

- `roxygen2`
- Documentação Dinâmica

## Testes Automatizados

- `testthat`
- Cobertura de regras de negócio
- Validações estruturais
- Testes unitários

## Modo de Utilização

⚠️Observação: aplicações em R, ou em outras linguagens, que utilizam banco de dados e APIs, nunca é recomendado deixar senhas diretamente no código (hardcoded password). Neste projeto, por motivos didáticos (para facilitar a reprodução), o arquivo de senha do Banco de Dados está no arquivo YAML, mas essa abordagem é extremamente desaprovada. Para maior segurança, segue uma pequena lista de recursos de segurança em linguagem R:
* ✅ usar .Renviron
* ✅ usar {keyring}
* ✅ usar HTTPS em APIs
* ✅ usar tokens temporários
* ✅ usar .gitignore
* ✅ rotacionar senhas<br>

Evite:
* ❌ senha hardcoded
* ❌ subir credenciais no GitHub
* ❌ compartilhar .Renviron
* ❌ usar senha fraca
* ❌ expor logs com credenciais

### 1. Execute o XAMPP
* Caso não o tenha, baixe-o: <a href="https://www.apachefriends.org/pt_br/download.html">https://www.apachefriends.org/pt_br/download.html</a>
* Instale-o normalmente
* Execute o Painel de Controle
* Acione o Apache e o MySQL/MariaDB
* Ao lado do botão start/stop do MySQL/MariaDB, clique em Admin. Isso irá abrir a interface do MySQL/MariaDB no navegador
* Clique na aba importar e em escolher arquivo: o script está na raiz do projeto: ```script_database/loja_informatica.sql```, após isso, clique em importar no final da página
* O banco de Dados está com usuário ```root``` e senha vazia. O arquivo de configuração está em: ```config/db.yaml```

### 2. Clone o repositório e acesse o diretório
```
git clone https://github.com/jcarlossc/salespipeline.git
cd salespipeline
```
### 3. Restaure as dependências:
```
renv::restore()
```
### 4. Gerar relatório PDF:
* Acesse o arquivo do relatótio: ```salespipeline/reports/report.Rmd``` e clique no botão ```Knit```
* Ou, simplesmente, no console, digite: ```rmarkdown::render("reports/report_sales_pipeline.Rmd")```
* Qualquer um desses procedimentos vai gerar um relatório em PDF

### 5. Gerar DashBoard interativo:
* Acesse o arquivo do DashBoard: ```salespipeline/app/app.R``` e clique no botão ```Run App```
* Ou, no console, digite: ```shiny::runApp("app")```
* Após abertura de uma janela com o DashBoard, existe um botão na parte superior que, caso queira, o DashBoard poderá ser visualizado também no navegador. 

## Licença
Este projeto está licenciado sob MIT License.

## Desenvolvedor focado em:

- Data Engineering
- Analytics
- R Programming
- Python Programming
- Automação de processos
- Engenharia de Software

## Contato
* Autor: Carlos da Costa
* Recife, PE - Brasil
* Telefone: +55 81 99712 9140
* Telegram: @jcarlossc
* Blogger linguagem R: https://informaticus77-r.blogspot.com/
* Blogger linguagem Python: https://informaticus77-python.blogspot.com/
* Email: jcarlossc1977@gmail.com
* LinkedIn: https://www.linkedin.com/in/carlos-da-costa-669252149/
* GitHub: https://github.com/jcarlossc
* Kaggle: https://www.kaggle.com/jcarlossc/
* Twitter/X: https://x.com/jcarlossc1977
