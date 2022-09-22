library(shiny)
ui <- fluidPage(
  titlePanel("Upload files to identify outliers"),
  sidebarLayout(
    sidebarPanel(
      fileInput("data_file", "Choose a valid CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      checkboxInput("header", "Header", TRUE),
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ",")
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
server <- function(input, output) {
  output$distPlot <- renderPlot({
    req(input$data_file)
    tryCatch(
      {
        df <- read.csv(input$data_file$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
        boxplot(df[,2])
      },
      error = function(e) {
        stop(safeError(e))
      }
    )
  })
}
shinyApp(ui, server)