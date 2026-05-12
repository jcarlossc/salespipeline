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
