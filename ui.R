library(shiny)
library(ggplot2)
#shiny IO library
# install.packages("rhandsontable") # install the package
library(rhandsontable) # load the package

shinyUI( fluidPage(
  #sets up the tabs on the top
  tabsetPanel( type = "tabs", id = "inTabset", 
               #names and adds input into the different panels
               tabPanel( "Data", value = "panel1", 
                         fluidRow(
                           column(1,
                                  numericInput("obs", "Observations 1:", 10, min = 1, max = 100),
                                  verbatimTextOutput("value"),
                                  actionButton("entr", "Enter")
                           )),
                         fluidRow(
                           column(1,
                                  numericInput("obs2", "Observations 2:", 10, min = 1, max = 100),
                                  verbatimTextOutput("value2"),
                                  actionButton("entr2", "Enter")
                           )),
                         fluidRow(
                           column(6,
                                  helpText("Editable Table"),
                                  rHandsontableOutput("table"),
                                  rHandsontableOutput("table2"),
                                  textInput("title", "Title", "Title"),
                                  textInput("xaxis", "X-axis lable", "X-Axis"),
                                  textInput("yaxis", "Y-axis lable", "Y-Axis"),
                                  numericInput("vmax", "Vmax Estimate", 1),
                                  numericInput("Km", "Km Estimate", 1),
                                  actionButton("plotBtn", "Plot1"),
                                  actionButton("plotBtn2", "Plot2"),
                                  actionButton("plotBtn3", "Plot Both")
                           )
                         )
               ),
               tabPanel( "Results", value = "panel3", 
                         plotOutput("plot1"),
                         actionButton("curveBtn","Curve 1"),
                         actionButton("curveBtn2","Curve 2"),
                         actionButton("curveBtn3","Curve Both"),
                         actionButton("jumpToP1", "Go Back To Data"),
                         br(),
                         h1("Km:",verbatimTextOutput("kmdisplay", placeholder = T)),
                         h1("Vmax:",verbatimTextOutput("vmaxdisplay", placeholder = T)),
                         h1("R", tags$sup(2),verbatimTextOutput("r2", placeholder = T))
               )
  )
)
)
