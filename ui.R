library(shiny)
library(ggplot2)
#shiny IO library
# install.packages("rhandsontable") # install the package
library(rhandsontable) # load the package

shinyUI( fluidPage(
  #sets up the tabs on the top
  tabsetPanel( type = "tabs", id = "inTabset", 
               #names and adds input into the different panels
               tabPanel( "Number of Data Sets", value = "panel1", 
                         fluidRow(
                           column(1,
                                  numericInput("obs", "Observations:", 10, min = 1, max = 100),
                                  verbatimTextOutput("value"),
                                  actionButton("entr", "Enter")
                           )),
                         fluidRow(
                           column(6,
                                  helpText("Editable Table"),
                                  rHandsontableOutput("table"),
                                  textInput("title", "Title", "Title"),
                                  textInput("xaxis", "X-axis lable", "X-Axis"),
                                  textInput("yaxis", "Y-axis lable", "Y-Axis"),
                                  numericInput("vmax", "Vmax Estimate", 1),
                                  numericInput("Km", "Km Estimate", 1),
                                  actionButton("plotBtn", "Plot"),
                                  actionButton("curveBtn","Curve")
                           )
                         )
               ),
               tabPanel( "Plot", value = "panel3", 
                         plotOutput("plot1"),
                         downloadButton(outputId = "down", label = "Download the plot"),
                         radioButtons(inputId = "var1", label = "Select the file type", choices = list("png", "pdf")),
                         h1("Km:",verbatimTextOutput("kmdisplay", placeholder = T)),
                         h1("Vmax:",verbatimTextOutput("vmaxdisplay", placeholder = T)),
                         h1("R", tags$sup(2),verbatimTextOutput("r2", placeholder = T))
               )
  )
)
)
