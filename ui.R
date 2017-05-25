#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  
  title = "Searching Twitter",
  
  tabPanel("Word Clouds", 
    sidebarLayout(
          
      # Inputs (Dropdown menu, textbox, slider, submit button)
      sidebarPanel(
        selectInput(inputId = 'searchInput', 'Select:', c('Search' = 'Search', 'User\'s Timeline' = 'User')),
        textInput(inputId = "searchId", "Enter Search or Username:", "realDonaldTrump"),
        sliderInput(inputId = 'nResults', "Number of Tweets: (more tweets = longer search)", 
                    min = 25, max = 500, value = 50),
        submitButton("Search")
      ),
             
      # Show the plots
      mainPanel(
        h3(textOutput("search")),
        splitLayout(
          plotOutput("wordcloud"),
          plotOutput("sentimentcloud")
        )
      )
    )         
  ),
  tabPanel("Map",
    "contents"
  ),
  tabPanel("Plot", 
    "contents"
  )
  
))
