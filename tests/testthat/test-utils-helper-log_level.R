library(logger)

# -------------------------------------------------------------------
# Testa o mapeamento de níveis de log válidos.
# Garante que entradas conhecidas sejam convertidas corretamente
# para as constantes exportadas pelo pacote logger.
# -------------------------------------------------------------------
test_that("get_log_level retorna nível válido", {
  expect_equal(get_log_level("INFO"), INFO)
  expect_equal(get_log_level("DEBUG"), DEBUG)
  expect_equal(get_log_level("ERROR"), ERROR)
})

# -------------------------------------------------------------------
# Testa a normalização de entrada.
# Verifica se espaços em branco e diferenças de caixa
# (maiúsculas/minúsculas) não afetam a interpretação do nível.
# -------------------------------------------------------------------
test_that("get_log_level ignora espaços e caixa", {
  expect_equal(get_log_level(" info "), INFO)
  expect_equal(get_log_level(" warn "), WARN)
  expect_equal(get_log_level(" fatal "), FATAL)
})

# -------------------------------------------------------------------
# Testa o tratamento de erro para entradas inválidas.
# Confirma que valores não reconhecidos disparam erro
# com mensagem adequada para diagnóstico.
# -------------------------------------------------------------------
test_that("get_log_level falha para nível inválido", {
  expect_error(
    get_log_level("abacate"),
    "Nível de log inválido"
  )
})
