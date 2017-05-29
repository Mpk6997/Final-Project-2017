library(twitteR)
Locate.Top <- function(id) {
  return (getTrends(woeid = id))
}