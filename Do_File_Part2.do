//remember how to update system
ssc install binscatter

//Finding the summary of the data
summarize grade hours ttl_exp tenure

//Correlation matrix for all variables
//Helps you determine what variables you'd want to correlate
corr 
 
//Correlation matrix for these specific variables 
corr grade wage hours ttl_exp tenure
 
//Simple regression which is regression with one regressor or one B(1)
//First variable specified is whatever your y variable is
reg wage ttl_exp

//Regression with the regressors 
//This will change the results from the regressions above
reg wage ttl_exp hours


//regressions with three regressors
//this will impact the results drastically
reg wage ttl_exp hours age 
*Instead we used grade as the regressor because 
*age regresses negatively
reg wage ttl_exp hours grade 

//Let's summarize age and graph age
//to see what's happening with the reg above
summarize age
scatter wage age 

//Based on this we can see that age
*Let's do a scatter plot of age and grade and see what happens instead
scatter grade age

*binscatter takes the average of y values for every x value
binscatter grade age
