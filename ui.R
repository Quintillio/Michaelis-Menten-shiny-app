library(shiny)

#shiny IO library
# install.packages("rhandsontable") # install the package
library(rhandsontable) # load the package

shinyUI( fluidPage(
  #sets up the tabs on the top
  tabsetPanel( type = "tabs",
               #names and adds input into the different panels
               tabPanel( "Number of Data Sets", 
                         fluidRow(
                           numericInput("obs", "Observations:", 10, min = 1, max = 100),
                           verbatimTextOutput("value"),
                           actionButton("entr", "Enter")
                         )),
               tabPanel("Data",
                        fluidRow(
                          column(3,
                                 helpText("Editable Table"),
                                 rHandsontableOutput("table"),
                                 br(),
                                 actionButton("curveBtn","Curve")
                          )
                        )
               ),
               tabPanel( "Plot",
                         plotOutput("plot1")
               )
  )
)
)

