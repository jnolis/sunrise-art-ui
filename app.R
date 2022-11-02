library(shiny)
library(bslib)
library(httr)
library(glue)

generator_api_url <- "http://127.0.0.1"

ui <- bootstrapPage(
  theme = bs_theme(version = 5),
  htmlTemplate("templates/make_map.html")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
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
}

# Run the application
shinyApp(ui = ui, server = server)
