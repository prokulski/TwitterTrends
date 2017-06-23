setwd("C:/Users/Lemur/SkyDrive/dane/RStudio_projects/TwitterTrends_Raport")

library(tidyverse)

trends_all <- readRDS("trends.Rds")

theme_set(theme_minimal())

ggplot() +
   geom_line(data = trends_all, aes(check_time, n, color=trend)) +
   geom_text(data = filter(trends_all, check_time == max(check_time)),
             aes(check_time, n, label=trend, color=trend)) +
   theme(legend.position = "none")


# 8 max czasu (czyli jakieś 2h temu)
ile_jednostek <- 8
min_time <- trends_all %>%
   select(check_time) %>%
   distinct() %>%
   arrange(desc(check_time)) %>%
   .[ile_jednostek, 1]

wagi <- data.frame(pos = 1:max(trends_all$n), waga = 1/1:max(trends_all$n))

# ważone 20 trendów
# ważenie polega na tym, że im bliżej teraz tym większa waga
# liczymy sumę pozycja trendu * waga i to co jest najbliżej jedynki jest najważniejszym trendem
# jak coś ciągle było pierwsze - będzie miało pozycję 1 (0 odległości od 1),
# coś co raz było drugie i ciągle pierwsze - będzie delikatnie oddalone od 1
# i tak dalej

trend_list_wagi <- trends_all %>%
   filter(check_time >= min_time) %>%
   left_join(wagi, by = c("n" = "pos")) %>%
   mutate(score = n*waga) %>%
   group_by(trend) %>%
   summarise(score = sum(score)/sum(waga)) %>%
   ungroup() %>%
   mutate(n = abs(1-score)) %>%
   arrange(n)

trend_list_wagi %>%
   top_n(-20, wt = n) %>%
   arrange(desc(n)) %>%
   mutate(trend = factor(trend, levels=trend)) %>%
   ggplot() +
   geom_bar(aes(trend, n), stat="identity",
            fill="lightgreen", color="darkgreen", alpha = 0.7) +
   geom_text(aes(trend, n, label=round(n, 1)), hjust = 1.2) +
   coord_flip() +
   labs(title = "Ważność trendów według ważonej pozycji w trendach")

# uśrednione 20 trendów z tych 2h
# trzeba policzyć ile było tych wystąpień i średnią z ilości pobrań trendów
trend_list_srednie <- trends_all %>%
   filter(check_time >= min_time) %>%
   group_by(trend) %>%
   summarise(n=mean(n)) %>%
   ungroup() %>%
   arrange(n)

trend_list_srednie %>%
   top_n(-20, wt = n) %>%
   arrange(desc(n)) %>%
   mutate(trend = factor(trend, levels=trend)) %>%
   ggplot() +
   geom_bar(aes(trend, n), stat="identity",
            fill="lightgreen", color="darkgreen", alpha = 0.7) +
   geom_text(aes(trend, n, label=round(n, 1)), hjust = 1.2) +
   coord_flip() +
   labs(title = "Ważność trendów według średniej pozycji w trendach")


ggplot() +
   geom_line(data = filter(trends_all, check_time >= min_time, n <= 20), aes(check_time, 20-n, color=trend)) +
   geom_text(data = filter(trends_all, check_time == max(check_time), n <= 20),
             aes(check_time+65, 20-n, label=trend, color=trend), hjust= 0) +
   # theme_void() +
   theme(legend.position = "none")

