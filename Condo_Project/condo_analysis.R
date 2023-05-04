#First extracted the data from csv file
library(readxl)
library(dplyr)
library(writexl)
library(olsrr)

initial_data <- read_excel("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\DOF_Rent_income.xlsx", 
                           sheet = "DOF_Condos")

#Now attach and simplify the data further
attach(initial_data)
as.data.frame(initial_data)

dim(initial_data)

colnames(initial_data)
str(initial_data)

initial_data <- initial_data %>% select(-contains("Condo")) 
initial_data <- initial_data %>% select(-contains("Address"))
initial_data <- initial_data %>% select(-contains("Year"))
complete_data<- initial_data %>% select(-contains("Building"))

colnames(complete_data)

#Writing this away into python
write_xlsx(complete_data,
           "C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx")

#After cleaning
c_data <- read_excel("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx")
attach(c_data)
as.data.frame(c_data)


#If I need more dummy variables I'll use the summary stats for these two variables
summary(c_data$`Total Units`)
summary(c_data$`Gross SqFt`)

#Based off of the summary statistics above I'll use the medians to determine
#What the dummy variables will be based on.
c_data$Units_more_than_30 <- ifelse(`Total Units` > 30.0, 1, 0)
c_data$GSqft_more_than_58k<- ifelse(`Gross SqFt` > 58000, 1, 0)
c_data$Units_more_than_11 <- ifelse(c_data$`Total Units` > 10, 1, 0)

#c_data[, -(c_data$Units_more_than_30)]
colnames(c_data)
c_data <- c_data %>% select(-c(Units_more_than_11))

#Correlates Year Built, Gross Sqft, Estimated Gross Income, Estimated Expense Net and Full Market Value
#Update the columns are different so this wrong and will need to be corrected
cor(c_data[, c(2:19)], use = "complete.obs")

#linear regression function on full market value, with the regressors
#size or Gross.sqft and Net.operating.income
summary(lm(`Full Market Value` ~ comp_avgnet + comp_avggsft, c_data))
pairs(~ `Full Market Value` + comp_avgeps + comp_avgnet + comp_avggips + comp_avgfmv)

summary(lm(`Full Market Value` ~ comp_avgeps + comp_avgnet + Units_more_than_30 + GSqft_more_than_58k, c_data))
l.model <- lm(`Full Market Value` ~ comp_avgeps + comp_avgnet + Units_more_than_30 + GSqft_more_than_58k, c_data)

l.model2 <-lm(`Full Market Value` ~ log(comp_avgeps) + comp_avgnet + Units_more_than_30 + GSqft_more_than_58k, c_data)

l.model3 <- lm(log(`Full Market Value`) ~  comp_avgeps + comp_avgnet + Units_more_than_30 + GSqft_more_than_58k, c_data)
pairs(~log(`Full Market Value`) + comp_avgeps + log(comp_avgnet))

#Final model
l.model4 <- lm(log(`Full Market Value`) ~ ln(comp_avgnet) + comp_avgeps + Units_more_than_11 + GSqft_more_than_58k, c_data)
plot(log(c_data$comp_avgnet), log(c_data$`Full Market Value`), main="Market Value to Comparables Avg Net",
     xlab ="Log of Avg Net", ylab="Log of Full Market Value", pch=19) + abline(lm(log(c_data$`Full Market Value`) ~ log(c_data$comp_avgnet)), col = "red")
plot(c_data$comp_avgeps, log(c_data$`Full Market Value`), main = "Market Value to Comparable Expense per Sqft",
     xlab = "Expense per Sqft", ylab = "Log Full Market Value", pch=19) + abline(lm(log(c_data$`Full Market Value`) ~ c_data$comp_avgeps), col = "blue")
anova(l.model4)

#Confidence Levels
confint(l.model4, level = 0.95)

#Test Heteroskedasicity
ols_test_breusch_pagan(l.model4)

#Test Multicolinearity
ols_vif_tol(l.model4)

#Adjusts the plot print 
par(mfrow = c(2, 2))
plot(l.model4)

par(mfrow = c(1,1))

rm(initial_data)
