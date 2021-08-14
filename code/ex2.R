# installig and calling package
# install.packages('devtools', dep = T)
# devtools::install_github('filipezabala/jurimetrics', force = T)
library(jurimetrics)

# getting help
?fits

# example
?livestock
autoplot(livestock)
fits(livestock)
fits(livestock, show.sec.graph = T)

# processual volume in TJ-RS (Brazil)
data("tjrs_year_month")

# forecasting
y <- ts(tjrs_year_month$count, start = c(2000,1), frequency = 12)
fits(y)
