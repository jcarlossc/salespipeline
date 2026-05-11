# ------------------------------------------------------------------
# Deve ler corretamente um arquivo YAML válido e retornar
# a estrutura esperada como lista R.
# ------------------------------------------------------------------
test_that("read_yaml_safe lê YAML válido", {

  path <- tempfile(fileext = ".yaml")

  writeLines(
    c(
      "logs:",
      "  file: logs/app.log"
    ),
    path
  )

  out <- read_yaml_safe(path)

  expect_type(out, "list")
  expect_equal(out$logs$file, "logs/app.log")
})

# ------------------------------------------------------------------
# Deve falhar quando o arquivo informado não existir.
# ------------------------------------------------------------------
test_that("read_yaml_safe falha quando arquivo não existe", {

  expect_error(
    read_yaml_safe("arquivo_inexistente.yaml"),
    "Arquivo não encontrado"
  )
})

# ------------------------------------------------------------------
# Deve falhar quando o arquivo informado não existir.
# ------------------------------------------------------------------
test_that("read_yaml_safe falha com YAML inválido", {

  path <- tempfile(fileext = ".yaml")

  writeLines(
    c(
      "logs:",
      "  file: ["
    ),
    path
  )

  expect_error(
    read_yaml_safe(path),
    "Erro ao ler YAML"
  )
})
