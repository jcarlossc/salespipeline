library(mockery)
library(RSQLite)

test_that("access_data retorna tibble", {

  # Conexão temporária SQLite
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

  # Tabelas de teste
  DBI::dbWriteTable(
    con,
    "product",
    data.frame(
      produto_id = 1,
      produto = "Notebook"
    )
  )

  DBI::dbWriteTable(
    con,
    "sales",
    data.frame(
      produto_id = 1,
      vendedor_id = 10,
      valor = 1000
    )
  )

  DBI::dbWriteTable(
    con,
    "seller",
    data.frame(
      vendedor_id = 10,
      vendedor = "Carlos"
    )
  )

  # Mock da configuração
  mockery::stub(
    access_data,
    "read_yaml_safe",
    list(
      tables = list(
        product = "product",
        sales = "sales",
        seller = "seller"
      )
    )
  )

  result <- access_data(con)

  expect_s3_class(result, "tbl_df")

  DBI::dbDisconnect(con)

})
