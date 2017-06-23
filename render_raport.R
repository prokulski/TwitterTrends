setwd("~/RProjects/TwitterTrends/")

Sys.setenv(RSTUDIO_PANDOC="/usr/lib/rstudio-server/bin/pandoc")

# collect Twits
source('~/RProjects/TwitterTrends/collect_tweets.r')

# render raport
rmarkdown::render("TwitterTrends_RaportSmall.Rmd")

# copy raport
file.copy(from ="TwitterTrends_RaportSmall.html",
          to = "/home/lemur/ShinyApps/twitter.html",
          overwrite = TRUE)
