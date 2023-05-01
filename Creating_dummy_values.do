*Remember that stata isn't able to read or understand strings
*So encode is used to help stata read those columns of data
encode county, gen(County)
encode district, gen(District)
encode gr_span, gen(Gr_span)

*Now that we got our new columns we can drop the old ones
drop county-gr_span

*Just to make things conventional we can order the dataset better
*These columns in the front
order observat County District Gr_span

*Here we are running a regression on testscr, and the regressors are avginc 
*And str which is student teacher ratio
*Then we'll run a test for heteroskedasticity  
reg testscr avginc str
estat hettest

*LETS CREATE DUMMY VARIABLES*
summarize str
hist str
*This creates the dummy variable and accounts for when it's not greater than or
*equal to 20
gen large_class = 1 if str >= 20
replace large_class = 0 if str < 20
*Now we'll run a regression on the large class variable instead of the str
regress testscr avginc large_class

*Now a quick test to show how adjusted R-squared works
regress testscr avginc large_class observat
