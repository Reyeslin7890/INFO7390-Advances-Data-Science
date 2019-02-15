rm(list = ls())
#Exercise 1
#1.
c(1:20)
c(20:1)
c(1:20, 19:1)
tmp <- c(4, 6, 3)
c(rep(tmp,10))
c(rep(tmp,10), 4)
c(rep(4,10), rep(6,20), rep(3,30))

#2.
i <- 3.0
ex1_2 <- c()
while (i <= 6){ 
  ex1_2 <- c(ex1_2,exp(i)*cos(i))
  i <- i+0.1
}

#3.
ex1_3a <-c()
for (i in c(1:12))
  ex1_3a <- c(ex1_3a, 0.1^(i*3)*0.2*(i*3-2))
ex1_3b <- c()
for (i in c(1:25))
  ex1_3b <- c(ex1_3b, 2^i/i)
ex1_3a
ex1_3b

#Exercise 2
#1.
A <- matrix(c(1,5,-2,1,2,-1,3,6,-3),nrow=3)
det(A%*%A%*%A)
A1 <- A
A1[,3] <- A1[,2]+A1[,3]
det(A1%*%A1%*%A1)

#2.
B <- matrix(c(rep(c(10,-10,10),15)),ncol=3, byrow=TRUE)
det(t(B)%*%B)

#3.
matE <- matrix(0,nrow = 6, ncol = 6)
matE[ abs(col(matE)-row(matE))==1 ] <- 1

#Exercise3
#1.
tmpFn1 <- function(xVec){
  for (i in (1:length(xVec)))
    xVec[i] <- xVec[i]*i
  return(xVec)
}
tmpFn2 <- function(xVec){
  for (i in (1:length(xVec)))
    xVec[i] <- xVec[i]^i/i
  return(xVec)
}

tmp <- c(1,2,3)
tmpFn1(tmp)
tmpFn2(tmp)

#2.
tmpFn <- function(xVec){
  if (length(xVec)<3) {return()}
  newVec <- c()  
  for (i in (2:length(xVec)-1))
      newVec <- c(newVec, (xVec[i-1]+xVec[i]+xVec[i+1])/3)   
      
  return(newVec)
}
tmpFn(c(1:6,5:1))

#3.
tmpFn3 <- function(x)
{
  ifelse(x < 0, x^2 + 2*x + 3, ifelse(x < 2, x+3, x^2 + 4*x - 7))
}
tmp <- seq(-3, 3, len=100)
plot(tmp, tmpFn3(tmp), type="l")

#Exercise 4
#1.
#(a)
funcA <- function(xv,yv){
  colSums(outer(yv,xv,"<"))
}
xv <- c(2,6,8,4)
yv <- c(3,5,1,7)
funcA(xv,yv)
#(b)
funcB <- function(xv,yv){
  rowSums(sapply(yv,FUN=function(y){y<xv}))
}
funcB(xv,yv)

#(c)
funcC <- function(xv,yv){
  rowSums( vapply(yv, FUN=function(y){y<xv}, FUN.VALUE=seq(along=xv)) )
}
funcC(xv,yv)
#(d)
xv <- c()
yv <- c()
funcA(xv,yv)
funcB(xv,yv)
funcC(xv,yv)
# When xv is a 0 length vector while yv has its arguments, all 3 functions work and outputs are "numereic(0)".
# When yv is a 0 length vector while xv is not, both funcA and funcC work, but funcB doesn't.
# When both xv and yv are 0 length vector, funcA and funcC work, but funcB doesn't.
xv <- matrix(c(2,6,8,4),nrow=2)
xv
funcA(xv,yv)
funcB(xv,yv)
funcC(xv,yv)
yv <- matrix(c(3,5,1,7),nrow=2)
# When xv is a matrice and y is not, funcB and funcC work correcly, but funcA's output is incorrect.
# When yv is a matice, all functions work correctly.
#(e)
xv <- rnorm(10000)
yv <- rnorm(10000)
system.time(funcA(xv,yv))
system.time(funcB(xv,yv))
system.time(funcC(xv,yv))
#Using vapply is the most time-effient one.

