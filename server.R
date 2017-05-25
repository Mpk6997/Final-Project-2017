#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(twitteR)

#Authentication
api_key <- "r5HzcaHOWHl8Sl5FcdZxedOKT"
api_secret <- "vLRSMXX8nodsq5v0NU3CyA8ANa11Be115c0MpPPeMDSCvyEkCa"
access_token <- "860006267296677888-6fY8HRqtahtmWrrcVrMLJMwO7H9dY0q"
access_token_secret <- "E1w7VMJxxDlG6nJwYD1JNDZ3zCk6rSTHZBCbOa3fm8abu"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

source("./scripts/wordcloud.r")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$search <- renderText({
    if (input$searchInput == 'Search') {
      paste("Search: ", input$searchId)
    } else {
      paste("User: ", input$searchId)
    }
  })

  output$wordcloud <- renderPlot({
    searchterm <- tolower(input$searchId)
    if (input$searchInput == "Search") {
      tweets <- getTweetsFromSearch(searchterm, input$nResults)
    } else {
      tweets <- getTweetsFromUser(searchterm, input$nResults)
    }
  
    getWordCloud(tweets)
  })
  
  output$sentimentcloud <- renderPlot({
    searchterm <- tolower(input$searchId)
    if (input$searchInput == "Search") {
      tweets <- getTweetsFromSearch(searchterm, input$nResults)
    } else {
      tweets <- getTweetsFromUser(searchterm, input$nResults)
    }
    
    getSentimentCloud(tweets)
  })
  
})
