library(dplyr)
library(glue)

access_metrics <- function(df) {

  tryCatch({

    # ------------------------------------------------------------------
    # Validação de entrada
    # ------------------------------------------------------------------
    if (!is.data.frame(df)) {
      stop("O objeto informado não é um data.frame.")
    }

    colunas_necessarias <- c(
      "vendas_id", "data_venda", "quantidade_vendida", "produto_id",
      "vendedor_id", "produto", "valor_compra", "valor_venda",
      "vendedor"
    )

    faltando <- setdiff(colunas_necessarias, names(df))

    if (length(faltando) > 0) {
      stop(glue(
        "Colunas ausentes: {paste(faltando, collapse = ', ')}"
      ))
    }

    if (nrow(df) == 0) {
      stop("O data.frame está vazio.")
    }

    # ------------------------------------------------------------------
    # Preparação das métricas
    # ------------------------------------------------------------------
    df_metrics <- df %>%
      mutate(
        faturamento = quantidade_vendida * valor_venda,
        custo_total = quantidade_vendida * valor_compra,
        lucro = faturamento - custo_total
      )

    # ------------------------------------------------------------------
    # Indicadores principais (ótimo para valueBox / KPIs)
    # ------------------------------------------------------------------
    kpis <- df_metrics %>%
      summarise(
        total_vendas = n(),
        total_itens_vendidos = sum(quantidade_vendida, na.rm = TRUE),
        faturamento_total = sum(faturamento, na.rm = TRUE),
        custo_total = sum(custo_total, na.rm = TRUE),
        lucro_total = sum(lucro, na.rm = TRUE),
        ticket_medio = mean(faturamento, na.rm = TRUE),
        qtd_produtos = n_distinct(produto_id),
        qtd_vendedores = n_distinct(vendedor_id)
      )

    # ------------------------------------------------------------------
    # Métricas por vendedor
    # ------------------------------------------------------------------
    by_seller <- df_metrics %>%
      group_by(vendedor_id, vendedor) %>%
      summarise(
        vendas = n(),
        itens_vendidos = sum(quantidade_vendida, na.rm = TRUE),
        faturamento = sum(faturamento, na.rm = TRUE),
        lucro = sum(lucro, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(desc(faturamento))

    # ------------------------------------------------------------------
    # Métricas por produto
    # ------------------------------------------------------------------
    by_product <- df_metrics %>%
      group_by(produto_id, produto) %>%
      summarise(
        vendas = n(),
        itens_vendidos = sum(quantidade_vendida, na.rm = TRUE),
        faturamento = sum(faturamento, na.rm = TRUE),
        lucro = sum(lucro, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(desc(faturamento))

    # ------------------------------------------------------------------
    # Retorno pronto para relatório / dashboard
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
      step = "ACCESS_DATA"
    )
  })
}
