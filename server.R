library(shiny)
library(rhandsontable)

# Creating dataset
X = as.numeric(rep(NA, times = 10))
Y = as.numeric(rep(NA, times = 10))
df1 = data.frame(X=X, Y=Y)

shinyServer(function(input,output,session){
 # returns rhandsontable type object - editable excel type grid data
  output$table <- renderRHandsontable({
    rhandsontable(df1) # converts the R dataframe to rhandsontable object
  })
  observeEvent(input$plotBtn, {
    df1 <- hot_to_r(input$table)
    output$plot1 <- renderPlot({
      plot(df1$X,df1$Y)
    }) })
  observeEvent(input$curveBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, kinData, start=list(Vmax=0.0035,Km=0.15))
    bestfit
    coef(bestfit)
    sconcRange <- seq(0, 50, .001)
    theorLine <- predict(bestfit, list(S=sconcRange))
    lines(sconcRange,theorLine,col="red") })
}) 

