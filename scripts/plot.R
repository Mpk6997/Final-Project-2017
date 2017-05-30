library(twitteR)
library(plotly)
library(dplyr)
accountChart <- function(y.axis) {
  df <- read.csv("Data/topAccounts.csv")
  y <- list(
    title = y.axis
  )
  plot_ly(data = df, x = ~followers, y = ~eval(parse(text = y.axis))) %>% 
    layout(title = 'Top Accounts Twitter Data', yaxis = y)
}