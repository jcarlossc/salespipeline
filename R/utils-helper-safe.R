#' Executa uma expressão com tratamento padronizado de erros e avisos
#'
#' Avalia uma expressão registrando mensagens de erro e warning
#' associadas a uma etapa específica do pipeline.
#'
#' Em caso de erro, o evento é registrado e a execução é interrompida.
#' Em caso de warning, o evento é registrado e o warning é suprimido,
#' permitindo a continuidade do fluxo.
#'
#' @param expr Expressão a ser avaliada.
#' @param step Identificador da etapa atual do processo.
#'
#' @return O valor resultante da avaliação de `expr`.
#'
#' @examples
#' \dontrun{
#' config <- safe_run(
#'   yaml::read_yaml("config/paths.yaml"),
#'   "LOAD_CONFIG"
#' )
#' }
#'
#' @export
safe_run <- function(expr, step) {

  withCallingHandlers(

    tryCatch(

      # --------------------------------------------------------
      # Avalia a expressão no ambiente do chamador,
      # preservando variáveis e contexto externo.
      # --------------------------------------------------------
      eval(substitute(expr), parent.frame()),

      error = function(e) {

        # --------------------------------------------------------
        # Registra erros com identificação da etapa
        # para facilitar rastreabilidade operacional.
        # --------------------------------------------------------
        logger::log_error(
          glue::glue("Erro na etapa [{step}]: {e$message}")
        )

        # --------------------------------------------------------
        # Propaga o erro original para interromper
        # o fluxo e permitir tratamento externo.
        # --------------------------------------------------------
        stop(e)
      }
    ),

    warning = function(w) {

      # --------------------------------------------------------
      # Registra warnings sem interromper a execução,
      # permitindo monitoramento do pipeline.
      # --------------------------------------------------------
      logger::log_warn(
        glue::glue("Aviso na etapa [{step}]: {w$message}")
      )

      # --------------------------------------------------------
      # Suprime a exibição padrão do warning após
      # o registro no logger, evitando duplicidade.
      # --------------------------------------------------------
      invokeRestart("muffleWarning")
    }
  )
}
