index_ui <- bootstrapPage(
  theme = bs_theme(version = 5),
  h1("Sunrise Charts")
)

index_server <- function(input, output, session) {
  output$cart_item_count <- renderUI({
    count <- 3
    if(count > 0){
      HTML(glue("<span class='badge bg-primary'>{count}</span>"))
    } else {
      NULL
    }
  })
}

index_page <- page(
  href = "/",
  ui = index_ui,
  server = index_server
)
