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

 # df <- read.csv("./Data/city_data.csv")
 # g <- Top.Map(df)
# g

shinyServer(function(input, output) {
  
  getTweets <- function() {
    searchterm <- tolower(input$searchId)
    if (input$searchInput == "Search") {
      tweets <- getTweetsFromSearch(searchterm, input$nResults)
    } else if (input$searchInput == "Trending") {
      tweets <- getTweetsFromSearch(searchterm, input$nResults)
    } else {
      tweets <- getTweetsFromUser(searchterm, input$nResults)
    }
    return (tweets)
  }
  
  tweets <- eventReactive(
    input$Search,{getTweets()}
  )

  output$search <- renderText({
    if (input$searchInput == 'Search') {
      paste("Search: ", input$searchId)
    } else if (input$searchInput == 'Trending') {
      paste("Trend: ", input$searchId)
    } else {
      paste("User: ", input$searchId)
    }
  })

  output$wordcloud <- renderPlot({
    getWordCloud(tweets())
  })
  
  output$sentimentcloud <- renderPlot({
    getSentimentCloud(tweets())
  })
  
  output$feeling <- renderPlotly({
    getFeeling(tweets())
  })
  
  output$searchtype <- renderUI({
    searchtype()
  })
  
  searchtype <- reactive(
    if (input$searchInput == "Trending") {
      selectInput(inputId = 'searchId', 'Select a trend:', getTrendsWC(23424977))
    } else if (input$searchInput == "Search") {
      textInput(inputId = "searchId", "Enter Search:", "uw")
    } else {
      textInput(inputId = "searchId", "Enter Username: (exclude @)", "katyperry")
    }
  )
  
})
