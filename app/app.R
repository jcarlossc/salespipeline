library(shiny)
library(dplyr)
library(here)
library(ggplot2)
library(scales)
library(shinydashboard)
library(logger)

# --------------------------------------------------------
# Importe do arquivo main
# --------------------------------------------------------
devtools::load_all()

# --------------------------------------------------------
# Retorno do arquivo main
# --------------------------------------------------------
metrics <- run_pipeline()

# Métricas de vendas
sales <- metrics$kpis
# Métricas de produtos
products <- metrics$by_product
# Métricas dos vendedores
seller <- metrics$by_seller
log_info("Início da geração do DashBoard")

# --------------------------------------------------------
# Função padrão real(Br)
# --------------------------------------------------------
format_real <- function(x) {
  scales::label_dollar(
    prefix = "R$ ",
    big.mark = ".",
    decimal.mark = ","
  )(x)
}

# --------------------------------------------------------
# UI
# --------------------------------------------------------
ui <- dashboardPage(

  dashboardHeader(title = "📊 Dashboard de Vendas"),

  dashboardSidebar(

    sidebarMenu(
      menuItem("Visão Geral", tabName = "overview", icon = icon("chart-line")),
      menuItem("Produtos", tabName = "products", icon = icon("box")),
      menuItem("Vendedores", tabName = "seller", icon = icon("users")),

      hr(),

      selectInput(
        "produto",
        "Filtrar Produto:",
        choices = c("Todos", products$produto),
        selected = "Todos"
      ),

      selectInput(
        "vendedor",
        "Filtrar Vendedor:",
        choices = c("Todos", seller$vendedor),
        selected = "Todos"
      )
    )
  ),

  dashboardBody(

    tabItems(

      # --------------------------------------------------------
      # Visão geral
      # --------------------------------------------------------
      tabItem(tabName = "overview",

              fluidRow(
                valueBoxOutput("faturamento", width = 3),

                valueBoxOutput("lucro", width = 3),

                valueBoxOutput("ticket", width = 3),

                valueBoxOutput("custo", width = 3)
              ),

              fluidRow(
                box(width = 12, plotOutput("plot_kpis"))
              ),
              fluidRow(
                box(
                  tags$h1("Resumo Executivo"),
                  width = 12,
                  status = "success",

                  p("A análise dos indicadores financeiros revela um desempenho
                  sólido da operação, com faturamento total de R$ 1.424.320,
                  evidenciando uma boa capacidade de geração de receita.

                  O lucro apurado de R$ 471.235 demonstra uma operação eficiente,
                  com controle de custos e margens sustentáveis, refletindo uma
                  estrutura financeira equilibrada.

                  O ticket médio de R$ 2.374 indica um valor relevante por
                  transação, sugerindo que as vendas estão concentradas em
                  produtos de maior valor agregado ou em estratégias eficazes
                  de aumento de valor por cliente.

                  De forma integrada, esses indicadores apontam para um
                  cenário positivo, com equilíbrio entre volume de vendas,
                  rentabilidade e valor médio por pedido, criando uma
                  base consistente para crescimento sustentável."),
                )
              )
      ),

      # --------------------------------------------------------
      # Produtos
      # --------------------------------------------------------
      tabItem(tabName = "products",

              fluidRow(
                box(width = 12, plotOutput("plot_produtos"))
              ),
              fluidRow(
                box(
                  tags$h1("Faturamento por Produto"),
                  width = 12,
                  status = "success",

                  p("A análise de lucratividade por produto evidencia uma
                  distribuição heterogênea, com destaque para itens como
                  Impressora, HD Externo e Cadeira Gamer, que concentram as
                  maiores contribuições para o resultado financeiro.
                  Esses produtos combinam bom volume de vendas com margens
                  mais elevadas, tornando-se estratégicos para a geração de
                  valor."),

                  p("Por outro lado, produtos como Mouse, Pendrive e
                  Teclado apresentam baixa participação no lucro total,
                  indicando menor eficiência financeira. Esses itens podem
                  estar associados a preços mais baixos, margens reduzidas
                  ou menor demanda, exigindo reavaliação estratégica."),

                  p("Além disso, observa-se que alguns produtos com alto
                  volume de vendas, como Webcam e Headset, não necessariamente
                  se traduzem nos maiores lucros, o que reforça a importância
                  de analisar não apenas quantidade vendida, mas também
                  margem e posicionamento de preço."),

                  tags$h3("Principais Implicações"),

                  p("* Priorizar produtos com maior margem e retorno
                    financeiro"),
                  p("* Revisar estratégia de precificação para itens de
                    baixo desempenho"),
                  p("* Explorar oportunidades de aumento de valor em
                    produtos de alto volume"),
                  p("Em síntese, a análise indica oportunidades claras
                    de otimização do portfólio, com foco em maximizar
                    rentabilidade e eficiência operacional.")
                )
              )
      ),

      # --------------------------------------------------------
      # Vendedores
      # --------------------------------------------------------
      tabItem(tabName = "seller",

              fluidRow(
                box(width = 12, plotOutput("plot_vendedores"))
              ),
              fluidRow(
                box(
                  tags$h1("Faturamento por Produto"),
                  width = 12,
                  status = "success",

                  p("A análise de faturamento por vendedor evidencia
                  diferenças relevantes de desempenho dentro da equipe
                  comercial, com destaque para profissionais como
                  Marcos Silva e Fernanda Rocha, que lideram em geração
                  de receita e demonstram maior eficiência nas vendas."),

                  p("Esses resultados indicam não apenas maior volume
                  de negociações, mas também possivelmente melhores
                  estratégias comerciais, relacionamento com clientes ou
                  atuação em produtos de maior valor agregado."),

                  p("Por outro lado, observa-se que outros vendedores
                  apresentam desempenho inferior, o que pode estar
                  associado a fatores como carteira de clientes, experiência
                  ou abordagem comercial. Essa variação reforça a
                  importância de monitoramento contínuo e desenvolvimento
                  da equipe."),

                  tags$h3("Principais insights:"),

                  p("* Identificação clara dos top performers"),
                  p("* Existência de gap de performance entre vendedores"),
                  p("* Potencial de replicação de boas práticas comerciais"),

                  tags$h3("Recomentações:"),

                  p("* Compartilhar estratégias dos vendedores de melhor
                  desempenho"),
                  p("* Implementar treinamentos direcionados"),
                  p("* Avaliar distribuição de leads ou carteira de clientes"),

                  p("Em síntese, os dados permitem uma visão estratégica
                  da equipe, possibilitando ações focadas em maximizar
                  resultados e reduzir desigualdades de performance.")
                )
              )
      )
    )
  )
)

# --------------------------------------------------------
# Sevidor
# --------------------------------------------------------
server <- function(input, output, session) {

  # Filtro produto
  products_filtered <- reactive({
    if (input$produto == "Todos") {
      products
    } else {
      products %>% filter(produto == input$produto)
    }
  })

  # Filtro vendedor
  seller_filtered <- reactive({
    if (input$vendedor == "Todos") {
      seller
    } else {
      seller %>% filter(vendedor == input$vendedor)
    }
  })

  # --------------------------------------------------------
  # KPIs
  # --------------------------------------------------------

  output$faturamento <- renderValueBox({

    valueBox(

      value = tags$p(
        scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        )(sales$faturamento_total),

        style = "
        font-size: 24px;
        font-weight: bold;
      "
      ),

      subtitle = "Faturamento",

      color = "blue",

      icon = icon("dollar-sign")
    )
  })

  # ------------------------------------------------------

  output$lucro <- renderValueBox({

    valueBox(

      value = tags$p(
        scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        )(sales$lucro_total),

        style = "
        font-size: 25px;
        font-weight: bold;
      "
      ),

      subtitle = "Lucro",

      color = "green",

      icon = icon("chart-line")
    )
  })

  # ------------------------------------------------------

  output$ticket <- renderValueBox({

    valueBox(

      value = tags$p(
        scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        )(sales$ticket_medio),

        style = "
        font-size: 24px;
        font-weight: bold;
      "
      ),

      subtitle = "Ticket Médio",

      color = "orange",

      icon = icon("shopping-cart")
    )
  })

  # --------------------------------------------------------
  output$custo <- renderValueBox({

    valueBox(

      value = tags$p(
        scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        )(sales$custo_total),

        style = "
        font-size: 24px;
        font-weight: bold;
      "
      ),

      subtitle = "Custo",

      color = "red",

      icon = icon("dollar-sign")
    )
  })

  # --------------------------------------------------------
  # KPIs Gráficos
  # --------------------------------------------------------

  output$plot_kpis <- renderPlot({

    tibble::tibble(

      indicador = c(
        "Faturamento",
        "Lucro",
        "Ticket Médio",
        "Custo Total"
      ),

      valor = c(
        sales$faturamento_total,
        sales$lucro_total,
        sales$ticket_medio,
        sales$custo_total
      )

    ) %>%

      ggplot(
        aes(
          indicador,
          valor,
          fill = indicador
        )
      ) +

      geom_col(
        width = 0.6,
        show.legend = FALSE
      ) +

      geom_text(

        aes(
          label = scales::label_currency(
            prefix = "R$ ",
            big.mark = ".",
            decimal.mark = ",",
            accuracy = 0.01
          )(valor)
        ),

        vjust = -0.5,
        size = 5,
        fontface = "bold"
      ) +

      scale_fill_manual(

        values = c(
          "Faturamento" = "#2C7BE5",
          "Lucro" = "#00A65A",
          "Ticket Médio" = "#F39C12",
          "Custo Total" = "#E74C3C"
        )
      ) +

      scale_y_continuous(

        labels = scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        )

      ) +

      labs(
        title = "Indicadores Gerais",
        x = "Indicador",
        y = "Valor (R$)"
      ) +

      theme_minimal(base_size = 14) +

      theme(

        plot.title = element_text(
          face = "bold",
          size = 18
        ),

        axis.title = element_text(
          face = "bold"
        ),

        axis.text.x = element_text(
          face = "bold",
          size = 12
        )
      )
  })

  # --------------------------------------------------------
  # Produtos
  # --------------------------------------------------------

  output$plot_produtos <- renderPlot({

    products_filtered() %>%
      arrange(lucro) %>%

      ggplot(
        aes(
          reorder(produto, lucro),
          lucro
        )
      ) +

      # Barras
      geom_col(
        fill = "#2C7BE5",
        width = 0.7
      ) +

      # Valores nas barras
      geom_text(
        aes(

          label = scales::label_currency(
            prefix = "R$ ",
            big.mark = ".",
            decimal.mark = ",",
            accuracy = 0.01
          )(lucro),

          # Texto dentro ou fora da barra
          hjust = ifelse(
            lucro > max(lucro) * 0.15,
            1.1,
            -0.1
          ),

          # Cor dinâmica
          color = ifelse(
            lucro > max(lucro) * 0.15,
            "inside",
            "outside"
          )
        ),

        size = 5,
        fontface = "bold",
        show.legend = FALSE
      ) +

      # Cores do texto
      scale_color_manual(
        values = c(
          "inside" = "white",
          "outside" = "black"
        )
      ) +

      # Inverte o gráfico
      coord_flip() +

      # Formatação do eixo Y em reais
      scale_y_continuous(
        labels = scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        ),

        expand = expansion(mult = c(0, 0.10))
      ) +

      # Títulos
      labs(
        title = "Lucro por Produto",
        subtitle = "Produtos com maior lucro gerado",
        x = "Produtos",
        y = "Lucro (R$)"
      ) +

      # Tema profissional
      theme_minimal(base_size = 13) +

      theme(

        plot.title = element_text(
          face = "bold",
          size = 18
        ),

        plot.subtitle = element_text(
          size = 12,
          color = "gray40"
        ),

        axis.title.x = element_text(
          face = "bold",
          size = 12
        ),

        axis.title.y = element_text(
          face = "bold",
          size = 12
        ),

        axis.text.y = element_text(
          face = "bold"
        ),

        panel.grid.minor = element_blank()
      )
  })



  # --------------------------------------------------------
  # Vendedores
  # --------------------------------------------------------

  output$plot_vendedores <- renderPlot({

    seller_filtered() %>%
      arrange(faturamento) %>%

      ggplot(
        aes(
          reorder(vendedor, faturamento),
          faturamento
        )
      ) +

      # Barras
      geom_col(
        fill = "#00A65A",
        width = 0.7
      ) +

      # Valores nas barras
      geom_text(
        aes(

          label = scales::label_currency(
            prefix = "R$ ",
            big.mark = ".",
            decimal.mark = ",",
            accuracy = 0.01
          )(faturamento),

          # Texto dentro ou fora da barra
          hjust = ifelse(
            faturamento > max(faturamento) * 0.15,
            1.1,
            -0.1
          ),

          # Cor dinâmica
          color = ifelse(
            faturamento > max(faturamento) * 0.15,
            "inside",
            "outside"
          )
        ),

        size = 5,
        fontface = "bold",
        show.legend = FALSE
      ) +

      # Cores do texto
      scale_color_manual(
        values = c(
          "inside" = "white",
          "outside" = "black"
        )
      ) +

      # Inverte gráfico
      coord_flip() +

      # Formatação do eixo Y em reais
      scale_y_continuous(
        labels = scales::label_currency(
          prefix = "R$ ",
          big.mark = ".",
          decimal.mark = ",",
          accuracy = 0.01
        ),

        expand = expansion(mult = c(0, 0.10))
      ) +

      # Títulos
      labs(
        title = "Faturamento por Vendedor",
        subtitle = "Ranking de faturamento gerado pelos vendedores",
        x = "Vendedores",
        y = "Faturamento (R$)"
      ) +

      # Tema profissional
      theme_minimal(base_size = 13) +

      theme(

        plot.title = element_text(
          face = "bold",
          size = 18
        ),

        plot.subtitle = element_text(
          size = 12,
          color = "gray40"
        ),

        axis.title.x = element_text(
          face = "bold",
          size = 12
        ),

        axis.title.y = element_text(
          face = "bold",
          size = 12
        ),

        axis.text.y = element_text(
          face = "bold"
        ),

        panel.grid.minor = element_blank()
      )
  })
}

log_info("Término da geração do DashBoard")

# --------------------------------------------------------
# Run App
# --------------------------------------------------------
shinyApp(ui, server)
