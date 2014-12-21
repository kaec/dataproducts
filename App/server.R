library(shiny)
library(caret)
library(KRLS)

# do some "one of" calculation of loading and splitting up
# the data into training and testing
data(faithful)
set.seed(123)
trainIdx <- createDataPartition(y = faithful$waiting, p = 0.7, list = FALSE)
train <- faithful[trainIdx,]
test <- faithful[-trainIdx,]

#actual server work
shinyServer(
  function(input, output) {

    # choose the right training method for train()
    trainMethod <- reactive({
      switch(input$method,
             "Linear Regression" = "lm",
             "Generalized Linear Model" = "glm",
             "Polynomial Kernel" = "krlsPoly")
    })
    
    # output the choosen training method for display
    output$method <- renderText({
      input$method
    })
    
    # train the model when the trianing button was pressed
    fit <- reactive({
      if( input$trainBtn != 0 )
      {
        isolate( train( eruptions ~ waiting, data = train, method = trainMethod()))
      }
    })
    
    # calculate and output the out of sample error once the model is trained
    output$outOfSample <- renderText({
      if( input$trainBtn != 0 )
      {
        isolate( sqrt( sum( (predict( fit(), newdata = test ) - test$eruptions)^2 ) ) )
      }
    }) 
    
    # predict when the Predict button was pressed and report the prediction
    output$prediction <- renderText({
      if ( input$predictBtn != 0 ) {
        isolate({ 
          df <- data.frame(waiting = input$waiting)
          predict( fit(), newdata = df )
        })
      }
    })

    
    output$dataPlot <- renderPlot({
      plot( train, xlab = "waiting", ylab = "eruptions", col = "red")
    })
      
  }
)