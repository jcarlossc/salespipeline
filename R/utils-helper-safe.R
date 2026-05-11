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
