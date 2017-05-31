library(tidytext)
library(reshape2)
library(wordcloud)
library(dplyr)
library(plotly)

getTrendsWC <- function(woeid) {
  trend <- getTrends(woeid)
  return (trend$name)
}



getTweetsFromSearch <- function(my.search, n.results) {
  response <- searchTwitter(my.search, n = n.results, lang = 'en', retryOnRateLimit = 120)
  tweets <- twListToDF(response)
  
  return (cleanTweets(tweets, my.search))
}

getTweetsFromUser <- function(my.user, n.results) {
  response <- userTimeline(my.user, n=n.results)
  tweets <- twListToDF(response)
  
  return (cleanTweets(tweets, my.user))
}

cleanTweets <- function(tweets, my.search) {
  tweets$text <- gsub(" ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "", tweets$text)
  tidy_tweets <- tweets %>% unnest_tokens(word, text)
  
  # add twitter stop words
  word <- c('rt', 'amp', 't.co', 'https')
  
  # add all search words to stop words
  search.words <- strsplit(my.search, " ")
  for (w in search.words)
    word <- c(word, w)
  
  new_stops <- data_frame(word, "CUSTOM")
  
  # remove stop words
  all_stop_words <- stop_words %>% bind_rows(new_stops)
  cleaned_tweets <- tidy_tweets %>% anti_join(all_stop_words)
  
  return (cleaned_tweets)
}

getSentimentCloud <- function (tweets) {
  # sentiment wordcloud
  tweets %>%
    inner_join(get_sentiments("bing")) %>%
    count(word, sentiment, sort = TRUE) %>%
    acast(word ~ sentiment, value.var = "n", fill = 0) %>%
    comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                     max.words = 200)
}

getWordCloud <- function (tweets) {

  # count each word
  countedwords <- tweets %>% count(word, sort = TRUE) 
  
  # regular wordcloud
  wordcloud(words = countedwords$word, freq = countedwords$n, min.freq = 2,
            max.words=100, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2"))
}

getFeeling <- function (tweets) {
  
  countedwords <- tweets %>% count(word, sort = TRUE) 
  
  feelings <- countedwords %>%
    right_join(get_sentiments("nrc")) %>% 
    filter(!is.na(n)) %>% 
    filter(!is.na(sentiment)) %>% 
    count(sentiment, sort = TRUE)
  
  plot_ly(
    x = feelings$sentiment,
    y = feelings$nn,
    name = "Feeling",
    type = "bar"
  ) %>% 
    layout(yaxis = list(showticklabels = FALSE), xaxis = list(title = 'Emotion'))
}



