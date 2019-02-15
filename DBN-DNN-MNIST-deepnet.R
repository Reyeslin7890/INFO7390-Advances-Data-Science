#install.packages("deepnet")
library(deepnet)

show.digit <- function(arr784, col=gray(12:1/12), ...) {
  image(matrix(arr784, nrow=28)[,28:1], col=col, ...)
}

setwd("C:/MY FILES/Data/MNIST")
mnist<-load.mnist(".")
show.digit(mnist$train$x[155,])
#nn <- nn.train(mnist$train$x, mnist$train$yy, hidden = c(30, 20), numepochs = 25)
#err.nn <- nn.test(nn, mnist$test$x, mnist$test$yy)
#yy.nn <- nn.predict(nn, mnist$test$x)

dnn <- dbn.dnn.train(mnist$train$x, mnist$train$yy, hidden = c(30,20), numepochs = 2, cd=2)
err.dnn <- nn.test(dnn, mnist$test$x, mnist$test$yy)
yy.dnn <- nn.predict(dnn, mnist$test$x)
show.digit(mnist$test$x[99,])

Var1 <- c(rnorm(50, 1, 0.5), rnorm(50, -0.6, 0.2))
Var2 <- c(rnorm(50, -0.8, 0.2), rnorm(50, 2, 1))
x <- matrix(c(Var1, Var2), nrow = 100, ncol = 2)
y <- c(rep(1, 50), rep(0, 50))

test_Var1 <- c(rnorm(50, 1, 0.5), rnorm(50, -0.6, 0.2))
test_Var2 <- c(rnorm(50, -0.8, 0.2), rnorm(50, 2, 1))
test_x <- matrix(c(test_Var1, test_Var2), nrow = 100, ncol = 2)

dnn.small <- dbn.dnn.train(x, y, hidden = c(5, 5), numepochs=5)
## predict by dnn
err.dnn.small <- nn.test(dnn.small, test_x, y)
yy.dnn.small <- nn.predict(dnn.small, test_x)
yy.dnn.small
