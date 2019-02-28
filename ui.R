library(shiny)

#shiny IO library
# install.packages("rhandsontable") # install the package
library(rhandsontable) # load the package

shinyUI( fluidPage(
  #sets up the tabs on the top
  tabsetPanel( type = "tabs",
               #names and adds input into the different panels
               tabPanel( "plot",
                         fluidRow(
                           column(4,
                                  helpText("editable table"),
                                  rHandsontableOutput("table"),
                                  br(),
                                  actionButton("plotBtn","Plot"),
                                  actionButton("curveBtn","curve"),
                                  plotOutput("plot1")
                           )
                         )
               ),
               tabPanel("data")
               
  )
))
