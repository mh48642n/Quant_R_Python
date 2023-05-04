*This will place the line of best fit over the scatter graph
twoway(scatter testscr avginc)(lfit testscr avginc)
reg testscr avginc

*This creates a parabolic line of best fit over the graph from before
twoway(scatter testscr avginc)(lfit testscr avginc)(qfit testscr avginc)

reg testscr c.avginc##c.avginc

gen ln_testscr= ln(testscr)
gen ln_avginc = ln(avginc)

scatter ln_testscr ln_avginc

*Linear-log
reg testscr ln_avginc
*Log-linear
reg ln_testscr avginc
*Log-log
reg ln_testscr ln_avginc

gen hi_str = 1 if str >= 20
replace hi_str = 0 if str < 20 

gen hi_el = 1 if el_pct >= 10
replace hi_el = 0 if el_pct < 10 

*Interaction between two dummy variables 
reg testscr i.hi_str##i.hi_el
margins hi_str#hi_el

marginsplot

reg testscr avginc hi_str

*twoway(line testscr avginc if hi_str==1)(line testscr avginc if hi_str == 0)

reg testscr c.avginc##i.hi_str
*Taking the margin of hi_str for each avginc level starting at 5 ending at 21
margins hi_str, at (avginc = (5 (2) 21))

marginsplot
