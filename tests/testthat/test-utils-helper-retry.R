library(testthat)

# -------------------------------------------------------------------
# Deve retornar imediatamente quando a função executa com sucesso
# já na primeira tentativa.
# -------------------------------------------------------------------
test_that("retry_manual retorna resultado quando a função tem sucesso na primeira tentativa", {

  # Função sempre bem-sucedida
  fn <- function() "ok"

  result <- retry_manual(
    func = fn,
    attempts = 3,
    wait = 0
  )

  expect_equal(result, "ok")
})

# -------------------------------------------------------------------
# Deve repetir a execução após falhas transitórias
# até que a função finalmente tenha sucesso.
# -------------------------------------------------------------------
test_that("retry_manual realiza novas tentativas até obter sucesso", {

  # Contador para simular falha inicial seguida de sucesso
  counter <- 0

  fn <- function() {
    counter <<- counter + 1

    if (counter < 3) {
      stop("erro temporário")
    }

    "ok"
  }

  result <- retry_manual(
    func = fn,
    attempts = 5,
    wait = 0
  )

  # Deve retornar sucesso após retries
  expect_equal(result, "ok")

  # Deve ter executado exatamente 3 vezes
  expect_equal(counter, 3)
})

# -------------------------------------------------------------------
# Deve propagar o último erro quando todas as tentativas falham.
# -------------------------------------------------------------------
test_that("retry_manual falha após esgotar todas as tentativas", {

  # Função que falha sempre
  fn <- function() {
    stop("erro persistente")
  }

  expect_error(
    retry_manual(
      func = fn,
      attempts = 3,
      wait = 0
    ),
    "erro persistente"
  )
})

# -------------------------------------------------------------------
# Erros de validação são considerados não recuperáveis
# e não devem disparar novas tentativas.
# -------------------------------------------------------------------
test_that("retry_manual não realiza retry para erro de validação", {

  # Contador para verificar se não houve novas tentativas
  counter <- 0

  fn <- function() {
    counter <<- counter + 1
    stop("VALIDATION_ERROR: dado inválido")
  }

  expect_error(
    retry_manual(
      func = fn,
      attempts = 5,
      wait = 0
    ),
    "VALIDATION_ERROR"
  )

  # Deve interromper imediatamente
  expect_equal(counter, 1)
})

# -------------------------------------------------------------------
# Deve rejeitar entradas inválidas para o argumento 'func'.
# -------------------------------------------------------------------
test_that("retry_manual valida argumento func", {

  expect_error(
    retry_manual(
      func = 123,
      attempts = 3,
      wait = 0
    ),
    "deve ser uma função"
  )
})

# -------------------------------------------------------------------
# Deve rejeitar número de tentativas menor ou igual a zero.
# -------------------------------------------------------------------
test_that("retry_manual valida argumento attempts", {

  fn <- function() "ok"

  expect_error(
    retry_manual(
      func = fn,
      attempts = 0,
      wait = 0
    ),
    "maior que zero"
  )
})
