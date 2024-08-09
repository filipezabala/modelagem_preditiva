###
## Decades of Jurimetrics
#

inicio <- Sys.time()

# Pacotes via Terminal
# sudo apt-get install libcurl4-openssl-dev

# Pacotes
# install.packages(c('tidyverse','e1071','vcd','qcc','forecast','micEcon'), dep = TRUE)
# update.packages(ask = F)

# Working directory
getwd()
setwd('~/Dropbox/PUC/@Extensão/@MBA-DS/apresentacao/presentation/')
options(continue = ' ', digits = 5) # Para retirar os '+' entre as linhas do codigo
# options(continue = ' ', prompt = ' ') # Para retirar os '+' entre as linhas do codigo e '>' do prompt

# Gerando o arquivo .tex
Sweave(file = 'mp.Rnw',
  output = 'mp.tex',
  encoding = 'utf8')

# dar uma olhada  
# ?Sweave2knitr

# BibTeX (http://texblog.org/category/sweaveknitr/)
Sys.setenv(TEXINPUTS = getwd(), BIBINPUTS = getwd(), BSTINPUTS = getwd()) 

# Criando o .pdf a partir do arquivo .tex
tools::texi2pdf('mp.tex')

fim <- Sys.time()
fim-inicio
