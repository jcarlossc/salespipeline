library(dplyr)
library(glue)
library(logger)

#' Calcula métricas comerciais e indicadores de vendas
#'
#' Recebe um data.frame consolidado de vendas e calcula
#' indicadores estratégicos para análise comercial,
#' incluindo KPIs gerais, métricas por vendedor
#' e métricas por produto.
#'
#' A função retorna estruturas prontas para utilização
#' em dashboards, relatórios analíticos e aplicações Shiny.
#'
#' @param df Data frame contendo os dados de vendas.
#'
#' @return
#' Uma lista contendo:
#' \itemize{
#'   \item status: status da execução
#'   \item mensagem: mensagem descritiva
#'   \item kpis: indicadores gerais
#'   \item by_seller: métricas agregadas por vendedor
#'   \item by_product: métricas agregadas por produto
#' }
#'
#' @details
#' As seguintes métricas são calculadas:
#' \itemize{
#'   \item faturamento
#'   \item custo total
#'   \item lucro
#'   \item ticket médio
#'   \item quantidade de produtos
#'   \item quantidade de vendedores
#' }
#'
#' @examples
#' \dontrun{
#' result <- access_metrics(df_sales)
#'
#' result$kpis
#' result$by_seller
#' }
#'
#' @seealso
#' \code{\link{access_data}}
#'
#' @export
access_metrics <- function(df) {

  log_info("Iniciando cálculo de métricas")

  tryCatch({

    # ------------------------------------------------------------------
    # Validação de entrada
    # ------------------------------------------------------------------

    log_debug("Validando estrutura do data.frame")

    if (!is.data.frame(df)) {

      log_error("Objeto informado não é um data.frame")

      stop("O objeto informado não é um data.frame.")
    }

    colunas_necessarias <- c(
      "vendas_id",
      "data_venda",
      "quantidade_vendida",
      "produto_id",
      "vendedor_id",
      "produto",
      "valor_compra",
      "valor_venda",
      "vendedor"
    )

    faltando <- setdiff(
      colunas_necessarias,
      names(df)
    )

    if (length(faltando) > 0) {

      log_error(
        glue(
          "Colunas ausentes: {paste(faltando, collapse = ', ')}"
        )
      )

      stop(
        glue(
          "Colunas ausentes: {paste(faltando, collapse = ', ')}"
        )
      )
    }

    if (nrow(df) == 0) {

      log_warn("Data frame recebido está vazio")

      stop("O data.frame está vazio.")
    }

    # ------------------------------------------------------------------
    # Preparação das métricas financeiras
    # ------------------------------------------------------------------

    log_debug("Calculando métricas financeiras")

    df_metrics <- df %>%
      mutate(
        faturamento = quantidade_vendida * valor_venda,
        custo_total = quantidade_vendida * valor_compra,
        lucro = faturamento - custo_total
      )

    # ------------------------------------------------------------------
    # KPIs principais
    # ------------------------------------------------------------------

    log_debug("Calculando KPIs gerais")

    kpis <- df_metrics %>%
      summarise(
        total_vendas = n(),
        total_itens_vendidos = sum(
          quantidade_vendida,
          na.rm = TRUE
        ),
        faturamento_total = sum(
          faturamento,
          na.rm = TRUE
        ),
        custo_total = sum(
          custo_total,
          na.rm = TRUE
        ),
        lucro_total = sum(
          lucro,
          na.rm = TRUE
        ),
        ticket_medio = mean(
          faturamento,
          na.rm = TRUE
        ),
        qtd_produtos = n_distinct(produto_id),
        qtd_vendedores = n_distinct(vendedor_id)
      )

    # ------------------------------------------------------------------
    # Métricas por vendedor
    # ------------------------------------------------------------------

    log_debug("Calculando métricas por vendedor")

    by_seller <- df_metrics %>%
      group_by(vendedor_id, vendedor) %>%
      summarise(
        vendas = n(),
        itens_vendidos = sum(
          quantidade_vendida,
          na.rm = TRUE
        ),
        faturamento = sum(
          faturamento,
          na.rm = TRUE
        ),
        lucro = sum(
          lucro,
          na.rm = TRUE
        ),
        .groups = "drop"
      ) %>%
      arrange(desc(faturamento))

    # ------------------------------------------------------------------
    # Métricas por produto
    # ------------------------------------------------------------------

    log_debug("Calculando métricas por produto")

    by_product <- df_metrics %>%
      group_by(produto_id, produto) %>%
      summarise(
        vendas = n(),
        itens_vendidos = sum(
          quantidade_vendida,
          na.rm = TRUE
        ),
        faturamento = sum(
          faturamento,
          na.rm = TRUE
        ),
        lucro = sum(
          lucro,
          na.rm = TRUE
        ),
        .groups = "drop"
      ) %>%
      arrange(desc(faturamento))

    log_info("Métricas calculadas com sucesso")

    # ------------------------------------------------------------------
    # Retorno final
    # ------------------------------------------------------------------

    list(
      status = "sucesso",
      mensagem = "Métricas calculadas com sucesso.",
      kpis = kpis,
      by_seller = by_seller,
      by_product = by_product
    )

  }, error = function(e) {

    handle_error(
      e,
      step = "ACCESS_METRICS"
    )

  })
}
