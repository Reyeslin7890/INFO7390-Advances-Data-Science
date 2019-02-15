#install.packages('glue')
#install.packages('glmnet')
#install.packages('ggridges')
library(ggplot2)
library(ggridges)
library(glue)
library(glmnet)

#LINEAR REGRESSION
x <- c(seq(from=60, to=300, by=4)/180*pi)
y <- sin(x) + rnorm(length(x),0,0.15)
#draw <- data.frame(x,y)
#ggplot(data=draw,aes(x=x,y=y))+ geom_point()+stat_smooth(method="lm")
plot(x,y)
data <- data.frame(x)
names(data) <- c('x')
for (i in (2:15)){
  col_name <- glue('x_{i}')
  data[col_name] <- data['x']**i;
}

linear_regression <- function(data, power){
  str <- 'y ~ x'
  if (power>=2){
    for (i in 2:power)
      str <- paste(str , glue('+x_{i}'))
  }
  fit <- lm(data=data, formula = str)
  plot(x,y)
  lines(x,fitted(fit))
  #summary(fit)
  return(summary(fit)$coefficients[,1])
}

for (i in 1:15) {
  print(linear_regression(data,i))
}




#RIDGE & LASSO
v <- c(1e-15, 1e-10, 1e-8, 1e-4, 1e-3,1e-2, 1, 5, 10, 20)
x = data.matrix(x)
x
data=data.matrix(data, rownames.force = NA)
data
ridge = glmnet(data, y, alpha = 0, lambda = v)
lasso = glmnet(data, y, alpha = 1, lambda = v)
lasso.cv <- cv.glmnet(data, y, type.measure="mse", alpha=1)
ridge.cv <- cv.glmnet(data, y, type.measure="mse", alpha=0)
predict(ridge, type = "coefficients", s = v)[1:16,]
predict(lasso, type = "coefficients", s = v)[1:16,]
