df_mock <- data.frame(
  vendas_id = 1:2,
  data_venda = as.Date(c("2025-01-01", "2025-01-02")),
  quantidade_vendida = c(2, 3),
  produto_id = c(1, 2),
  vendedor_id = c(10, 20),
  produto = c("Notebook", "Mouse"),
  valor_compra = c(1000, 50),
  valor_venda = c(1500, 100),
  vendedor = c("Carlos", "Maria")
)

test_that("access_metrics retorna lista", {

  # --------------------------------------------------------
  # Execução
  # --------------------------------------------------------

  result <- access_metrics(df_mock)

  # --------------------------------------------------------
  # Validação
  # --------------------------------------------------------

  expect_type(result, "list")

})

test_that("access_metrics retorna KPIs", {

  # --------------------------------------------------------
  # Execução
  # --------------------------------------------------------

  result <- access_metrics(df_mock)

  # --------------------------------------------------------
  # Estrutura esperada
  # --------------------------------------------------------

  expect_true("kpis" %in% names(result))

})

test_that("access_metrics calcula faturamento corretamente", {

  # --------------------------------------------------------
  # Execução
  # --------------------------------------------------------

  result <- access_metrics(df_mock)

  # --------------------------------------------------------
  # Validação financeira
  # --------------------------------------------------------

  expect_equal(
    result$kpis$faturamento_total,
    3300
  )

})

test_that("access_metrics falha com data.frame vazio", {

  # --------------------------------------------------------
  # Data frame vazio
  # --------------------------------------------------------

  df_empty <- df_mock[0, ]

  # --------------------------------------------------------
  # Validação
  # --------------------------------------------------------

  expect_error(
    access_metrics(df_empty),
    "data.frame está vazio"
  )

})

test_that("access_metrics valida colunas obrigatórias", {

  # --------------------------------------------------------
  # Remoção de coluna obrigatória
  # --------------------------------------------------------

  df_invalid <- df_mock %>%
    select(-produto)

  # --------------------------------------------------------
  # Validação
  # --------------------------------------------------------

  expect_error(
    access_metrics(df_invalid),
    "Colunas ausentes"
  )

})
