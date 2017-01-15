
# DrivenData Challenge: Predicting Blood Donations
### Joanne Breitfelder
### *20 Sep 2016*


## Introduction

*Blood donation has been around for a long time. The first successful recorded transfusion was between two dogs in 1665, and the first medical use of human blood in a transfusion occurred in 1818. Even today, donated blood remains a critical resource during emergencies. The dataset is from a mobile blood donation vehicle in Taiwan. The Blood Transfusion Service Center drives to different universities and collects blood as part of a blood drive. We want to predict whether or not a donor will give blood the next time the vehicle comes to campus.*

This challenge is proposed by [DrivenData](https://www.drivendata.org).

Data is courtesy of Yeh, I-Cheng via the [UCI Machine Learning repository](https://archive.ics.uci.edu/ml/datasets/Blood+Transfusion+Service+Center):  
Yeh, I-Cheng, Yang, King-Jang, and Ting, Tao-Ming, *Knowledge discovery on RFM model using Bernoulli sequence*, **Expert Systems with Applications**, 2008, doi:10.1016/j.eswa.2008.07.018.

**Ranking (team DataXplorers):**  
- Feb. 27, 2016: #1  
- Sept. 20, 2016: #5


## In this repository...

### Codes

To run the codes you will need a working installation of the [programming language R](https://www.r-project.org). A nice user interface to code in R is [RStudio](https://www.rstudio.com).

* **loading_data.R:** loads the data and change the variable names and types. Tu run this code: `source('loading_data.R')`.
* **transforming_data.R:** this code allows to create new variables, remove useless one, apply a cox-box transformation on skewed variables and normalize the data. Tu run it: `source('transforming_data.R')`.
* **machine_learning.R:** in this code I build the machine learning model and derive the resulting predictions. Tu run it: `source('machine_learning.R')`.

### Data

* **train.csv:** data on which the model is trained.
* **test.csv:** data on which we want to predict if he/she will donate.
* **variables.txt:** file containing an extensive description of the data taken from the Blood Transfusion Service Center in Hsin-Chu City in Taiwan.

### Results

* **result.csv:** file containing the resulting predictions, in the DrivenData submission format.

### Documentation

* **Documentation.html** is a report explaining the whole modeling process. It includes code, comments and figures.   
* **Documentation.Rmd** is the R Markdown source file used to create this report, and the folders **Documentation_cache** and **Documentation_files** are generated when compiling it.







