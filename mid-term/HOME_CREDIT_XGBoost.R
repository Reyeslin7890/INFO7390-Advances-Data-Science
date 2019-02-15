#install.packages("xlsx")
library(xlsx)
library(xgboost)
library(Metrics)
gc()
setwd('D:/NEU/7390 Advances Data Science/midterm')
file <- "total.csv"
df <- read.csv(file,1)



set.seed(101)
#Drop merged ID columns
df<- df[,-415]
df<- df[,-248]

#Min-Max Normorlization
for (col in c(8:ncol(df))){
  min = min(df[,col],na.rm = TRUE) 
  max = max(df[,col],na.rm = TRUE)
  df[,col] = (df[,col]-min)/(max-min)
}

#Sample training set
sample <- sample(nrow(df),nrow(df)*0.9)
train <- df[sample,]
test <-df[-sample,]


xgb.mat <- xgb.DMatrix(
           data = as.matrix(train[!names(train) %in% c("TARGET","SK_ID_CURR")]), 
           label = train$TARGET)
xgb.test <-xgb.DMatrix(
           data = as.matrix(test[!names(train) %in% c("TARGET","SK_ID_CURR")]),
           label = test$TARGET)

xgb = xgboost(data=xgb.mat, 
              nthread=4, 
              nrounds=60,
              #learning_rate: Step size shrinkage used to prevents overfitting
              eta=0.2,
              #Maximum depth of a tree.
              max_depth=7, 
              #Ridge Regression
              lambda=1,
              #logistic regression
              objective="reg:logistic")
plot(xgb$evaluation_log)
imp <- xgb.importance(model=xgb)
xgb.plot.importance(importance_matrix = imp, top_n=20)
xgb.pre<-predict(xgb,xgb.test)

err <- mean(as.numeric(xgb.pre > 0.5) != test$TARGET)
print(paste("test-error rate=", round(err*10000)/100,"%"))

rmse(xgb.pre,as.matrix(test["TARGET"]))



