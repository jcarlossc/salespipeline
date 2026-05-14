library(logger)

run_pipeline <- function() {

  safe_run(setup_logger(), "SETUP_LOGGER")

  log_info("Início do Pipeline")

  config_yaml_config <- system.file(
    "config",
    "config.yaml",
    package = "salespipeline"
  )
  config <- read_yaml_safe(config_yaml_config)

  retries <- config$database$retries
  timeout <- config$database$timeout

  con <- safe_run(
    retry_manual(function() get_db_connection(), retries, timeout),
    "DB_CONNECTION"
  )

  on.exit({
    logger::log_info("Encerrando conexão...")
    DBI::dbDisconnect(con)
  }, add = TRUE)

  data_access <- safe_run(access_data(con), "DATA_ACCESS")

  access_metrics <- safe_run(access_metrics(data_access), "ACCESS-METRICS")

  print(access_metrics)

  log_info("Término do Pipeline")
}
