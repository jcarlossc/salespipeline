library(logger)
library(glue)
library(yaml)

#' Executa uma função com tentativas de repetição
#'
#' Executa uma função e repete a tentativa em caso de falhas transitórias.
#' Erros de validação são tratados como falhas definitivas e interrompem
#' imediatamente o fluxo.
#'
#' @param func Função sem argumentos a ser executada.
#' @param attempts Número máximo de tentativas.
#' @param wait Tempo de espera, em segundos, entre tentativas.
#'
#' @return O valor retornado por `func`.
#'
#' @details
#' A função reexecuta apenas erros considerados recuperáveis.
#' Se todas as tentativas falharem, o último erro capturado é propagado.
#'
#' @examples
#' \dontrun{
#' retry_manual(
#'   func = function() yaml::read_yaml("config/paths.yaml"),
#'   attempts = 3,
#'   wait = 1
#' )
#' }
#'
#' @export
retry_manual <- function(func, attempts, wait) {

  # --------------------------------------------------------
  # Validação dos parâmetros
  # --------------------------------------------------------
  if (!is.function(func)) {
    stop("Parâmetro 'func' deve ser uma função.")
  }

  if (attempts <= 0) {
    stop("Parâmetro 'attempts' deve ser maior que zero.")
  }

  last_error <- NULL

  # --------------------------------------------------------
  # Loop de tentativas
  # --------------------------------------------------------
  for (i in seq_len(attempts)) {

    # --------------------------------------------------------
    # Execução protegida com tratamento de erro
    # --------------------------------------------------------
    result <- tryCatch(
      func(),
      error = function(e) {

        # --------------------------------------------------------
        # Regra de negócio:
        # Não realizar retry para erros de validação
        # --------------------------------------------------------
        if (grepl("VALIDATION_ERROR", e$message)) {
          stop(e)
        }

        last_error <<- e
        NULL
      }
    )

    if (!is.null(result)) {

      # --------------------------------------------------------
      # Se execução bem-sucedida, retorna resultado
      # --------------------------------------------------------
      return(result)
    }

    if (i < attempts) {
      Sys.sleep(wait)
    }
  }

  if (!is.null(last_error)) {
    stop(last_error)
  }

  # --------------------------------------------------------
  # Se todas as tentativas falharem, lança erro final
  # --------------------------------------------------------
  stop(glue::glue("Falha após {attempts} tentativas"))
}
