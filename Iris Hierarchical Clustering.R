# https://www.r-bloggers.com/hierarchical-clustering-in-r-2/
#install.packages("ggplot2")
library(ggplot2)

clusterPlot <- function(type) {
  clusters <- hclust(dist(iris[, 3:4]), method = type)

  plot(clusters)
  
  clusterCut <- cutree(clusters, 3)
  show(table(clusterCut, iris$Species)) # show required, else will not print

  ggplot(iris, aes(Petal.Length, Petal.Width, color = iris$Species)) + 
    geom_point(alpha = 0.4, size = 3.5) + geom_point(col = clusterCut) + 
    scale_color_manual(values = c('black', 'red', 'green'))
}

clusterPlot('complete')
clusterPlot('average')
clusterPlot('single')
clusterPlot('ward.D')
library(xlsx)
setwd("D:/NEU/7390 Advances Data Science")
file <- "iris.xlsx"
mydata <- data.frame(iris[, 3:4])
write.xlsx(mydata,file,sheetName="mySheet",append=false)   