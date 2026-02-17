library(shiny)

ui <- fluidPage(
  titlePanel("Exemple Shiny"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("slider", "Choisissez une valeur :", min = 1, max = 100, value = 50),
      numericInput("num", "Nombre :", value = 10),
      selectInput("model", "Choisir un modèle :", choices = c("Random Forest", "Naive Bayes")),
      actionButton("go", "Exécuter"),
      wellPanel(
        radioButtons("radio", "Sélectionnez une option :", choices = c("Option 1", "Option 2")),
        checkboxInput("check", "Activer", value = TRUE)
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary",
                 textOutput("test_summary"),
                 # Suppression de verbatimTextOutput("reactive_val") car non défini dans le serveur
                 verbatimTextOutput("observe_text")
        ),
        tabPanel("Inputs Info",
                 verbatimTextOutput("input_values")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  square_val <- reactive({
    input$num * 2
  })
  
  observeEvent(input$go, {
    output$observe_text <- renderText({
      paste("Bouton cliqué ! Modèle choisi :", input$model)
    })
  })
  
  output$test_summary <- renderText({
    paste("Double du nombre saisi :", square_val())
  })
  
  output$input_values <- renderPrint({
    cat("Valeur slider :", input$slider, "\n",
        "Nombre :", input$num, "\n",
        "Modèle :", input$model, "\n",
        "Option radio :", input$radio, "\n",
        "Checkbox :", input$check)
  })
}

shinyApp(ui, server)
