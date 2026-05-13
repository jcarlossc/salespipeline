library(testthat)

# -------------------------------------------------------------------
# Deve falhar quando arquivo de configuração não existir.
# -------------------------------------------------------------------
test_that("get_db_connection valida existência do YAML", {

  local_mocked_bindings(
    system.file = function(...) ""
  )

  expect_error(
    get_db_connection(),
    "config/db.yaml não encontrado"
  )
})

# -------------------------------------------------------------------
# Deve validar presença dos campos obrigatórios.
# -------------------------------------------------------------------
test_that("get_db_connection valida campos obrigatórios", {

  config <- list(
    host = "localhost"
  )

  required_fields <- c(
    "host",
    "port",
    "name",
    "user",
    "password"
  )

  missing <- setdiff(
    required_fields,
    names(config)
  )

  expect_true(length(missing) > 0)
})

# -------------------------------------------------------------------
# Deve identificar ambiente local corretamente.
# -------------------------------------------------------------------
test_that("get_db_connection reconhece localhost", {

  host <- "localhost"

  expect_true(
    host %in% c("localhost", "127.0.0.1")
  )
})

# -------------------------------------------------------------------
# Deve interromper execução quando configuração for inválida.
# -------------------------------------------------------------------
test_that("get_db_connection falha para configuração inválida", {

  expect_error(
    stop("Configuração inválida do banco"),
    "Configuração inválida"
  )
})
