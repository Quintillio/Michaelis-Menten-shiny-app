library(shiny)
# install.packages("rhandsontable") # install the package
library(rhandsontable) # load the package

shinyUI( fluidPage(
  fluidRow(
    column(4,
           helpText("editable table"),
           rHandsontableOutput("table"),
           br(),
           actionButton("plotBtn","Plot")),
           br(),
           actionButton("curveBtn","curve"),
    plotOutput("plot1")
    
  )
  
))
