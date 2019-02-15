#Preprocess
library(xlsx)
setwd("d:/NEU/7390 Advances Data Science")
file <- "Copy of boston.xls"
data <- read.xlsx(file,1)

set.seed(101)
sample <- sample(nrow(data),nrow(data)*0.9)
train <- data[sample,]
test <-data[-sample,]



#RandomForest
library(randomForest)
rf <- randomForest(MV ~., data=data, subset=sample,mtry=4)
plot(rf, type="l")
rf.predict<-predict(rf,test,type="response")
summary(rf.predict)
rf.cv <- rfcv(trainx=train[,1:13],trainy=train[,14], cv.fold=5, scale="log", step=0.5)
rf.imp <- importance(rf)
varImpPlot(rf, sort=TRUE,main="Importance of RandomForest")

#XGBoost
library(xgboost)
xgb.mat <- xgb.DMatrix(data = as.matrix(train[,1:13]), label = train$MV)
xgb.test <-xgb.DMatrix(data = as.matrix(test[,1:13]), label = test$MV)
xgb = xgboost(data=xgb.mat, max_depth=5, nthread=3, nrounds=100)
plot(xgb$evaluation_log)
xgb.imp <- xgb.importance(model=xgb)
xgb.plot.importance(importance_matrix = xgb.imp)
xgb.pre<-predict(xgb,xgb.test)

#rf's rmse
rmse(rf.predict,as.matrix(test["MV"]))
#xgboost's rmse
rmse(xgb.pre,as.matrix(test["MV"]))
     