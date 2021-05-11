*********************************
* Section F *********************
* Week 7 ********************** *
* Replication Code and Examples *
* Poli 30, Spring 2021 ******** *
*********************************
** You'll need to install two packages for this to run straight through.
** Requires catplot for one of the bar charts:
* ssc install catplot
** I also use blind schemes by Daniel Bischof for the section slides:
* ssc install blindschemes, replace all

clear all

**********
* Graphs *
**********
* Scatter Plots
sysuse nlsw88

lab var wage "Hourly Wage (in $)"
lab var ttl_exp "Total Work Experience (in Years)"

twoway (scatter wage ttl_exp), ///
scheme(plotplainblind)

twoway (scatter wage ttl_exp, mcolor(%10)) ///
(lfit wage ttl_exp, lcolor(red)), ///
legend(off) ytitle("Hourly Wage (in $)") ///
scheme(plotplainblind)

twoway (scatter wage ttl_exp), ///
by(industry, note("")) ///
scheme(plotplainblind)

* Line Graphs
sysuse uslifeexp, clear
lab var le "Life Expectancy (in Years)"

// Simple Line Graph
twoway (line le year), ///
xlab(1900(10)2000) ///
xline(1918) ///
text(65 1919.5 "1918 Flu Pandemic", place(n) orient(vertical) size(small)) ///
title("U.S. Life Expectancy, 1900 - 1999") ///
scheme(plotplainblind)

// Multiple Lines
lab var le "Total Population"
lab var le_male "All Males"
lab var le_wmale "White Males"
lab var le_bmale "Black Males"

twoway (line le year) ///
(line le_male year) ///
(line le_wmale year)  ///
(line le_bmale year), ///
legend(pos(6) rows(1) size(vsmall)) ///
xlab(1900(10)2000) ///
title("U.S. Life Expectancy, 1900 - 1999") ///
scheme(plotplainblind)
 
* Bar Charts
// Simple Bar Chart
sysuse nlsw88, clear
lab var industry "Industry"

catplot industry, ///
var1opts(sort(1)) ///
blab(total, size(vsmall)) ///
ytitle("Frequency") ///
title("Survey Respondents by Industry") ///
scheme(plotplainblind)

// Complex Bar Chart
sysuse voter, clear
sort candidat inc

graph bar (asis) pfrac, ///
by(candidat, note("") title("Votes Cast by Candiate and Income Bracket, 1992 Election") rows(3)) ///
over(inc) blab(total) ytitle("Percecnt of Total") ///
scheme(plotplainblind)

// Fake Bar Chart
clear all
input str2 letter number
"A"	55
"B"	56
"C"	64
"D" 57
"E" 59
end

graph bar (asis) number, over(letter) ///
ysc(r(54 66)) exclude0 ylab(54(2)66) ///
blab(total) ///
title("This Chart Empahsizes the Extreme Value of C") ///
scheme(plotplainblind)

graph bar (asis) number, over(letter) ///
ylab(0(10)100) ///
blab(total) ///
title("This Chart Implies More Uniformity") ///
scheme(plotplainblind)

graph bar (asis) number, over(letter) ///
ylab(0(1000)5000) ///
blab(total) ///
title("This Chart Gives the Perception of Equivalence") ///
scheme(plotplainblind)


**********************
* Hypothesis Testing *
**********************
* Difference of Means
// Bring in the Data
clear all
use "https://www.stata-press.com/data/r16/iris"

// Cleaning Up
egen igroup = group(iris)

gen igroup2 = igroup if igroup != 2
lab define ig2 1 "Setosa" 3 "Virginica"
lab values igroup2 ig2

// Summarize the Data
bysort igroup2: sum seplen

// Plot the Data
twoway ///
(hist seplen, width(.2)), ///
by(igroup2, note("") rows(2)) ///
xtitle("Sepal Length in Centimeters") ///
scheme(plotplainblind)

// Is there a Difference of Means?
ttest seplen, by(igroup2)

* Difference in Slopes
clear all
sysuse auto

// Plot the Data
twoway ///
(scatter mpg weight) ///
(lfit mpg weight), ///
title("Auto Data: Gas Mileage by Weight") ///
legend(order(2 "OLS Regression Line: {&beta} = -0.006") pos(6) rows(1)) ///
ytitle("Mileage (mpg)") ///
yline(25) text(26 3700 "Slope under the Null Hypothesis: {&beta} = 0", place(e) size(small)) ///
scheme(plotplainblind)

// Is the Slope Significantly Different From Zero?
sum mpg weight
reg mpg weight

// Where are these Standard Errors Coming From?
// This is more math than you need to know, but may be worth walking through:
gen yhat = 39.44028 - (.0060087 * weight) // Calculate y-hat
gen ssresid = (mpg - yhat)^2 // Calculate the squared deviation of y from y-hat
egen s_ssr = sum(ssresid) // Sum up these squared deviations
gen msresid = sqrt(s_ssr / 72) // Divide these squared deviations by (n - 2) and take the root

gen x2 = (weight - 3019.459)^2 // Now we need to square our x's deviations from the mean
egen s_x2 = sum(x2) // And get the sum of squares
replace s_x2 = sqrt(s_x2) // Take the root

gen stderr = msresid / s_x2 // And now divide
// compare the value of "stderr" with standard error of the "weight" coefficient 
// How about the confidence intervals?
dis -.0060087 - (2 * .0005179)
dis -.0060087 + (2 * .0005179)


**************
* Regression *
**************
clear all

// Enter Some Data
input x	y str10 coords
7	11	"(7, 11)"
4	3	"(4, 3)"
6	5	"(6, 5)"
3	4	"(3, 4)"
5	7	"(5, 7)"
end

// Plot the Data
twoway ///
(scatter y x, mlab(coords) mlabsize(tiny) mlabp(2) mlabang(45)) ///
(lfit y x, range(2 8)), ///
xlab(0(1)10) ///
ylab(0(1)12) ///
ytitle("y") ///
title("Fake Data") ///
legend(off) ///
scheme(plotplainblind)

// Does the Regression Line Match What We Calculated?
reg y x



