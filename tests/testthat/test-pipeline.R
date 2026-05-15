library(testthat)
library(DBI)
library(RSQLite)

test_that("run_pipeline executa com sucesso", {

  local_mocked_bindings(

    setup_logger = function() NULL,

    safe_run = function(expr, step) {
      expr
    },

    read_yaml_safe = function(path) {

      list(
        database = list(
          retries = 3,
          timeout = 1
        )
      )

    },

    retry_manual = function(fun, retries, timeout) {
      fun()
    },

    get_db_connection = function() {

      DBI::dbConnect(
        RSQLite::SQLite(),
        ":memory:"
      )

    },

    access_data = function(con) {

      data.frame(
        vendas = c(100, 200, 300)
      )

    },

    access_metrics = function(df) {

      data.frame(
        total = sum(df$vendas)
      )

    },

    handle_error = function(e, step) {
      stop(e)
    }

  )

  result <- run_pipeline()

  expect_true(is.data.frame(result))

  expect_equal(result$total, 600)

})
