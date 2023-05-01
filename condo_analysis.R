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

colnames(c_data)

#Correlates Year Built, Gross Sqft, Estimated Gross Income, Estimated Expense Net and Full Market Value
#Update the columns are different so this wrong and will need to be corrected
cor(c_data[, c(2:19)], use = "complete.obs")

#linear regression function on full market value, with the regressors
#size or Gross.sqft and Net.operating.income
summary(lm(`Full Market Value` ~ comp_avgnet + comp_avggsft, c_data))
pairs(~ `Full Market Value` + comp_avggsft + comp_avgnet + comp_avggips)

summary(lm(`Full Market Value` ~ comp_avgnet + comp_avggips, c_data))
#Adjusts the plot print 
par(mfrow = c(1, 1))
plot(lm(`Full Market Value` ~ `Estimated Expense 1` + `Estimated Expense 2` + `Estimated Expense 3`, complete_dataset))

rm(data)
