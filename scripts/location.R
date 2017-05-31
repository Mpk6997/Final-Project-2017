library(twitteR)
library(plotly)

Top.Map <- function(cities) {
  # geo styling
  g <- list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    showland = TRUE,
    landcolor = toRGB("gray95"),
    subunitcolor = toRGB("gray85"),
    countrycolor = toRGB("gray85"),
    countrywidth = 0.5,
    subunitwidth = 0.5
  )
  
  t <- mapply(getTopTrends, cities$woeid, 5)
  
  df <- cities %>% mutate(trend1 = t[1,],
                          trend2 = t[2,],
                          trend3 = t[3,],
                          trend4 = t[4,],
                          trend5 = t[5,])
  
  p <- plot_geo(df, locationmode = 'USA-states') %>%
    add_markers(
      x = ~longitude, y = ~latitude, size = ~pop,  hoverinfo = "text",
      text = ~paste(paste0(city, ", ", state), "",
                    paste("1) ", trend1),
                    paste("2) ", trend2),
                    paste("3) ", trend3),
                    paste("4) ", trend4),
                    paste("5) ", trend5),
                    sep = "<br />"),
      symbol = I("square"), size = I(8), hoverinfo = "text"
    ) %>%
    layout(
      title = paste("Twitter Trends by Location<br />", Sys.time()), geo = g
    )
  p
}

getTopTrends <- function(id, n) {
  t <- getTrends(id)
  return (t$name[1:n])
}

