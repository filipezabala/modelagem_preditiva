# Video
# https://www.youtube.com/watch?v=j1V2McKbkLo

# Get data
# https://github.com/filipezabala/modelagem_preditiva/raw/main/data/speeches.zip

# https://coolestguidesontheplanet.com/install-and-configure-wget-on-os-x/
# http://www.labnol.org/software/wget-command-examples/28750/

# $ wget -r -A.htm http://obamaspeeches.com
# $ wget -r -A.htm http://www.americanrhetoric.com/speechbanka-f.htm
# $ wget -r -A.htm http://www.americanrhetoric.com/speechbankg-l.htm

# try(system('wget -r -A.htm http://obamaspeeches.com', intern = TRUE))

# Clean memory
rm(list=ls())

# Libraries
libs <- c('caret','class','tidyverse','tm','wordcloud')
# install.packages(libs, dep = T) # run once
lapply(libs, library, character.only = T)

# Set options
options(stringsAsFactors=F)

# Set parameters
authors <- c('barackobama', 'gwbush')
pathname <- '~/Dropbox/PUC/@Extensão/MBA-DS/apresentacao/data/speeches'

# Clean text
cleanCorpus <- function(corpus)
{
  corpus.tmp <- tm_map(corpus, stripWhitespace) # retirando espaços em branco
  corpus.tmp <- tm_map(corpus.tmp, content_transformer(tolower)) # transformando em minúsculas
  corpus.tmp <- tm_map(corpus.tmp, removePunctuation) # retirando pontuação
  corpus.tmp <- tm_map(corpus.tmp, removeNumbers) # retirando números
  #corpus.tmp <- tm_map(corpus.tmp, removeWords, stopwords('english'))
  myStopwords <- c(stopwords('portuguese'), 'nao', 'pag')
  corpus.tmp <- tm_map(corpus.tmp, removeWords, myStopwords)
  return(corpus.tmp)
}

# Build TDM (TermDocumentMatrix)
generateTDM <- function(auth, path)
{
  s.dir <- sprintf('%s/%s', path, auth) # Concatenates path/auth
  s.cor <- Corpus(DirSource(directory = s.dir, encoding = 'UTF-8'))
  
  s.cor.cl <- cleanCorpus(s.cor)
  s.tdm <- TermDocumentMatrix(s.cor.cl)
  s.tdm <- removeSparseTerms(s.tdm, 0.7)
  result <- list(name = auth, tdm = s.tdm)
}
tdm <- lapply(authors, generateTDM, path = pathname)
str(tdm)

# Attach name
bindAuthor2TDM <- function(tdm)
{
  s.mat <- t(data.matrix(tdm[['tdm']]))
  s.df <- as.data.frame(s.mat, stringsAsFactors = F)
  
  s.df <- cbind(s.df, rep(tdm[['name']], nrow(s.df)))
  colnames(s.df)[ncol(s.df)] <- 'targetAuthor'
  return(s.df)
}
authTDM <- lapply(tdm, bindAuthor2TDM)
str(authTDM)

# Stack
tdm.stack <- do.call(plyr::rbind.fill, authTDM)
tdm.stack[is.na(tdm.stack)] <- 0
options(max.print = 99999)
tdm.stack

# Hold-out sample
train.idx <- sample(nrow(tdm.stack), ceiling(nrow(tdm.stack) * 0.6))
test.idx <- (1:nrow(tdm.stack)) [- train.idx]
sort(train.idx)
sort(test.idx)

# Model - KNN
tdm.auth <- tdm.stack[, 'targetAuthor']
tdm.stack.nl <- tdm.stack[, !colnames(tdm.stack) %in% 'targetAuthor']

# Prediction
knn.pred <- class::knn(tdm.stack.nl[train.idx, ], 
                       tdm.stack.nl[test.idx, ], 
                       tdm.auth[train.idx])

# Accuracy
(conf.mat <- table(Actual = tdm.auth[test.idx], 'Predictions' = knn.pred))
(accuracy <- sum(diag(conf.mat)/length(test.idx) * 100)) 
caret::confusionMatrix(conf.mat)
