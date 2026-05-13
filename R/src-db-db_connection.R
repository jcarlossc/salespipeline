library(DBI)
library(RMySQL)
library(yaml)
library(logger)
library(glue)

#' Cria conexão com banco de dados MySQL
#'
#' Realiza a leitura das configurações de banco definidas
#' em arquivo YAML e estabelece conexão utilizando DBI.
#'
#' A função:
#' - valida existência do arquivo de configuração;
#' - verifica campos obrigatórios;
#' - registra logs operacionais;
#' - cria conexão MySQL via DBI/RMySQL;
#' - trata falhas críticas de conexão.
#'
#' @return Objeto de conexão DBI.
#'
#' @details
#' O arquivo de configuração deve existir em:
#'
#' `inst/config/db.yaml`
#'
#' Campos obrigatórios:
#' - host
#' - port
#' - name
#' - user
#' - password
#'
#' @examples
#' \dontrun{
#' con <- get_db_connection()
#'
#' DBI::dbGetQuery(con, "SELECT 1")
#'
#' DBI::dbDisconnect(con)
#' }
#'
#' @importFrom glue glue
#' @importFrom DBI dbConnect
#'
#' @export
get_db_connection <- function() {
  tryCatch({

    log_trace("Início da função get_db_connection()")

    config_yaml_db <- system.file(
      "config",
      "db.yaml",
      package = "salespipeline"
    )

    if (!nzchar(config_yaml_db)) {
      stop("Arquivo config/db.yaml não encontrado")
    }

    db_config <- read_yaml_safe(config_yaml_db)$db

    #db_config <- read_yaml_safe("db.yaml")

    required_fields <- c("host", "port", "name", "user", "password")

    missing <- setdiff(required_fields, names(db_config))

    if (length(missing) > 0) {
      log_error(
        glue("Campos ausentes no config: {paste(missing, collapse = ', ')}")
      )
      stop("Configuração inválida do banco")
    }

    if (db_config$host %in% c("localhost", "127.0.0.1")) {
      log_info("Conectando em ambiente local (localhost)")
    }

    con <- DBI::dbConnect(
      RMySQL::MySQL(),
      host = db_config$host,
      port = db_config$port,
      dbname = db_config$name,
      user = db_config$user,
      password = db_config$password
    )

    log_debug("dbConnect executado sem erro")

    # -----------------------------------------------------
    # Log de sucesso
    # -----------------------------------------------------
    log_info("Conexão estabelecida com sucesso")

    log_trace("Fim da função get_db_connection()")

    return(con)

  }, error = function(e) {

    # -----------------------------------------------------
    # Tratamento de erro
    # -----------------------------------------------------
    log_error(glue("Erro na conexão: {e$message}"))

    log_fatal("Falha crítica ao conectar ao banco")

    stop(glue("Erro ao conectar ao banco: {e$message}"))

  })
}

