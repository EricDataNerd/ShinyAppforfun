library(shiny)
library(HistData)
library(dplyr)
library(ggplot2)
library(rgl)

# load the mtcar dataset, and choose the variables of interest a prior (just for demonstration purpose)
# we don't care about fuel efficiency, as we are looking at performance on qsec (time needed to travel one-quarter of a mile from a standstill)
data(mtcars)
ddf <- data.frame(mtcars$cyl, mtcars$wt, mtcars$qsec, mtcars$am)
x <- c("cyl", "wt", "qsec", "am")
colnames(ddf) <- x
ddf$am[ddf$am == 0] <- "automatic"
ddf$am[ddf$am == 1] <- "manual"


# linear model
modelfit <- lm(qsec ~ cyl + wt + am, data=ddf)

shinyServer(function(input, output) {
  output$pText <- renderText({
    paste("Number of Cylinder",
          strong(round(input$incyl, 1)),
          ", Car Weight",
          strong(round(input$inwt, 1)),
          "Tonne, then:")
  })
  output$pred <- renderText({
    df <- data.frame(cyl=input$incyl,
                     wt=input$inwt,
                     am=factor(input$inam, levels=c("automatic","manual")))
    ch <- predict(modelfit, newdata=df)
    paste0("Car's predicted qsec is around",
           em(strong(round(ch))),
           " second"
    )
  })
  output$Plot <- renderPlot({
    df <- data.frame(cyl=input$incyl,
                     wt=input$inwt,
                     am=factor(input$inam, levels=c("automatic","manual")))
    ch <- predict(modelfit, newdata=df)
  
    yvals <- c("CYL", "WT", "QSEC")
    df <- data.frame(
      x = factor(yvals, levels = yvals, ordered = TRUE),
      y = c(input$incyl, input$inwt, ch))
    
    ggplot(df, aes(x=x, y=y, color=c("red", "green", "blue"), fill=c("red", "green", "blue"))) +
      geom_bar(stat="identity", width=0.5) +
      xlab("") +
      ylab("") +
      theme_minimal() +
      theme(legend.position="none") +
      ylim(0, 24)
    

  })
})