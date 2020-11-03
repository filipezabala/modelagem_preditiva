# Instalando pacotes de https://github.com/filipezabala/desempateTecnico
packs <- c('devtools','VGAM','klaR','ellipse','rgl')
new.packages <- packs[!(packs %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(packs, dep=TRUE)
update.packages(checkBuilt = TRUE, ask = FALSE)
devtools::install_github('filipezabala/desempateTecnico', force = T)

# Chamando biblioteca
library(desempateTecnico)

# Aplicando a funcão 'bayes'
bayes( c(.4,.3,.3), 1000)
bayes( c(.3,.25,.2,.1,.05), 100)
bayes(rep(1/5,5), 500)
bayes( c(.5144202347, .3246860305, .1608937348), 100 )
