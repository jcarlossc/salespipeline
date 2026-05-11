library(glue)

#' Converte texto em nível de log
#'
#' Converte uma string em um nível compatível com o pacote
#' \pkg{logger}. O valor recebido é normalizado com remoção
#' de espaços em branco e conversão para maiúsculas.
#'
#' Níveis aceitos:
#' \code{"TRACE"}, \code{"DEBUG"}, \code{"INFO"},
#' \code{"WARN"}, \code{"ERROR"} e \code{"FATAL"}.
#'
#' @param level_str Uma string contendo o nível de log.
#'
#' @return Um objeto de nível de log do pacote
#' \pkg{logger}.
#'
#' @details
#' Se o valor informado não corresponder a um nível válido,
#' a função gera erro.
#'
#' @examples
#' get_log_level("INFO")
#' get_log_level(" debug ")
#'
#' @seealso
#' \code{\link[logger]{log_info}},
#' \code{\link[logger]{log_error}}
#'
#' @export
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
