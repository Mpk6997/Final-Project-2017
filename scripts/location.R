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
  
  p <- plot_geo(cities, lat = ~latitude, lon = ~longitude) %>%
    add_markers(
      text = ~paste(city, state, paste("Trends:", getTrends(df$woeid)), sep = "<br />"),
      symbol = I("square"), size = I(8), hoverinfo = "text"
    ) %>%
    layout(
      title = paste("Twitter Trends by Location<br />", Sys.time()), geo = g
    )
}

