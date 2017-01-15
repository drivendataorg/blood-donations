################################################################################
##     TRANSFORMING DATA
################################################################################

## Warm Up: Predict Blood Donations
## Project hosted by DRIVENDATA
## Author : Joanne Breitfelder


################################################################################
## Defining some transformations 
################################################################################

my_log <- function(x) {x <- ifelse(x==0, log(x+1e-5)+1, log(x)+1)}

my_norm <- function(x) {x <- (x-mean(x))/sd(x)}

my_boxcox <- function(x) {
        if(sum(x==0)!=0) {x <- x+1e-6} ## Adding a small value to avoid zeros
        bc <- BoxCoxTrans(x)
        L <- bc$lambda
        if(L!=0) {x <- (x^L-1)/L}
        if(L==0) {x <- log(x)}
        return(x)
}


################################################################################
## Creating new variables and removing total blood quantity 
################################################################################

train <- mutate(train,
                ## Avg. nb. of donations/months :
                rate=donations/since_first,
                
                ## Fidelity : if this number is small, it indicates that the 
                ## subject has made a lot of donations, including recent ones.
                fidelity=since_last/donations,
                      
                ## fiability : if someone comes every 3 months in average and 
                ## came for the last time 3 months ago, he is likely to come 
                ## in March 2007. Then this variable is close to 0. 
                fiability=1/rate-since_last, 
                
                ## A value close to 1 indicates a person who has probably 
                ## given up donating blood.       
                has_stopped=since_last/since_first) 


## Removing redondant variable
train <- train[, -3]

## Reordering the variables (just for clarity)
train <- train[, c(1:3, 5:8, 4)]


################################################################################
## Reducing skewness and normalizing the different variables
################################################################################

train[, c(1, 2, 4, 5)] <- lapply(train[, c(1, 2, 4, 5)], my_boxcox)
train[, -8] <- lapply(train[, -8], my_norm)


################################################################################
## Partitionning the train set to create a validation set
################################################################################

index <- createDataPartition(y=train$march2007, p=0.7, list=FALSE)
train <- train[index, ]
validation <- train[-index, ]


################################################################################
## Performing all the same tranformations on the test dataset
################################################################################

test <- mutate(test, rate=donations/since_first,
                fidelity=since_last/donations,
                fiability=1/rate-since_last, 
                has_stopped=since_last/since_first) 

X <- test$index
test <- test[, -c(1, 4)]
test[, c(1, 2, 4, 5)] <- lapply(test[, c(1, 2, 4, 5)], my_boxcox)
test[, names(test)] <- lapply(test[, names(test)], my_norm)
