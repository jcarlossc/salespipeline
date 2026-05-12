library(testthat)

# -------------------------------------------------------------------
# Deve retornar o resultado normalmente quando não ocorre erro.
# -------------------------------------------------------------------
test_that("safe_run executa expressão com sucesso", {

  result <- safe_run(
    expr = {
      2 + 2
    },
    step = "calculo"
  )

  expect_equal(result, 4)
})

# -------------------------------------------------------------------
# Deve propagar erros gerados durante a execução.
# -------------------------------------------------------------------
test_that("safe_run propaga erros", {

  expect_error(
    safe_run(
      expr = {
        stop("erro de execução")
      },
      step = "transformacao"
    ),
    "erro de execução"
  )
})

# -------------------------------------------------------------------
# Deve capturar warnings sem interromper o fluxo.
# -------------------------------------------------------------------
test_that("safe_run trata warnings", {

  result <- safe_run(
    expr = {
      warning("aviso")
      "ok"
    },
    step = "validacao"
  )

  expect_equal(result, "ok")
})
