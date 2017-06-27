# TwitterTrends

Wynik dzialania na stronie [tt.shiny.prokulski.net](http://tt.shiny.prokulski.net).


## Konfiguracja

**Przede wszystkim należy sprawdzić sciezki do plików.** I odpowiednio je poprawic :)


### Wersja statyczna

W cronie trzeba wywolac **collect_trends.R** np. co 15 minut i raz na godzinę **render_raport.R**. Efektem bedzie plik *TwitterTrends_RaportSmall.html* z raportem.

### Wersja interaktywna (Shiny)

W cronie wywolac **collect_trends.R** np. co 15 minut oraz na przyklad raz na godzine **collect_tweets.r**. Uruchomienie (na przyklad wywolanie w przegladarce) na serwerze Shiny pliku **TwitterTrends_shiny.Rmd** da gotowy raport.

