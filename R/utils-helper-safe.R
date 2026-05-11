
safe_run <- function(expr, step) {
  tryCatch(
    expr,
    error = function(e) {

      # --------------------------------------------------------
      # Registra o erro com contexto operacional da etapa
      # antes de propagar a falha para o fluxo principal.
      # --------------------------------------------------------
      logger::log_error(glue::glue("Erro na etapa [{step}]: {e$message}"))
      stop(e)
    },
    warning = function(w) {

      # --------------------------------------------------------
      # Warnings são registrados para rastreabilidade,
      # mas não interrompem a execução do pipeline.
      # --------------------------------------------------------
      logger::log_warn(glue::glue("Aviso na etapa [{step}]: {w$message}"))
      invokeRestart("muffleWarning")
    }
  )
}
