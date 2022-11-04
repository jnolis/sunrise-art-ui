cart_cache <- cachem::cache_disk(
  dir = "cache/cart",
  max_size = 1024^2*128,
  max_age = 14*24*60*60
)

make_chart_ui <-
    htmlTemplate("templates/baseof.html",
       document_ = TRUE,
       body = htmlTemplate("templates/make-chart.html",
         document_ = FALSE,
         navbar = htmlTemplate("templates/navbar.html",
           cart_item_count = uiOutput("cart_item_count"),
           document_ = FALSE))
    )


make_chart_server <- function(input, output, session) {

  user_id <- "1b4897a15dfe40c5a25e96ef18cf02ae"

  cart <- reactive({
      cart_cache$get(user_id, missing = list())
  })

  output$cart_item_count <- renderUI({
    if(length(cart()) > 0){
      HTML(glue("<span class='badge bg-primary'>{count}</span>"))
    } else {
      NULL
    }
  })

  generator_api_url <- "http://127.0.0.1"
  location_name <- reactive({
    if(is.null(input$location_update) || input$location_update < 1){
      location_name <- "Seattle, WA"
    } else {
      location_name <- input$location_name
    }
    print(location_name)
    location_name
  })
  output$location_name <- renderText({
    location_name()
  })

  output$downloaded_png <- renderImage({
    input$location_update

    isolate({
      output_file <- tempfile(fileext=".png")
      url <- glue("{generator_api_url}/plot/{URLencode(location_name())}")
      GET(url, write_disk(output_file))
      list(
        src = output_file,
        class = "img-fluid map-preview",
        alt = glue("Sunrise chart for {location_name()}")
      )
    })
  }, deleteFile=TRUE)

  observe({
    if(input$add_to_cart > 0){
      new_cart <- append(cart(), list(location_name = location_name, quantity = 1, url = NULL))
      session$sendCustomMessage("redirect", "/cart")
    }
  })
}

make_chart_page <- page(
  href = "/make-chart",
  ui = make_chart_ui,
  server = make_chart_server
)
