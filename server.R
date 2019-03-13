library(shiny)
library(rhandsontable)

# Creating dataset
# X = as.numeric(rep(NA, times = 10))
#Y = as.numeric(rep(NA, times =  10))
X <- c(0,1,2,5,20,80,100,300,500,1000)
Y <- c(0,0.0154,0.02894,0.04534,0.07138,0.08778,0.08875,0.10032,0.0955,0.06752)
df1 = data.frame(X=X, Y=Y)


shinyServer(function(input,output,session){
  # returns rhandsontable type object - editable excel type grid data
  observeEvent(input$plotBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=0.0035,Km=0.15))
    Coeffs <- coef(bestfit)
    output$plot1 <- renderPlot({
      plot(df1$X,df1$Y)
      # curve(Coeffs[1]*x/(Coeffs[2]+x), add=TRUE)
    })
  })
  observeEvent(input$entr,{
    X = as.numeric(rep(NA, times = input$obs))
    Y = as.numeric(rep(NA, times = input$obs))
    #df1 = data.frame(X=X, Y=Y)
    output$table <- renderRHandsontable({
      rhandsontable(df1) # converts the R dataframe to rhandsontable object
    })})
  observeEvent(input$curveBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=0.0035,Km=0.15))
    Coeffs <- coef(bestfit)
    output$plot1 <- renderPlot({
      plot(df1$X,df1$Y, pch = 20, cex = 1.5) #pch makes points solid. cex increases their size.
      curve(Coeffs[1]*x/(Coeffs[2]+x), add=TRUE)
    })
  })
})

