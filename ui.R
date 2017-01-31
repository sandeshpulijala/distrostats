library(shiny)
library(plotly)
library(markdown)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Distrostats"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("type",
                   "Select type of Distribution:",
                   c("Normal","Binomial","Exponential")),
       conditionalPanel( condition = "input.type == 'Normal'",
                         sliderInput("norm_mean","Mean:",-50,+50,value = 0),
                         sliderInput("norm_sd","Standard deviation:",0,20,value = 10),
                         radioButtons("norm_tail", NULL,
                                      c("Lower tail","Upper tail")),
                         sliderInput("norm_q","Quantile:",0,1,value = 0.5)),
       conditionalPanel( condition = "input.type == 'Binomial'",
                         sliderInput("binom_size","Size:",0,100,value = 50),
                         sliderInput("binom_prob","Success Probability:",0,1,value = 0.5),
                         radioButtons("binom_tail", NULL,
                                      c("Lower tail","Upper tail")),
                         sliderInput("binom_q","Quantile:",0,1,value = 0.5)),
       conditionalPanel( condition = "input.type == 'Exponential'",
                         sliderInput("exp_rate","Rate",1,20,value = 3),
                         radioButtons("exp_tail", NULL,
                                      c("Lower tail","Upper tail")),
                         sliderInput("exp_q","Quantile:",0,1,value = 0.5))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("About", includeMarkdown("documentation.Md"), h3("Click on the Statistics tab to get started!")),
        tabPanel("Statistics",h3("The Plot"),plotlyOutput("distPlot"), h4("The Quantile Cut"), textOutput("answer"))
      )
    )
  )
))
