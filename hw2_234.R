#2.
factor1 <- c(41.9,43.4,43.9,44.5,47.3,47.5,47.9,50.2,52.8,53.2,56.7,57.0,63.5,65.3,71.1,77.0,77.8)
factor2 <- c(29.1,29.3,29.5,29.7,29.9,30.3,30.5,30.7,30.8,30.9,31.5,31.7,31.9,32.0,32.1,32.5,32.9)
yield <- c(251.3,251.3,248.3,267.5,273.0,276.5,270.3,274.9,285.0,290.0,297.0,302.5,304.5,309.3,321.7,330.7,349.0)
fit <- lm(yield~factor1+factor2)
summary(fit)

x<- matrix(c(rep(1,17),factor1,factor2),ncol=3)
y<- matrix(yield,ncol=1)
beta <- solve(t(x)%*%x)%*%t(x)%*%y
H <- x%*%solve(t(x)%*%x)%*%t(x)
J <- matrix(rep(1,17*17),ncol=17)
I <- matrix(0,ncol=17,nrow=17)
I[col(I)==row(I)] <- 1
SSR <- t(y)%*%(H-J/17)%*%y
MSR <- SSR/2
SSE <- t(y)%*%(I-H)%*%y
MSE <- SSE/14
f <- MSR/MSE
f
# summary:F-statistic: 211.9
# f = 211.9034


#3.
library(xlsx)
setwd("D:/NEU/7390 Advances Data Science")
file <- "loan.xlsx"
loan <- read.xlsx(file, 1)
loan <- subset(loan, TRUE, c(Res_status, Occupation, Job_status, Liab_ref, Acc_ref, Decision))
glm <- glm(Decision~Res_status+Occupation+Job_status+Liab_ref+Acc_ref, data = loan, family=binomial(link = "logit"))
glm
summary(glm)

test1 <-  data.frame(Res_status='owner',Occupation='creative_', Job_status='governmen', Liab_ref='f', Acc_ref='given')
test2 <-  data.frame(Res_status='rent' ,Occupation='creative_', Job_status='governmen', Liab_ref='f', Acc_ref='given')
predict(glm,test1,type="response")
predict(glm,test2,type="response")

#For test1, it has 39.7% to reject, and for test2, it has 59.3% to reject.

#4. Not Found PDF

