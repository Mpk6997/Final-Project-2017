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

source("./scripts/twitterauth.r")
source("./scripts/wordcloud.r")
source("./scripts/location.r")

#Authentication
Twitter.Auth()

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
