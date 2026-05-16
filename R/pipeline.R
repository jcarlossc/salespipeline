library(logger)

#' Executa o pipeline principal da aplicação
#'
#' Esta função executa o fluxo completo do pipeline de dados:
#'
#' 1. Configuração do logger
#' 2. Leitura do arquivo de configuração
#' 3. Conexão com banco de dados
#' 4. Extração dos dados
#' 5. Processamento das métricas
#' 6. Encerramento seguro da conexão
#'
#' Todas as etapas críticas são protegidas por `safe_run()`
#' para garantir tratamento padronizado de erros.
#'
#' @details
#' O número de tentativas de conexão (`retries`) e o tempo
#' entre tentativas (`timeout`) são carregados do arquivo:
#'
#' `inst/config/config.yaml`
#'
#' A conexão com banco é encerrada automaticamente via `on.exit()`.
#'
#' @return
#' Retorna invisivelmente um `data.frame` ou `tibble`
#' contendo as métricas calculadas.
#'
#' @seealso
#' \code{\link{safe_run}}
#' \code{\link{retry_manual}}
#' \code{\link{access_data}}
#' \code{\link{access_metrics}}
#'
#' @examples
#' \dontrun{
#' result <- run_pipeline()
#'
#' print(result)
#' }
#'
#' @export
run_pipeline <- function() {

  tryCatch({

    # --------------------------------------------------------------------------
    # Inicialização do logger
    # --------------------------------------------------------------------------
    safe_run(setup_logger(), "SETUP_LOGGER")

    log_info("Início do Pipeline")

    # --------------------------------------------------------------------------
    # Leitura das configurações do sistema
    # --------------------------------------------------------------------------
    log_debug("Lendo arquivo config.yaml")

    config_yaml_config <- system.file(
      "config",
      "config.yaml",
      package = "salespipeline"
    )

    config <- read_yaml_safe(config_yaml_config)

    retries <- config$database$retries
    timeout <- config$database$timeout

    log_debug(
      paste(
        "Configurações carregadas:",
        "retries =", retries,
        "| timeout =", timeout
      )
    )

    # --------------------------------------------------------------------------
    # Conexão com banco de dados
    # --------------------------------------------------------------------------
    log_info("Realizando conexão com banco de dados")

    con <- safe_run(
      retry_manual(
        function() get_db_connection(),
        retries,
        timeout
      ),
      "DB_CONNECTION"
    )

    # --------------------------------------------------------------------------
    # Garante encerramento da conexão
    # --------------------------------------------------------------------------
    on.exit({

      log_info("Encerrando conexão com banco")

      tryCatch({

        DBI::dbDisconnect(con)

        log_info("Conexão encerrada com sucesso")

      }, error = function(e) {

        log_error(
          paste(
            "Erro ao encerrar conexão:",
            e$message
          )
        )

      })

    }, add = TRUE)

    # --------------------------------------------------------------------------
    # Extração dos dados
    # --------------------------------------------------------------------------
    log_info("Iniciando extração de dados")

    data_access <- safe_run(
      access_data(con),
      "DATA_ACCESS"
    )

    log_info("Extração de dados concluída")

    # --------------------------------------------------------------------------
    # Processamento das métricas
    # --------------------------------------------------------------------------
    log_info("Calculando métricas")

    access_metrics_result <- safe_run(
      access_metrics(data_access),
      "ACCESS_METRICS"
    )

    log_info("Métricas calculadas com sucesso")

    log_info("Pipeline executado com sucesso")

    invisible(access_metrics_result)

  }, error = function(e) {

    # --------------------------------------------------------------------------
    # Tratamento global de erro
    # --------------------------------------------------------------------------
    handle_error(
      e,
      step = "PIPELINE"
    )

  })

}
