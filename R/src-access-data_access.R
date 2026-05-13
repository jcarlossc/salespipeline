library(dplyr)
library(tibble)
library(logger)
library(glue)
library(dbplyr)

#' Carrega e consolida tabelas do banco de dados
#'
#' Realiza a leitura das tabelas configuradas no arquivo
#' `config/config.yaml`, executa joins utilizando `dplyr/dbplyr`
#' e retorna os dados materializados em memória como tibble.
#'
#' A função utiliza execução lazy até a etapa de `collect()`,
#' permitindo que os joins sejam processados diretamente
#' no banco de dados.
#'
#' @param con Conexão ativa com banco de dados via DBI.
#'
#' @return Tibble contendo os dados consolidados.
#'
#' @details
#' Fluxo executado:
#' \itemize{
#'   \item Leitura do arquivo de configuração
#'   \item Identificação das tabelas
#'   \item Criação de tabelas lazy com dbplyr
#'   \item Execução de joins no banco
#'   \item Materialização com collect()
#'   \item Arredondamento de colunas numéricas
#' }
#'
#' @examples
#' \dontrun{
#' con <- get_db_connection()
#' df <- get_tables(con)
#' }
#'
#' @export
access_data <- function(con) {

  log_info("Iniciando carregamento das tabelas")

  tryCatch({

    # -----------------------------------------------------
    # Leitura da configuração
    # -----------------------------------------------------

    config_yaml_config <- system.file(
      "config",
      "config.yaml",
      package = "salespipeline"
    )

    log_debug(
      glue(
        "Arquivo de configuração localizado em: {config_yaml_config}"
      )
    )

    if (!nzchar(config_yaml_config)) {

      log_error("Arquivo config/config.yaml não encontrado")

      stop("Arquivo config/config.yaml não encontrado")
    }

    database_config <- read_yaml_safe(config_yaml_config)

    log_debug("Arquivo de configuração carregado com sucesso")

    # -----------------------------------------------------
    # Identificação das tabelas
    # -----------------------------------------------------

    product_name <- database_config$tables$product
    sales_name <- database_config$tables$sales
    seller_name <- database_config$tables$seller

    log_info(
      glue(
        "Tabelas identificadas: {product_name}, {sales_name}, {seller_name}"
      )
    )

    # -----------------------------------------------------
    # Criação de tabelas lazy
    # -----------------------------------------------------

    product <- tbl(con, product_name)
    sales <- tbl(con, sales_name)
    seller <- tbl(con, seller_name)

    log_debug("Objetos lazy carregados com sucesso")

    # -----------------------------------------------------
    # Construção da query
    # -----------------------------------------------------

    log_debug("Executando joins entre tabelas")

    result <- sales %>%
      inner_join(product, by = "produto_id") %>%
      inner_join(seller, by = "vendedor_id")

    log_debug("Query SQL construída com sucesso")

    # -----------------------------------------------------
    # Materialização dos dados
    # -----------------------------------------------------

    log_debug("Executando collect()")

    result <- result %>%
      collect() %>%
      as_tibble() %>%
      mutate(across(where(is.numeric), ~ round(.x, 2)))

    # -----------------------------------------------------
    # Resultado final
    # -----------------------------------------------------

    log_info(
      glue(
        "Consulta finalizada com {nrow(result)} registros"
      )
    )

    if (nrow(result) == 0) {

      log_warn("A consulta retornou dataset vazio")
    }

    return(result)

  }, error = function(e) {

    handle_error(
      e,
      step = "ACCESS_DATA"
    )

  })
}
