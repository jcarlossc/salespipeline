library(logger)
library(glue)
library(yaml)

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
