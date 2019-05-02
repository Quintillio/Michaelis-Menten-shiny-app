library(shiny)
library(rhandsontable)
library(ggplot2)
# Creating dataset
X = as.numeric(rep(NA, times = 10))
Y = as.numeric(rep(NA, times =  10))
W = as.numeric(rep(NA, times = 10))
Z = as.numeric(rep(NA, times =  10))
#X <- c(0.5,1,2,5,20,80,100,300,500,1000)
#Y <- c(0,0.0154,0.02894,0.04534,0.07138,0.08778,0.08875,0.10032,0.0955,0.06752)
df1 = data.frame(X=X, Y=Y)
df2 = data.frame(W=W, Z=Z)



shinyServer(function(input,output,session){
  observeEvent(input$jumpToP3, {
    updateTabsetPanel(session, "inTabset",
                      selected = "panel3")
  })
  observeEvent(input$jumpToP1, {
    updateTabsetPanel(session, "inTabset",
                      selected = "panel1")
  })
  bag <- reactiveValues()
  # returns rhandsontable type object - editable excel type grid data
  observeEvent(input$plotBtn, {
    df1 <- hot_to_r(input$table)
    output$plot1 <- renderPlot({
      #plot(df1$X,df1$Y,xlab=input$xaxis,ylab= input$yaxis, pch = 20, cex = 1.5, title(main= input$title))
      myplot <- ggplot(data = df1, mapping = aes(x = df1$X, y = df1$Y))+  
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black")) +
        theme(plot.title = element_text(lineheight=.8, face="bold")) +
        geom_point()+ labs(title = input$title, x = input$xaxis, y=input$yaxis) + scale_y_continuous(limits = c(0,NA)) +
        scale_x_continuous(limits = c(0,NA))
      (bag$myplot <- myplot)
    })
  })
  observeEvent(input$plotBtn2, {
    df2 <- hot_to_r(input$table2)
    output$plot1 <- renderPlot({
      myplot <- ggplot(data = df2, mapping = aes(x = df2$X, y = df2$Y))+   
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black")) +
        theme(plot.title = element_text(lineheight=.8, face="bold")) +
        geom_point()+ labs(title = input$title, x = input$xaxis, y=input$yaxis) + scale_y_continuous(limits = c(0,NA)) +
        scale_x_continuous(limits = c(0,NA))
      (bag$myplot <- myplot)
    })
  })
  observeEvent(input$plotBtn3, {
    df1 <- hot_to_r(input$table)  
    df2 <- hot_to_r(input$table2)
    df3 <- rbind(df1, df2)
    
    output$plot1 <- renderPlot({
      myplot <- ggplot(data = df3, mapping = aes(x = X, y = Y, geom_point(colour = "red")))+
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.line = element_line(colour = "black")) +
        theme(plot.title = element_text(lineheight=.8, face="bold")) +
        geom_point()+ labs(title = input$title, x = input$xaxis, y=input$yaxis) + scale_y_continuous(limits = c(0,NA)) +
        scale_x_continuous(limits = c(0,NA))
      (bag$myplot <- myplot)
    })
  })
  observeEvent(input$entr,{
    X = as.numeric(rep(NA, times = input$obs))
    Y = as.numeric(rep(NA, times = input$obs))
    df1 = data.frame(X=X, Y=Y)
    output$table <- renderRHandsontable({
      rhandsontable(df1) # converts the R dataframe to rhandsontable object
    })
  })
  observeEvent(input$entr2,{
    W = as.numeric(rep(NA, times = input$obs2))
    Z = as.numeric(rep(NA, times = input$obs2))
    df2 = data.frame(X=W, Y=Z)
    output$table2 <- renderRHandsontable({
      rhandsontable(df2) # converts the R dataframe to rhandsontable object
    })
  })
  observeEvent(input$curveBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=input$vmax,Km=input$Km))
    bag$Coeffs <- coef(bestfit)
    output$plot1 <- renderPlot({
      bag$myplot + stat_function(fun = function(x){bag$Coeffs[1]*x/(bag$Coeffs[2]+x)})
    })
    output$kmdisplay <- renderText({ bag$Coeffs[2] })
    output$vmaxdisplay <- renderText({ bag$Coeffs[1] })
    output$r2 <- renderText({ })
  })
  observeEvent(input$curveBtn2, {
    df2 <- hot_to_r(input$table2)
    MMcurve<-formula(df2$Y ~ Vmax* df2$X /(Km + df2$X))
    bestfit <- nls(MMcurve, df2, start=list(Vmax=input$vmax,Km=input$Km))
    bag$Coeffs2 <- coef(bestfit)
    output$plot1 <- renderPlot({
      bag$myplot + stat_function(fun = function(x){bag$Coeffs2[1]*x/(bag$Coeffs2[2]+x)})
    })
    output$kmdisplay <- renderText({ bag$Coeffs2[2] })
    output$vmaxdisplay <- renderText({ bag$Coeffs2[1] })
    output$r2 <- renderText({ })
  })
  observeEvent(input$curveBtn3, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=input$vmax,Km=input$Km))
    bag$Coeffs <- coef(bestfit)
    df2 <- hot_to_r(input$table2)
    MMcurve2<-formula(df2$Y ~ Vmax* df2$X /(Km + df2$X))
    bestfit2 <- nls(MMcurve2, df2, start=list(Vmax=input$vmax,Km=input$Km))
    bag$Coeffs2 <- coef(bestfit2)
    output$plot1 <- renderPlot({
      bag$myplot + stat_function(fun = function(x){bag$Coeffs2[1]*x/(bag$Coeffs2[2]+x)}, colour = "red") + 
        stat_function(fun = function(x){bag$Coeffs[1]*x/(bag$Coeffs[2]+x)})
    })
    output$kmdisplay <- renderText({ bag$Coeffs[2] })
    output$vmaxdisplay <- renderText({ bag$Coeffs[1] })
    output$r2 <- renderText({ })
  })
  autoInvalidate <- reactiveTimer(10000)
  observe({
    autoInvalidate()
    cat(".")
  })
})
