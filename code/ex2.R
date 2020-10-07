# https://trends.google.com/trends/explore?date=all&geo=US&q=predictive%20analytics

# Libraries
# devtools::install_github('filipezabala/jurimetrics')
library(jurimetrics)

# 
URL <- 'https://raw.githubusercontent.com/filipezabala/modelagem_preditiva/main/data/multiTimeline.csv'
dat  <- read.csv(URL)
head(dat)
dat_ts <- ts(dat$count, start = c(2004,1), frequency = 12)
fits(dat_ts, show.sec.graph = T)
