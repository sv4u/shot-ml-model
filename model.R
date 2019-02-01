rm(list = ls())

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

set.seed(100)

library(purrr)
library(ggplot2)
library(caret)
library(doParallel)

registerDoParallel(cores = (detectCores() - 1))

data.2015 = read.csv("data/2015.csv")
data.2016 = read.csv("data/2016.csv")
data.2017 = read.csv("data/2017.csv")
data.2018 = read.csv("data/2018.csv")

get.regular.season = function(data) {
	subset(data, isPlayoffGame == 0)
}

season.2015 = get.regular.season(data.2015)
season.2016 = get.regular.season(data.2016)
season.2017 = get.regular.season(data.2017)
season.2018 = get.regular.season(data.2018)

get.helpful.data = function(data) {
	data.frame(x = data$xCordAdjusted,
		   y = data$yCordAdjusted,
		   goal = as.factor(data$goal))
}

analysis.2015 = get.helpful.data(season.2015)
analysis.2016 = get.helpful.data(season.2016)
analysis.2017 = get.helpful.data(season.2017)
analysis.all = rbind(analysis.2017, rbind(analysis.2016, analysis.2015))
analysis.2018 = get.helpful.data(season.2018)

control = trainControl(method = "repeatedcv",
					   number = 10,
					   repeats = 10)
model.1 = train(goal ~ . -goal,
				data = analysis.all,
				method = "knn",
				trControl = control)

new.x = seq(-200, 200, 0.5)
new.y = seq(-85, 85, 0.5)

testing.data = expand.grid(new.x, new.y)
colnames(testing.data) = c("x", "y")

prediction = predict(model.1, newdata = testing.data)
