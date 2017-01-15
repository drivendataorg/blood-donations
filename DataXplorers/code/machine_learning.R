###############################################
##     MAIN SCRIPT
###############################################

## Warm Up: Predict Blood Donations
## Project hosted by DRIVENDATA
## Author : Joanne Breitfelder


################################################################################
## Header
################################################################################

library(dplyr)
library(ggplot2)
library(knitr)
library(caret)
library(tidyr)
library(PerformanceAnalytics)
library(psych)
library(GGally)
library(caretEnsemble)

set.seed(123)

################################################################################
## Loading and reshaping the data
################################################################################

source('code/loading_data.R')
source('code/transforming_data.R')


################################################################################
## Cross-validation 
################################################################################

tc <- trainControl(method="repeatedcv", number=10, repeats=10,
                   classProbs=TRUE, summaryFunction=mnLogLoss)


################################################################################
## Tuning grids
################################################################################

gbmGrid <- expand.grid(n.trees=500,
                       interaction.depth=2,
                       shrinkage=0.005,
                       n.minobsinnode=10)

nnetGrid <- expand.grid(.decay=c(0.1, 0.5), .size=c(3, 4, 5))

svmGrid <- expand.grid(sigma=c(0.5),
                       C=c(0.3))

adaGrid <- expand.grid(iter=100, maxdepth=3, 
                       nu=0.05)


################################################################################
## Models 
################################################################################

model1 <- train(march2007 ~., train, preProcess=c("pca"), method='gbm', 
                metric="logLoss", maximize=FALSE, trControl=tc,
                verbose=FALSE, tuneGrid=gbmGrid)  

model2 <- train(march2007 ~., train, preProcess=c("pca"), method='ada',
                metric="logLoss", maximize=FALSE, tuneGrid=adaGrid,
                trControl=tc) 

model3 <- train(march2007 ~., train, preProcess=c("pca"), method='svmRadial',
                metric="logLoss", maximize=FALSE, trControl=tc,
                tuneGrid=svmGrid) 

model4 <- train(march2007 ~., train, preProcess=c("pca"), method="nnet", 
                tuneGrid=nnetGrid, maxit=1000,
                trControl=tc, metric="logLoss") 

model5 <- train(march2007 ~., train, preProcess=c("pca"), method="gamSpline",
                trControl=tc, metric="logLoss") 


################################################################################
## Combining models
################################################################################

pred1V <- predict(model1, train, "prob")
pred2V <- predict(model2, train, "prob")
pred3V <- predict(model3, train, "prob")
pred4V <- predict(model4, train, "prob")
pred5V <- predict(model5, train, "prob")

combined.data <- data.frame(pred1=pred1V, pred2=pred2V, pred3=pred3V, 
                            pred4=pred4V, pred5=pred5V, 
                            march2007=train$march2007)

gbmGrid <- expand.grid(n.trees=500, interaction.depth=3,
                       shrinkage=0.01, n.minobsinnode=10)

combined.model <- train(march2007 ~., combined.data, method='gbm', 
                  metric="logLoss", maximize=FALSE, trControl=tc)

combined.result <- predict(combined.model, combined.data, "prob")
combined.result$obs <- train$march2007
mnLogLoss(combined.result, lev=levels(combined.result$obs))


################################################################################
## Validation
################################################################################

pred1V <- predict(model1, validation, "prob")
pred2V <- predict(model2, validation, "prob")
pred3V <- predict(model3, validation, "prob")
pred4V <- predict(model4, validation, "prob")
pred5V <- predict(model5, validation, "prob")

combined.data <- data.frame(pred1=pred1V, pred2=pred2V, pred3=pred3V, 
                            pred4=pred4V, pred5=pred5V,
                            march2007=validation$march2007)

combined.result <- predict(combined.model, combined.data, "prob")
combined.result$obs <- validation$march2007
mnLogLoss(combined.result, lev=levels(combined.result$obs)) ## logloss 0.33


################################################################################
## Predicting on test cases
################################################################################

pred1V <- predict(model1, test, "prob")
pred2V <- predict(model2, test, "prob")
pred3V <- predict(model3, test, "prob")
pred4V <- predict(model4, test, "prob")
pred5V <- predict(model5, test, "prob")

combined.data <- data.frame(pred1=pred1V, pred2=pred2V, 
                            pred3=pred3V, pred4=pred4V, pred5=pred5V)
combined.result <- predict(combined.model, combined.data, "prob")

result <- data.frame(X=X, combined.result=combined.result$Yes)
names(result) <- c("", "Made Donation in March 2007")


################################################################################
## Writing the results in a file
################################################################################

write.table(result, file='results/result.csv', 
            row.name=FALSE, sep=",") 

