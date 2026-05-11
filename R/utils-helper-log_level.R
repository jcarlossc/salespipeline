library(glue)

get_log_level <- function(level_str) {

  # --------------------------------------------------------
  # Mapeia a configuração textual (ex.: "info", "warn")
  # para as constantes internas usadas pelo logger.
  # --------------------------------------------------------
  levels <- list(
    TRACE = TRACE,
    DEBUG = DEBUG,
    INFO  = INFO,
    WARN  = WARN,
    ERROR = ERROR,
    FATAL = FATAL
  )

  # --------------------------------------------------------
  # Normaliza o valor recebido do YAML ou de entrada externa,
  # evitando falhas por espaços extras ou diferença de maiúsculas.
  # --------------------------------------------------------
  level_key <- toupper(trimws(level_str))

  # --------------------------------------------------------
  # Busca o nível correspondente já normalizado.
  # --------------------------------------------------------
  level <- levels[[level_key]]

  # --------------------------------------------------------
  # Falha quando a configuração é inválida,
  # impedindo que o logger seja iniciado com estado inconsistente.
  # --------------------------------------------------------
  if (is.null(level)) {
    stop(glue("Nível de log inválido: {level_str}"))
  }

  return(level)
}
