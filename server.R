library(shiny)
library(plotly)
library(dplyr)

shinyServer(function(input, output) {
  output$distPlot <- renderPlotly({
    
    mean <- as.numeric(input$norm_mean)
    sd <- as.numeric(input$norm_sd)
    set.seed(2996)
    xseq <- seq(-50,50,0.1)
    densities <- dnorm(xseq, mean, sd)
    plot_norm <- plot_ly(x = xseq, 
            y = densities, 
            type = 'scatter',
            mode = 'lines', 
            showlegend = FALSE,
            line = list(width = 0.8)) %>%
      add_trace(x = xseq[xseq < qnorm(input$norm_q, mean, sd, lower.tail = ifelse(input$norm_tail == "Lower tail", TRUE, FALSE))],
                y = densities[xseq < qnorm(input$norm_q, mean, sd, lower.tail = I(ifelse(input$norm_tail == "Lower tail", TRUE, FALSE)))],
                fill = 'tozeroy',
                type = 'scatter',
                mode = "lines",
                fillcolor = 'lightred',
                line = list(width = 0.1)) %>%
      layout(title = "Normal Distribution", xaxis = list(zeroline = FALSE))
    
    rate <- input$exp_rate
    set.seed(2996)
    xseq <- rexp(10000,rate)
    qexpo <- qexp(input$exp_q, rate, lower.tail = ifelse(input$exp_tail == "Lower tail", TRUE, FALSE))
    plot_exp <- plot_ly(alpha = 0.6, showlegend = FALSE) %>%
      add_histogram(xseq) %>%
      add_trace(x = c(qexpo,qexpo), y = c(0,600), mode = "lines") %>%
      layout(title = "Exponential Distribution", barmode = "overlay")
    size <- input$binom_size
    prob <- input$binom_prob
    set.seed(2996)
    xseq <- seq(0,size)
    densities <- dbinom(xseq, size, prob)
    plot_binom <- plot_ly(x = xseq,
                          y = densities, 
                          type = 'bar', 
                          showlegend = FALSE) %>%
      add_trace(x = xseq[xseq < qbinom(input$binom_q, size, prob, lower.tail = ifelse(input$binom_tail == "Lower tail", TRUE, FALSE))],
                y = densities[xseq < qbinom(input$binom_q, size, prob, lower.tail = I(ifelse(input$binom_tail == "Lower tail", TRUE, FALSE)))],
                fill = 'tozeroy',
                type = 'bar',
                fillcolor = 'lightblue') %>%
      layout(title = "Binomial Distribution", barmode = "overlay")
    if (input$type == "Normal") {plot_norm}
    else if (input$type == "Exponential") {plot_exp}
    else {plot_binom}
  })
  
  output$answer <- renderText({
    qexpo <- qexp(input$exp_q, input$exp_rate, lower.tail = ifelse(input$exp_tail == "Lower tail", TRUE, FALSE))
    qbinomi <- qbinom(input$binom_q, input$binom_size, input$binom_prob, lower.tail = ifelse(input$binom_tail == "Lower tail", TRUE, FALSE))
    qnorma <- qnorm(input$norm_q, input$norm_mean, input$norm_sd, lower.tail = ifelse(input$norm_tail == "Lower tail", TRUE, FALSE))
    
    if (input$type == 'Normal'){
      paste("The value at which the quantile cuts is", 
          as.character(round(qnorma,2)), 
          sep = ":")
    } else if (input$type == 'Binomial'){
      paste("The value at which the quantile cuts is", 
            as.character(round(qbinomi,2)), 
            sep = ":")
    } else{
      paste("The value at which the quantile cuts is", 
            as.character(round(qexpo,2)), 
            sep = ":")
    }
  })
  
})








