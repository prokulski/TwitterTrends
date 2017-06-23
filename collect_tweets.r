setwd("~/RProjects/TwitterTrends/")

library(tidyverse)
library(rtweet)

ile_trendow <- 15
ile_jednostek <- 8

# token
# load("twitter_token.rdata")
Sys.setenv(TWITTER_PAT="~/RProjects/TwitterTrends/twitter_token.rdata")

# trends
# woeid <- 23424923 # Polska
# trends <- get_trends(woeid)

# które trendy nas interesują?
trends_all <- readRDS("trends.Rds")

# ile_jednostek max czasu (czyli jakieś ile_jednostek * 15 minut temu)
min_time <- trends_all %>%
   select(check_time) %>%
   distinct() %>%
   arrange(desc(check_time)) %>%
   .[ile_jednostek, 1]

# ważone 20 trendów
# ważenie polega na tym, że im bliżej teraz tym większa waga
wagi <- data.frame(pos = 1:max(trends_all$n), waga = 1/1:max(trends_all$n))

# liczymy sumę pozycja trendu * waga i to co jest najbliżej jedynki jest najważniejszym trendem
# jak coś ciągle było pierwsze - będzie miało pozycję 1 (0 odległości od 1),
# coś co raz było drugie i ciągle pierwsze - będzie delikatnie oddalone od 1
# i tak dalej
trends <- trends_all %>%
   filter(check_time >= min_time) %>%
   left_join(wagi, by = c("n" = "pos")) %>%
   mutate(score = n*waga) %>%
   group_by(trend) %>%
   summarise(score = sum(score)/sum(waga)) %>%
   ungroup() %>%
   mutate(n = abs(1-score)) %>%
   arrange(n) %>%
   left_join(trends_all %>% select(trend, query), by="trend") %>%
   select(trend, query) %>%
	mutate(trend = tolower(trend), query = tolower(query)) %>%
   distinct()


tweets <- tibble()


# pierwsze max 12 z trendów - pobranie twittów
for(i in 1:min(ile_trendow, nrow(trends))) {
  cat(paste0("\n", i, "/", min(ile_trendow, nrow(trends)), " - ", as.character(trends[i, "trend"]), "\n"))
  trend_tweets <- search_tweets(as.character(trends[i, "query"]),
                                n = 1000,
                                include_rts = FALSE, retryonratelimit = TRUE,
                                parse = TRUE)
  if("data.frame" %in% class(trend_tweets)) {
    trend_tweets$trend <- as.character(trends[i, "trend"])
    trend_tweets$trend_n <- i
    trend_tweets$query <- as.character(trends[i, "query"])
    tweets <- rbind(tweets, trend_tweets)
  }
}

saveRDS(tweets, file="tweets.Rds")
