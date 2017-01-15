################################################################################
##     LOADING THE DATA
################################################################################

## Warm Up: Predict Blood Donations
## Project hosted by DRIVENDATA
## Author : Joanne Breitfelder


################################################################################
## Loading the files containing the data and variables description :
################################################################################

url_train <- "https://archive.ics.uci.edu/ml/machine-learning-databases/blood-transfusion/transfusion.data"
url_names <- "https://archive.ics.uci.edu/ml/machine-learning-databases/blood-transfusion/transfusion.names"
url_test <- "https://s3.amazonaws.com/drivendata/data/2/public/5c9fa979-5a84-45d6-93b9-543d1a0efc41.csv"

if (!file.exists("data/train.csv") | !file.exists("data/test.csv") | !file.exists("data/variables.txt")) {
        download.file(url_train, destfile="data/train.csv", method="curl")
        download.file(url_names, destfile="data/variables.txt", method="curl")
        download.file(url_test, destfile="data/test.csv", method="curl")}
train <- read.csv("data/train.csv")
test <- read.csv("data/test.csv")


################################################################################
## Changing variable names
################################################################################

names(train) <- c("since_last", "donations", "total_given", 
                  "since_first", "march2007")
names(test) <- c("index", "since_last", "donations", 
                 "total_given", "since_first")


################################################################################
## Changing variable types
################################################################################

train <- mutate(train, march2007=as.factor(ifelse(march2007==0, "No", "Yes")),
                donations=as.numeric(donations),
                total_given=as.numeric(total_given))

test <- mutate(test, donations=as.numeric(donations), 
               total_given=as.numeric(total_given))


################################################################################
## Cleaning the workspace
################################################################################

rm(url_train); rm(url_names); rm(url_test)

