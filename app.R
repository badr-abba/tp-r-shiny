library(shiny)

ui <- fluidPage(
  
  # Titre principal affiché en haut de l’application
  titlePanel("Exemple Shiny"),
  
  sidebarLayout(
    # Organisation de la page en deux parties : sidebar + main panel
    
    sidebarPanel(
      # Partie gauche : contient les widgets (entrées utilisateur)
      
      # Curseur pour choisir une valeur numérique. "slider" est l'ID accessible via input$slider
      sliderInput(
        "slider",
        "Choisissez une valeur :",
        min = 1,
        max = 100,
        value = 50
      ),
      
      # Champ de saisie numérique. Valeur accessible via input$num
      numericInput(
        "num",
        "Nombre :",
        value = 10
      ),
      
      # Menu déroulant pour choisir un modèle. Choix stocké dans input$model
      selectInput(
        "model",
        "Choisir un modèle :",
        choices = c("Random Forest", "Naive Bayes")
      ),
      
      # Bouton pour déclencher une action. Quand cliqué, input$go change
      actionButton("go", "Exécuter"),
      
      # Panel visuel pour regrouper des widgets (Boutons radio et Case à cocher)
      wellPanel(
        radioButtons("radio", "Sélectionnez une option :",
                     choices = c("Option 1", "Option 2")),
        checkboxInput("check", "Activer", value = TRUE)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary",
                 textOutput("test_summary"),
                 verbatimTextOutput("reactive_val"),
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
  
  # Expression réactive : recalcule automatiquement si input$num change
  # Utilisation de input$num pour récupérer la valeur saisie
  square_val <- reactive({
    input$num * 2
  })
  
  # Observateur d'événement : déclenché uniquement quand on clique sur le bouton "go"
  observeEvent(input$go, {
    # Mettre à jour la sortie texte dans l'interface
    output$observe_text <- renderText({
      paste("Bouton cliqué ! Modèle choisi :", input$model)
    })
  })
  
  # Affichage du résultat réactif (le carré du nombre)
  output$test_summary <- renderText({
    paste("Carré du nombre saisi :", square_val())
  })
  
  # Affichage récapitulatif de toutes les entrées utilisateurs
  output$input_values <- renderText({
    paste(
      "Valeur slider :", input$slider, "\n",
      "Nombre :", input$num, "\n",
      "Modèle :", input$model, "\n",
      "Option radio :", input$radio, "\n",
      "Checkbox :", input$check
    )
  })
}

shinyApp(ui, server)

