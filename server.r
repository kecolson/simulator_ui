library(shiny)
library(xtable)
# source("process_input.R")

shinyServer(function(input, output) {
  
  output$designs <- renderTable({
    #process_input()[[1]]
  })
  
  output$matches <- renderTable({
    #process_input()[[2]]
  })
  
  output$analyses <- renderTable({
    #process_input()[[3]]
  })
  
  output$text1 <- renderText({
    #write.csv(process_input()[[1]], "test_designs.csv", row.names = F)
    #write.csv(process_input()[[2]], "test_matches.csv", row.names = F)
    #write.csv(process_input()[[3]], "test_analyses.csv", row.names = F)
    #paste("Sample size: ", class(input$sample_size))
  })
  
  
  
})


