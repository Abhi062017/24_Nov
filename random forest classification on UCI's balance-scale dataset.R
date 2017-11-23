#Random forest classification on UCI's balance-scale dataset
getwd()
#read the file
data <- read.csv('balance-scale.csv', header = F, stringsAsFactors = F)
View(data)
str(data)
summary(data)
data$V1 <- as.factor(data$V1)

#randomize data
random.data <- data[order(runif(nrow(data))),]
View(random.data)

#split 80/20
nrow(random.data)
0.8*625
train <- random.data[1:500,]
test <- random.data[501:625,]

#Random forest model
install.packages('randomForest', dependencies = T)
library(randomForest)
model <- randomForest(train[,-1], train[,1], ntree = 100)
print(model)
plot(model)
summary(model)

#predict
model.pred <- predict(model, test)
model.pred
table(test[,1], model.pred)
#accuracy
accuracy <- table(test[,1], model.pred)
sum(diag(accuracy))/sum(accuracy) #89.6%
