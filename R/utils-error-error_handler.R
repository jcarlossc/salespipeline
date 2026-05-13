#' Trata erros de forma centralizada no pipeline
#'
#' Registra informações diagnósticas sobre um erro ocorrido em uma etapa
#' específica do pipeline e interrompe a execução com uma mensagem
#' padronizada.
#'
#' Caso o logger falhe durante o registro, a função utiliza uma saída
#' de fallback via `message()` para preservar o máximo possível do
#' contexto original da falha.
#'
#' @param e Objeto de erro, normalmente uma condition.
#' @param step Identificador da etapa em que a falha ocorreu.
#'
#' @return Esta função não retorna valor. Sempre interrompe a execução.
#'
#' @examples
#' \dontrun{
#' tryCatch(
#'   expr = stop("Falha de leitura"),
#'   error = function(e) handle_error(e, "LOAD_DATA")
#' )
#' }
#'
#' @export
handle_error <- function(e, step = "DESCONHECIDO") {

  # --------------------------------------------------------
  # Extrai uma mensagem uniforme mesmo quando o objeto recebido
  # não é formalmente uma condition.
  # --------------------------------------------------------
  msg <- if (inherits(e, "condition")) e$message else as.character(e)

  tryCatch({

    # --------------------------------------------------------
    # Sinaliza inconsistência de contrato sem perder o erro original.
    # --------------------------------------------------------
    if (!inherits(e, "condition")) {
      log_warn("Objeto recebido não é uma condition")
    }

    log_error(glue("Erro na etapa: {step}"))
    log_error(glue("Mensagem original: {msg}"))

    # --------------------------------------------------------
    # Quando disponível, registra a chamada que originou o erro
    # para facilitar rastreabilidade e debugging.
    # --------------------------------------------------------
    if (inherits(e, "condition") && !is.null(conditionCall(e))) {
      log_debug(glue("Call: {deparse(conditionCall(e))}"))
    }

  }, error = function(log_err) {

    # --------------------------------------------------------
    # Fallback defensivo caso o próprio logger falhe.
    # --------------------------------------------------------
    message("[FALLBACK_LOG] Falha ao registrar no logger")
    message(glue("Detalhe logger: {log_err$message}"))
    message(glue("Erro original: {msg}"))
  })

  # --------------------------------------------------------
  # Marca o encerramento explícito do pipeline antes da
  # interrupção final.
  # --------------------------------------------------------
  log_fatal(glue("Interrompendo execução | etapa={step}"))

  stop(glue(
    "[PIPELINE_ERROR] Etapa: {step} | Mensagem: {msg}"
  ))
}
