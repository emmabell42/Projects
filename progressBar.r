progressBar <- function(nIter,precision=5,timeFormat="%a %b %d %X %Y",...){
previous.progress <- 0
progress <- seq(precision,100,precision)
for(progress.bar in 1){
  #cat("\n","Began running at ",format(Sys.time(),timeFormat),
  #"\n","Percentage complete",
  #"\n","0",rep(" ",(100/precision)-2),"1","\n",sep="")
  pc <- (i/length(nIter))*100
  current.progress <- which.min(abs(pc-progress))
  if(current.progress>previous.progress){
    cat("█")
  previous.progress <- current.progress
  }
}
}

nIter <- 100
nums <- 1:10000
means <- c()

for(i in 1:nIter){
  progressBar(nIter=nIter,precision=5)
  num.sample <- sample(nums,1000)
  num.means <- mean(num.sample)
  means <- c(means,num.means)
}
