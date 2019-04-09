library(shiny)
library(rhandsontable)
library(ggplot2)
# Creating dataset
X = as.numeric(rep(NA, times = 10))
Y = as.numeric(rep(NA, times =  10))
#X <- c(0.5,1,2,5,20,80,100,300,500,1000)
#Y <- c(0,0.0154,0.02894,0.04534,0.07138,0.08778,0.08875,0.10032,0.0955,0.06752)
df1 = data.frame(X=X, Y=Y)



shinyServer(function(input,output,session){
  bag <- reactiveValues()
  # returns rhandsontable type object - editable excel type grid data
  observeEvent(input$plotBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=0.0035,Km=0.15))
    Coeffs <- coef(bestfit)
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
  observeEvent(input$entr,{
    X = as.numeric(rep(NA, times = input$obs))
    Y = as.numeric(rep(NA, times = input$obs))
    df1 = data.frame(X=X, Y=Y)
    output$table <- renderRHandsontable({
      rhandsontable(df1) # converts the R dataframe to rhandsontable object
    })
  })
  observeEvent(input$curveBtn, {
    df1 <- hot_to_r(input$table)
    MMcurve<-formula(df1$Y ~ Vmax* df1$X /(Km + df1$X))
    bestfit <- nls(MMcurve, df1, start=list(Vmax=input$vmax,Km=input$Km))
    bag$Coeffs <- coef(bestfit)
    output$plot1 <- renderPlot({
      #pch makes points solid. cex increases their size.
      #plot(df1$X,df1$Y,xlab=input$xaxis,ylab= input$yaxis, pch = 20, cex = 1.5, title(main= input$title))
      #curve(Coeffs[1]*x/(Coeffs[2]+x), add=TRUE)
      bag$myplot + stat_function(fun = function(x){bag$Coeffs[1]*x/(bag$Coeffs[2]+x)})
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
  
  output$down <- downloadHandler(
    #Specify the file name
    filename = function(){
      #plot.png
      #plot.pdf
      paste("plot", input$var1, sep = ".")
    },
    content = function(file){
      if(input$var1 == "png")
        png(file)
      else
        pdf(file)
    }
  )
})

