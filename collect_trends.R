setwd("~/RProjects/TwitterTrends/")

library(tidyverse)
library(lubridate)
library(rtweet)

# token
# load("twitter_token.rdata")
Sys.setenv(TWITTER_PAT="~/RProjects/TwitterTrends/twitter_token.rdata")

trends_all <- readRDS("trends.Rds")

woeid <- 23424923 # Polska

# trends
trends <- get_trends(woeid)
trends <- trends %>%
  select(trend, query) %>%
  mutate(n = row_number(),
         check_time = with_tz(Sys.time(), tzone = "Europe/Warsaw"))

trends_all <- rbind(trends_all, trends)

saveRDS(trends_all, file="trends.Rds")
