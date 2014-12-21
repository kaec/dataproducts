library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Faithful Prediction App"),
  
  sidebarPanel(
    h3('Tuning'),
    
    selectInput( 
      "method", 
      "Choose a traning method", 
      choices = c("Linear Regression","Generalized Linear Model","Polynomial Kernel")),
    
    numericInput("waiting", "Waitingt time to next eruption (in min)", 40),
    
    helpText(HTML("1. Choose a training method <br/>",
                  "2. Press the 'Train' button to train the choosen model. This will train the ",
                  "prediction model and otuput the out of sample error<br/>",
                  "3. Enter the waiting time until the next eruption (in mins) <br/>",
                  "4. Press the 'Predict' button. This will train the choosen model and",
                  "give you an estimated out of sample error. <br/>",
                  "It will show the predicted duration of the next eruption <br/><br/>",
                  "Note: When you change the training method you need to retrain your model")),
    
    actionButton("trainBtn", "Train"),
    actionButton("predictBtn", "Predict")
  ),
  
  mainPanel(
    h4('Chosen training method'),
    verbatimTextOutput("method"),
    
    h4('Estimated Out-of-Sample Error'),
    verbatimTextOutput("outOfSample"),
    
    h4('Predicted Duration of Next Eruption (in mins)'),
    verbatimTextOutput("prediction"),
    
    h4('Training data plot'),
    plotOutput("dataPlot")
  )
))