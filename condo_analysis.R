#First extracted the data from csv file
library(readxl)
initial_data <- read.csv(file.choose())

#Now attach and simplify the data further
attach(initial_data)
as.data.frame(initial_data)

sample_of_data <- initial_data[1:10000, ]



#Find a way to subset this data, so now final_data has 
#all rows that doesn't have Address = 'Address'
#and it captures the first 15 columns
final_data <- subset(sample_of_data, Address != 'Address', 1:15, )
colnames(sample_of_data)

str(sample_of_data)

#Trying to convert character variables 
final_data[, 1:5] <- as.data.frame(sapply(final_data[1:5], as.factor), use = "complete.obs")
final_data[, 1:5] <- as.data.frame(sapply(final_data[1:5], as.character))


#Correlates all numeric columns
cor(sample_of_data[, 6:15], use = "complete.obs")

#Correlates all columns
cor(final_data[, 1:15], use = "complete.obs")

#linear regression function on full market value, with the regressors
#size or Gross.sqft and Net.operating.income
summary(lm(Full.Market.Value ~ Gross.SqFt + Net.Operating.Income, final_data))

#principles for dealing with the changing world order
#Make use of the factor function to categorize the neighborhood data 
#Categorize the data into zip code info, hence making the column numerical
#Then make a regression off with zip code and Gross.sqft as the regressors
factor_neighborhood <- factor(Neighborhood, levels = rev(unique(Neighborhood)), ordered = T)
levels(factor_neighborhood)


#Find a CSV of all the zip codes


rm(list=ls())