#2.
mat <-matrix(c(1:8,NA),nrow=3)
#(a)
funA <- function(mat){
  na_flag <- apply(is.na(mat), 2, sum)
  print(na_flag)
  mat[,which(na_flag==0)]
}
funA(mat)
#(b)
funB <- function(mat){
  na_flag1 <- apply(is.na(mat), 1, sum)
  na_flag2 <- apply(is.na(mat), 2, sum)
  mat[which(na_flag1==0),which(na_flag2==0)]
}
funB(mat)

#3.
#(a)
empCopula <- function(u,v,xVec,yVec){
  n <- length(xVec)
  s <- 0
  for (i in (1:n))
    if ((rank(xVec)[i]/(n+1) <=u) & (rank(yVec)[i]/(n+1) <=v))
    {
      s <- s +1
    }
  return(s/n)
}
xVec <- c(3,5,1,2)
yVec <- c(5,7,3,4)
empCopula(0.3,0.7,xVec,yVec)

#Exercise 5
#(a)
tsEwma <- function( tsDat, m0=0, delta=0.7)
{
  n <- length(tsDat)
  mVec <- rep(NA,n+1)
  mVec[1] <- m0
  for(j in 2:(n+1)){
    mVec[j] <- (1-delta)*tsDat[j-1] + delta*mVec[j-1]
  }
  ts(mVec[-1], start=start(tsDat), frequency=frequency(tsDat))
}
tsEwma(c(1,2,3,4))
#(b)
tsEwma2 <- function( tsDat, m0=0, delta=0.7)
{
  tsPars <- tsp(tsDat)
  tsDat <- c(tsDat)
  n <- length(tsDat)
  mVec <- rep(NA,n+1)
  mVec[1] <- m0
  for(j in 2:(n+1)){
    mVec[j] <- (1-delta)*tsDat[j-1] + delta*mVec[j-1]
  }
  ts(mVec[-1], start=tsPars[1], frequency=tsPars[3])
}
tmp <- ts(rnorm(400000), start=c(1960,3), frequency=12)
system.time(tsEwma(tmp))
system.time(tsEwma2(tmp))

#2.
#(a)
myListFn <- function(n){
  xVec <- rnorm(n)
  xBar <- mean(xVec)
  yVec <- sign(xBar)*rexp(n, rate=abs(1/xBar))
  count <- sum( abs(yVec) > abs(xVec) )
  list(xVec=xVec, yVec=yVec, count=count)
}
#(b)
lapply( rep(10,4), myListFn )
sapply( rep(10,4), myListFn )

#(c)
myList <- lapply( rep(10,1000), myListFn )
lapply(myList, FUN="[[", 2)
#(d)
lapply(myList, FUN="[[", 2)
#(e)
myList2 <- lapply(myList, function(x){list(xVec=x$xVec, yVec=x$yVec)})
#(f)
  myList[which( unlist(lapply( myList, function(x){x[[3]]>2} )) )]

#3.
#(a)
  partA <- sapply(myList, function(x){ sum(x$xVec*(1:10))/sum(x$yVec*(1:10)) })
#(b)
 t(sapply( myList, function(x){x$xVec-x$yVec}))
#(c)
    sum(sapply(myList, function(x){x$xVec[2]})*(1:1000)) /
    sum(sapply(myList, function(x){x$yVec[2]})*sapply(myList, function(x){x$count}))
  
#Subsetting Operation
    
    install.packages("xlsx")
    library(xlsx)
    setwd("D:/NEU/7390 Advances Data Science")
    file <- "loan.xlsx"
    loan <- read.xlsx(file, 1)
    mydata <- data.frame(subset(loan, Age > 30 & Job_status == "unemploye"))
    write.xlsx(mydata,file,sheetName="mySheet",append=TRUE)   
    