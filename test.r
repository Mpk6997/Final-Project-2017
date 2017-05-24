library(RCurl)
library('tm')
library("wordcloud")
library("SnowballC")
library(tm)
library(jsonlite)
library(dplyr)
library(httr)
library(knitr)
library(data.table)
library(stringr)
library(twitteR)
library(devtools)

#authorization
api_key <- "r5HzcaHOWHl8Sl5FcdZxedOKT"
api_secret <- "vLRSMXX8nodsq5v0NU3CyA8ANa11Be115c0MpPPeMDSCvyEkCa"
access_token <- "860006267296677888-6fY8HRqtahtmWrrcVrMLJMwO7H9dY0q"
access_token_secret <- "E1w7VMJxxDlG6nJwYD1JNDZ3zCk6rSTHZBCbOa3fm8abu"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

#get trends from 
trends <- getTrends(woeid = 2490383)

fav <- favorites('realDonaldTrump', n = 100)
favs <- twListToDF(fav)

setwd("~/Cloud Storage/OneDrive - UW Office 365/UW 2016-17/Spring '17/INFO 201/Project")
topAccounts <- read.csv(file = 'topAccounts.csv')
searches <- paste0('from:', topAccounts$username)

uwsearch <- searchTwitter('UW', n=10,geocode='47.6562,-122.3079,10mi') %>% twListToDF()

my.searches <- c('trump', 'comey')


allAccountTweets <- lapply(my.searches, getTweetsFromSearch())


getTweetsFromSearch <- function(my.search) {
  response <- searchTwitter(my.search, n = 100, lang = 'en')
  return (twListToDF(response))
}

getWordCloudFromTweets <- function (tweets, search) {
  usableText <- str_replace_all(tweets$text,"[^[:graph:]]", " ") 
  docs <- usableText
  
  docs <- paste(docs, collapse=' ' )
  docs <- docs[1]
  docs <- Corpus(VectorSource(docs))
  toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
  docs <- tm_map(docs, toSpace, "/")
  docs <- tm_map(docs, toSpace, "@")
  docs <- tm_map(docs, toSpace, "\\|")
  
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  c <- data.frame(word = names(v),freq=v)
  d <- subset(c, word!=search)
  d <- subset(d, word!="you")
  d <- subset(d, word!="out")
  d <- subset(d, word!="not")
  d <- subset(d, word!="him")
  d <- subset(d, word!="the")
  d <- subset(d, word!="with")
  d <- subset(d, word!="and")
  d <- subset(d, word!="will")
  d <- subset(d, word!="make")
  d <- subset(d, word!="for")
  d <- subset(d, word!="...")
  d <- subset(d, word!="https")
  head(d, 10)
  
  set.seed(6543)
  wordcloud(words = d$word, freq = d$freq, min.freq = 2,
            max.words=200, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2"))
  
}
getWordCloudFromTweets(getTweetsFromSearch('comey'), 'comey')


