

run_pipeline <- function() {

  safe_run(setup_logger(), "SETUP_LOGGER")

  log_info("Pipeline iniciado")

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
}
