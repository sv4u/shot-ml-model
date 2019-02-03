rm(list = ls())

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

set.seed(100)

library(ggplot2)
library(caret)
library(doParallel)

registerDoParallel(cores = (detectCores() - 1))

print("parallel cores done")
print("num cores:")
print(detectCores() - 1)

data.2015 = read.csv("data/2015.csv")
data.2016 = read.csv("data/2016.csv")
data.2017 = read.csv("data/2017.csv")
data.2018 = read.csv("data/2018.csv")

print("read data")

get.regular.season = function(data) {
	subset(data, isPlayoffGame == 0)
}

season.2015 = get.regular.season(data.2015)
season.2016 = get.regular.season(data.2016)
season.2017 = get.regular.season(data.2017)
season.2018 = get.regular.season(data.2018)

print("got regular season data")

get.helpful.data = function(data) {
	data.frame(x = data$xCordAdjusted,
		   y = data$yCordAdjusted,
		   angle = data$shotAngleAdjusted,
		   dist = data$shotDistance,
		   goal = data$goal)
}

analysis.2015 = get.helpful.data(season.2015)
analysis.2016 = get.helpful.data(season.2016)
analysis.2017 = get.helpful.data(season.2017)
analysis.2018 = get.helpful.data(season.2018)

print("got helpful data")

analysis.2015 = analysis.2015[complete.cases(analysis.2015),]
analysis.2016 = analysis.2016[complete.cases(analysis.2016),]
analysis.2017 = analysis.2017[complete.cases(analysis.2017),]
analysis.all = rbind(analysis.2017, rbind(analysis.2016, analysis.2015))
analysis.all = analysis.all[complete.cases(analysis.all),]
analysis.2018 = analysis.2018[complete.cases(analysis.2018),]

print("got all complete cases")

control = trainControl(method = "repeatedcv", number = 5, repeats = 2)

print("control is trained")

model.nnet = train(goal ~ . -goal,
                   data = analysis.all,
                   method = "nnet,"
                   trControl = control)

print("model (nnet) trained")