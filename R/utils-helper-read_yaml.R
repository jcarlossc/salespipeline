library(glue)
library(yaml)

read_yaml_safe <- function(path) {

  if (!file.exists(path)) {
    stop(glue::glue("Arquivo não encontrado: {path}"))
  }

  tryCatch(
    yaml::read_yaml(path),

    error = function(e) {
      stop(glue::glue("Erro ao ler YAML: {e$message}"))
    }
  )
}
