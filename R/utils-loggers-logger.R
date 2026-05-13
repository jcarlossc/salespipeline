library(glue)
library(yaml)
library(logger)

#' Configura o sistema centralizado de logging
#'
#' Inicializa o logger do pipeline utilizando configurações
#' definidas em arquivo YAML.
#'
#' A função:
#' - carrega configurações de logging;
#' - cria diretórios automaticamente quando necessário;
#' - configura nível de log, timezone e layout;
#' - habilita saída em arquivo e console;
#' - define comportamento append/overwrite;
#' - registra logs de inicialização e falha.
#'
#' @return Invisivelmente `NULL`.
#'
#' @details
#' O arquivo `logging.yaml` deve estar disponível em:
#'
#' `inst/config/logging.yaml`
#'
#' @examples
#' \dontrun{
#' setup_logger()
#' }
#'
#' @importFrom glue glue
#' @importFrom yaml read_yaml
#' @importFrom logger log_info log_warn log_error
#' @export
setup_logger <- function() {

  tryCatch({

    config_logging <- system.file(
      "config",
      "logging.yaml",
      package = "salespipeline"
    )

    logging_config <- read_yaml_safe(config_logging)

    log_path <- logging_config$logs$file

    if (!dir.exists(dirname(log_path))) {
      message("Diretório de logs não existe. Criando automaticamente.")
      dir.create(dirname(log_path), recursive = TRUE, showWarnings = FALSE)
    }

    level <- get_log_level(logging_config$logging$level)

    logger::log_threshold(level)

    Sys.setenv(TZ = logging_config$format$timezone)

    logger::log_layout(
      logger::layout_glue_generator(
        format = logging_config$format$format
      )
    )

    append_mode <- !isTRUE(logging_config$logging$overwrite)

    if (!append_mode) {
      log_warn("Logs serão sobrescritos a cada execução (overwrite = TRUE)")
    } else {
      log_trace("Modo append ativado (logs acumulativos)")
    }

    appender <- logger::appender_file(
      log_path,
      append = append_mode
    )

    if (isTRUE(logging_config$logging$console)) {
      logger::log_appender(function(lines) {
        logger::appender_console(lines)
        logger::appender_file(log_path, append = append_mode)(lines)
      })

    } else {

      logger::log_appender(
        logger::appender_file(log_path, append = append_mode)
      )
    }
  }, error = function(e) {

    # -----------------------------------------------------
    # Tratamento de erro
    # -----------------------------------------------------
    log_error(glue("Erro ao configurar logger: {e$message}"))

    log_fatal("Falha crítica na inicialização do logger")

    stop(e$message)

  })
}
