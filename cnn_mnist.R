#install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
#install.packages("mxnet")
library(mxnet)
library(deepnet)
#load input
#setwd("C:/aminPro/myDocuments/MSIS/CSYE 7245/MNIST/")
setwd("D:\NEU\7390 Advances Data Science")

mnist <- load.mnist(".")
input_train_count <- 60000#mnist$train$n
input_test_count <- 10000#mnist$test$n
#standardize
train.x <- mnist$train$x[1:input_train_count,]
train.y <- mnist$train$y[1:input_train_count]
test <- mnist$test$x[1:input_test_count,]
train.x <- t(train.x/255)
test <- t(test/255)

##LeNet setup
# input
data <- mx.symbol.Variable('data')
# first conv
conv1 <- mx.symbol.Convolution(data=data, kernel=c(5,5), num_filter=25, pad=c(2,2))
tanh1 <- mx.symbol.Activation(data=conv1, act_type="tanh")
pool1 <- mx.symbol.Pooling(data=tanh1, pool_type="max",  kernel=c(2,2), stride=c(2,2))
# second conv
conv2 <- mx.symbol.Convolution(data=pool1, kernel=c(5,5), num_filter=55, pad=c(2,2))
tanh2 <- mx.symbol.Activation(data=conv2, act_type="tanh")
pool2 <- mx.symbol.Pooling(data=tanh2, pool_type="max", kernel=c(2,2), stride=c(2,2))
# first fullc
flatten <- mx.symbol.Flatten(data=pool2)
fc1 <- mx.symbol.FullyConnected(data=flatten, num_hidden=500)
tanh3 <- mx.symbol.Activation(data=fc1, act_type="tanh")
# second fullc
fc2 <- mx.symbol.FullyConnected(data=tanh3, num_hidden=10)
# loss
lenet <- mx.symbol.SoftmaxOutput(data=fc2)
##Then let us reshape the matrices into arrays:
train.array <- train.x
dim(train.array) <- c(28, 28, 1, ncol(train.x))
test.array <- test
dim(test.array) <- c(28, 28, 1, ncol(test))

##cpu
n.gpu <- 1
device.cpu <- mx.cpu()
device.gpu <- lapply(0:(n.gpu-1), function(i) {
  mx.gpu(i)
})

mx.set.seed(123)
model1 <- mx.model.FeedForward.create(lenet, X=train.array, y=train.y,
                                     ctx=device.cpu, num.round=2, array.batch.size=100,
                                     learning.rate=0.05, momentum=0.9, wd=0.00001,
                                     eval.metric=mx.metric.accuracy,
                                     #arg.params = modelx$arg.params,
                                     batch.end.callback=mx.callback.log.train.metric(100))
#predict
preds <- predict(model1, test.array)
pred.label <- max.col(t(preds)) - 1
library(caret)
confusionMatrix(pred.label, mnist$test$y[1:input_test_count])

