#First extracted the data from csv file
library(readxl)
library(dplyr)
library()
initial_data <- read_xlsx(file.choose(), sheet = "DOF_Condos")

#Now attach and simplify the data further
attach(initial_data)
as.data.frame(initial_data)
initial_data <- initial_data[1:10000, ]


colnames(initial_data)

str(initial_data)


#principles for dealing with the changing world order
#Make use of the factor function to categorize the neighborhood data 
#Categorize the data into zip code info, hence making the column numerical
#Then make a regression off with Income, Expenditures as the regressors
#Then I will use Gross Sqft(greater than some number) and Neighborhood as a dummy variable
factor_neighborhood <- factor(Neighborhood, levels = rev(unique(Neighborhood)), ordered = T)
levels(factor_neighborhood)

#This is block of code makes use of the excel sheet neighborhoods

#3 vector variables are created: column.names, borough_ids, and id_nums
#This will help create a dataframe for another purpose
column.names <- c("Borough", "Id number")
borough_ids <- c("Brooklyn","Bronx",
                 "Queens","Manhattan"
                 ,"Staten Island" ,"Unspecified")
id_nums <- c(1:7)

#Using the vector variables above I constructed a dataframe
#I'll use this dataframe to then full join with the sheet Neighborhoods
borough_ids <- array(c(borough_ids, id_nums), dim = c(6,2,1))
borough_ids <- as.data.frame(borough_ids)
colnames(borough_ids) <- column.names

#Now I attach the excel sheet neighborhood so I can be more intimate with the data  
neighborhoods <- read_xlsx(file.choose(), sheet = "Neighborhoods")
neighborhoods <- neighborhoods[, 1:2]

#Here I will create three dummy variables
summary(`Total Units`)
summary(`Gross SqFt`)

#Based off of the summary statistics above I'll use the medians to determine
#What the dummy variables will be based on.
complete_dataset$Units_more_than_71 <- ifelse(`Total Units` > 71.0, 1, 0)
complete_dataset$GSqft_more_than_34k<- ifelse(`Gross SqFt` > 35990, 1, 0)


#Finally I create a data object called B_to_N which relates the neighborhoods to their
#corresponding borough. I accomplish this by doing a full join using dplyr library 
#between the objects neighborhoods and borough_ids object joining on Borough 
B_to_N <- full_join(neighborhoods, borough_ids, by = "Borough", multiple = "all")
B_to_N
colnames(B_to_N)

#Here I joined the initial_data object with the B_to_N data object 
complete_dataset <- inner_join(initial_data, B_to_N, by = c("Neighborhood"), multiple = "all" )
#now I'm checking the median and max of gross sqft and total units, this is for each neighborhood
tapply(complete_dataset$`Gross SqFt`, complete_dataset$Neighborhood, max)
tapply(complete_dataset$`Gross SqFt`, complete_dataset$Neighborhood, median)
tapply(complete_dataset$`Total Units`, complete_dataset$Neighborhood, max)
tapply(complete_dataset$`Total Units`, complete_dataset$Neighborhood, median)


colnames(complete_dataset)

#Correlates Year Built, Gross Sqft, Estimated Gross Income, Estimated Expense Net and Full Market Value
cor(initial_data[, c(7:9, 11, 13, 14)], use = "complete.obs")

#Correlates Full Market Values of the other comparable apartments
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
