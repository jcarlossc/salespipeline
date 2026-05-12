library(testthat)

# -------------------------------------------------------------------
# Deve interromper a execução com mensagem padronizada.
# -------------------------------------------------------------------
test_that("handle_error propaga erro padronizado", {

  err <- simpleError("falha na carga")

  expect_error(
    handle_error(err, step = "carga"),
    "\\[PIPELINE_ERROR\\]"
  )
})

# -------------------------------------------------------------------
# Deve incluir o nome da etapa na mensagem final.
# -------------------------------------------------------------------
test_that("handle_error inclui etapa na mensagem", {

  err <- simpleError("arquivo inválido")

  expect_error(
    handle_error(err, step = "validacao"),
    "validacao"
  )
})

# -------------------------------------------------------------------
# Deve tratar objetos que não são conditions.
# -------------------------------------------------------------------
test_that("handle_error trata objetos simples", {

  expect_error(
    handle_error("erro manual", step = "etl"),
    "erro manual"
  )
})

# -------------------------------------------------------------------
# Deve manter a mensagem original do erro.
# -------------------------------------------------------------------
test_that("handle_error preserva mensagem original", {

  err <- simpleError("conexão recusada")

  expect_error(
    handle_error(err, step = "api"),
    "conexão recusada"
  )
})
