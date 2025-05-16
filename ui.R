library(shiny)

shinyUI(fluidPage(
  titlePanel("Prediction of car qsec"),
  sidebarLayout(
    sidebarPanel(
      helpText("Prediction of the car's qsec (time) based on cylinder number and car's weight."),
      helpText("Parameters:"),
      sliderInput(inputId = "incyl",
                  label = "Number of cylinder:",
                  value = 4,
                  min = 4,
                  max = 8,
                  step = 2),
      sliderInput(inputId = "inwt",
                  label = "Car weight (tonne):",
                  value = 1.5,
                  min = 1.5,
                  max = 5.5,
                  step = 0.1),
      radioButtons(inputId = "inam",
                   label = "Transmission: ",
                   choices = c("Automatic"= "automatic", "Manual"= "manual"),
                   inline = TRUE)
    ),
    
    mainPanel(
      htmlOutput("pText"),
      htmlOutput("pred"),
      plotOutput("Plot", width = "50%")
    )
  )
))