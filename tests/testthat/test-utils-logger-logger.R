library(testthat)

# -------------------------------------------------------------------
# Deve executar configuração sem lançar erro.
# -------------------------------------------------------------------
test_that("setup_logger executa sem erro", {

  expect_no_error(
    setup_logger()
  )
})

# -------------------------------------------------------------------
# Deve criar diretório de logs quando inexistente.
# -------------------------------------------------------------------
test_that("setup_logger cria diretório automaticamente", {

  temp_dir <- tempfile()

  expect_false(dir.exists(temp_dir))

  dir.create(temp_dir)

  expect_true(dir.exists(temp_dir))
})

# -------------------------------------------------------------------
# Deve configurar timezone do processo.
# -------------------------------------------------------------------
test_that("setup_logger define timezone", {

  setup_logger()

  expect_true(
    nzchar(Sys.getenv("TZ"))
  )
})

# -------------------------------------------------------------------
# Deve falhar quando configuração YAML é inválida.
# -------------------------------------------------------------------
test_that("setup_logger falha para configuração inválida", {

  expect_error(
    get_log_level("INVALIDO"),
    "Nível de log inválido"
  )
})
