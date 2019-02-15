library(xlsx)
library(rpart)
library(rpart.plot)

setwd("D:/NEU/7390 Advances Data Science")
file <- "Titanic train.csv"
titanic <-read.csv(file,1)
data <- data.frame(titanic)
head(data)
file <-"Titanic test.csv"
test <- data.frame(read.csv(file,1))
data <- data[rowSums(is.na(data)) == 0,]

fit <- rpart(data=data, Survived ~ Pclass + Sex + SibSp + Fare + Embarked + Age + Parch, 
             method = "class")
rpart.plot(fit, type=2, extra=1)
prediction <- data.frame(predict(fit,test))
write.xlsx(prediction,"Prediction Titanic.xlsx", sheetName = "Prediction")

file <- "Energy Efficiency ENB2012_data.xlsx"
ee <- data.frame(read.xlsx(file,1))
ee <- ee[rowSums(is.na(data)) == 0,]
ee <- ee[1:768,]
sample <- sample(768,650)
observe <- ee[sample,]
predict <- ee[-sample,]
fit1 <- rpart(data=observe, Y1~X1+X2+X3+X4+X5+X6+X7, method = "anova")
fit2 <- rpart(data=predict, Y2~X1+X2+X3+X4+X5+X6+X7, method = "anova")
summary(fit1)
summary(fit2)
rpart.plot(fit1, type=1)
rpart.plot(fit2, type=1)
pred1 <- data.frame(predict(fit1,predict))
pred2 <- data.frame(predict(fit2,predict))
pred <- cbind(pred1,pred2)
write.xlsx(pred,"Prediction Energy Efficiency.xlsx", sheetName = "Prediction Energy Efficiency")
