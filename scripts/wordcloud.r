library(tidytext)
library(reshape2)
library(wordcloud)

getTweetsFromSearch <- function(my.search, n.results) {
  response <- searchTwitter(my.search, n = n.results, lang = 'en', retryOnRateLimit = 120)
  tweets <- twListToDF(response)
  
  return (cleanTweets(tweets, my.search))
}

getTweetsFromUser <- function(my.user, n.results) {
  response <- userTimeline(my.user, n=n.results)
  tweets <- twListToDF(response)
  
  return (cleanTweets(tweets, my.search))
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
  # count each word
  countedwords <- tweets %>% count(word, sort = TRUE) 
  
  # sentiment
  bing <- get_sentiments("bing")
  bing_word_counts <- countedwords %>% inner_join(bing)
  
  # sentiment wordcloud
  bing_word_counts %>% acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
    comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                     max.words = 100)
}

getWordCloud <- function (tweets) {

  # count each word
  countedwords <- tweets %>% count(word, sort = TRUE) 
  
  # sentiment
  bing <- get_sentiments("bing")
  bing_word_counts <- countedwords %>% inner_join(bing)
  
  # sentiment wordcloud
  bing_word_counts %>% acast(word ~ sentiment, value.var = "n", fill = 0) %>% 
    comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                     max.words = 100)
  
  # regular wordcloud
  set.seed(643)
  wordcloud(words = countedwords$word, freq = countedwords$n, min.freq = 2,
            max.words=100, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2"))
}
