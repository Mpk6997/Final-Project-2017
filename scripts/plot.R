library(twitteR)
library(plotly)
library(dplyr)
accountChart <- function(y.axis) {
  df <- read.csv("Data/topAccounts.csv")
  y <- list(
    title = y.axis
  )
  df <- mutate_each(df, funs(gsub(",", "", .)), tweets, following, followers)
  df <- mutate(df, tweets = as.numeric(as.character(df$tweets)), following = as.numeric(df$following),
               followers = as.numeric(df$followers)) 
  df <- arrange(df, tweets) %>% arrange(followers) %>% arrange(following)
  plot_ly(data = df, x = ~followers, y = ~eval(parse(text = y.axis)), type = 'scatter', 
          # Hover Text
          text = ~username) %>% 
    layout(title = 'Top Accounts Twitter Data', yaxis = y)
}
