library(twitteR)
Twitter.Auth <- function(param) {
  api_key <- "r5HzcaHOWHl8Sl5FcdZxedOKT"
  api_secret <- "vLRSMXX8nodsq5v0NU3CyA8ANa11Be115c0MpPPeMDSCvyEkCa"
  access_token <- "860006267296677888-6fY8HRqtahtmWrrcVrMLJMwO7H9dY0q"
  access_token_secret <- "E1w7VMJxxDlG6nJwYD1JNDZ3zCk6rSTHZBCbOa3fm8abu"
  setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
}