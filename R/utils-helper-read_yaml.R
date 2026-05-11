library(glue)
library(yaml)

#' Lê um arquivo YAML com validação básica
#'
#' Faz a leitura de um arquivo YAML garantindo que o caminho exista
#' antes da leitura e retornando uma mensagem de erro mais clara
#' quando o parsing falha.
#'
#' @param path Caminho do arquivo YAML.
#'
#' @return Uma lista R contendo o conteúdo do arquivo YAML.
#'
#' @examples
#' \dontrun{
#' read_yaml_safe("config/paths.yaml")
#' }
#'
#' @export
read_yaml_safe <- function(path) {

  # ----------------------------------------------------
  # Validação de entrada
  # ----------------------------------------------------
  if (!file.exists(path)) {
    stop(glue::glue("Arquivo não encontrado: {path}"))
  }

  tryCatch(

    # ----------------------------------------------------
    # Lê arquivo yaml e retorna lista
    # ----------------------------------------------------
    yaml::read_yaml(path),

    # ----------------------------------------------------
    # Falha quando o YAML está inválido
    # ----------------------------------------------------
    error = function(e) {
      stop(glue::glue("Erro ao ler YAML: {e$message}"))
    }
  )
}
