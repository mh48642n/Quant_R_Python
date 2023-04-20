#First extracted the data from csv file
library(readxl)
library(dplyr)
library(writexl)
initial_data <- read_excel("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\DOF_Rent_income.xlsx", 
                           sheet = "DOF_Condos")

#Now attach and simplify the data further
attach(initial_data)
as.data.frame(initial_data)

colnames(initial_data)
str(initial_data)

#principles for dealing with the changing world order
#Make use of the factor function to categorize the neighborhood data 
#Categorize the data into zip code info, hence making the column numerical
#Then make a regression off with Income, Expenditures as the regressors
#Then I will use Gross Sqft(greater than some number) and Neighborhood as a dummy variable
factor_neighborhood <- factor(Neighborhood, levels = rev(unique(Neighborhood)), ordered = F)
levels(factor_neighborhood)

help(collapse)
  
#Here I will create dummy variables

#I make use of the ifelse function to create the dummy variables
#Based off of the code in the Boro-Block-Lot where the first number would determine
#what Borough the property is located in New York
initial_data$In_Man <- ifelse(grepl("1-", initial_data$`Boro-Block-Lot`), 1, 0)
initial_data$In_Bx <- ifelse(grepl("2-", initial_data$`Boro-Block-Lot`), 1, 0)
initial_data$In_Bk <- ifelse(grepl("3-", initial_data$`Boro-Block-Lot`), 1, 0)
initial_data$In_Qn <- ifelse(grepl("4-", initial_data$`Boro-Block-Lot`), 1, 0)
initial_data$In_SI <- ifelse(grepl("5-", initial_data$`Boro-Block-Lot`), 1, 0)

initial_data <- initial_data %>% select(-contains("Condo")) 
initial_data<- initial_data %>% select(-contains("Address"))
complete_data<- initial_data %>% select(-contains("Building"))

colnames(complete_data)

#Writing this away into python
write_xlsx(complete_data,
           "C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx")

#If I need more dummy variables I'll use the summary stats for these two variables
summary(`Total Units`)
summary(`Gross SqFt`)

#Based off of the summary statistics above I'll use the medians to determine
#What the dummy variables will be based on.
complete_dataset$Units_more_than_71 <- ifelse(`Total Units` > 71.0, 1, 0)
complete_dataset$GSqft_more_than_34k<- ifelse(`Gross SqFt` > 35990, 1, 0)


#now I'm checking the median and max of gross sqft and total units, this is for each neighborhood
tapply(complete_data$`Gross SqFt`, complete_data$Neighborhood, mean)
tapply(complete_data$`Gross SqFt`, complete_data$Neighborhood, median)
tapply(complete_data$`Total Units`, complete_data$Neighborhood, max)
tapply(complete_data$`Total Units`, complete_data$Neighborhood, median)



colnames(complete_data)

#Correlates Year Built, Gross Sqft, Estimated Gross Income, Estimated Expense Net and Full Market Value
#Update the columns are different so this wrong and will need to be corrected
cor(initial_data[, c(7:9, 11, 13, 14)], use = "complete.obs")

#Correlates Full Market Values of the other comparable apartments
#Update the columns are different so this wrong and will need to be corrected
cor(initial_data[, c(13, 14, 27, 42, 57)], use = "complete.obs")

#linear regression function on full market value, with the regressors
#size or Gross.sqft and Net.operating.income
summary(lm(`Full Market Value` ~ `Net Operating Income` + `Net Operating Income 1` + `Net Operating Income 2`, initial_data))

summary(lm(`Full Market Value` ~ `Net Operating Income 1` + `Net Operating Income 2`
           + `Net Operating Income 3`,   complete_dataset))
#Adjusts the plot print 
par(mfrow = c(2, 2))
plot(lm(`Full Market Value` ~ `Net Operating Income 1` + `Net Operating Income 2`
        + `Net Operating Income 3`,   complete_dataset))
par(mfrow = c(1, 1))
plot(lm(`Full Market Value` ~ `Estimated Expense 1` + `Estimated Expense 2` + `Estimated Expense 3`, complete_dataset))
#Do this 
pairs(~ `Full Market Value` + `Net Operating Income 1` + `Net Operating Income 2`)
#Find the mean of the three comparable properties for all numeric data
#Also make a dummy for the Boro-Block-Lot, first look for the first index and
#if it is 1 then make a column called borough and determine the borough name based 
#on the first index of Boro-Block-Lot



rm(list = ls())
