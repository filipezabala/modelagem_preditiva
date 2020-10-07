source('https://raw.githubusercontent.com/filipezabala/desempate_tecnico/main/code/bayes.R')
bayes( c(.4,.3,.3), 1000)
bayes( c(.3,.25,.2,.1,.05), 100)
bayes(rep(1/5,5), 500)
bayes( c(.5144202347, .3246860305, .1608937348), 100 )

