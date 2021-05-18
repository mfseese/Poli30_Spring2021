*********************************
* Section G *********************
* Week 8 ********************** *
* Replication Code and Examples *
* Poli 30, Spring 2021 ******** *
*********************************
clear all

**********************************
* Intepreting Regression Results *
**********************************
sysuse auto

// Plot the Data
twoway ///
(scatter price weight) ///
(lfit price weight), ///
legend(order(2 "OLS Regression Line: {&beta} = 2.044") pos(6)) ///
ytitle("Price") ///
scheme(plotplainblind)

// Run the Regression
reg price weight

coefplot, ///
drop(_cons) ///
xlab(-1(.5)3) ///
xline(0) ///
mlab("{&beta} = 2.044") mlabpos(12) ///
scheme(plotplainblind)


*******************
* Dummy Variables *
*******************
// Plot the Data by Import Status
twoway ///
(scatter price weight if foreign == 0) ///
(lfit price weight) ///
(scatter price weight if foreign == 1), ///
legend(order(1 "Domestic" 3 "Foreign") pos(6) rows(1)) ///
ytitle("Price") ///
scheme(plotplainblind)

// Run the Regression
reg price weight foreign

// Plot Regression Line by Import Status
twoway ///
(scatter price weight if foreign == 0) ///
(scatter price weight if foreign == 1) ///
(function y = -4942.844 + 3.320737 * x, range(1750 5000)) ///
(function y = (-4942.844 + 3637.001) + 3.320737 * x, range(1750 5000)), ///
legend(order(1 "Domestic" 2 "Foreign" 3 "Import Status = Domestic" 4 "Import Status = Foreign") pos(6) rows(1) size(vsmall)) ///
ytitle("Price") ///
scheme(plottig)

twoway ///
(scatter price weight if foreign == 0) ///
(scatter price weight if foreign == 1) ///
(function y = -4942.844 + 3.320737 * x, range(1750 5000)) ///
(function y = (-4942.844 + 3637.001) + 3.320737 * x, range(1750 5000)) ///
(lfit price weight), ///
legend(order(1 "Domestic" 2 "Foreign" 3 "Import Status = Domestic" 4 "Import Status = Foreign" 5 "Original OLS") pos(6) rows(1) size(vsmall)) ///
ytitle("Price") ///
scheme(plottig)


*************
* Confounds *
*************
clear all
sysuse nlsw88

lab var wage "Hourly Wage (in $)"
lab var ttl_exp "Total Work Experience (in Years)"
lab var grade "Education (Grade Completed)"

rename ttl_exp experience
rename grade education

// graph3d experience wage education, cuboid colorscheme(bcgyr) 
// graph3d experience wage education, cuboid colorscheme(bcgyr) ///
// markeroptions(msize(tiny))

reg wage experience education

margins, at(experience = (0(2)30) education = (0(6)18))
marginsplot, noci ///
ytitle("Predicted Hourly Wage (in $)") ///
legend(order(1 "No Education" 2 "Grade 6" 3 "High School" 4 "Undergraduate") pos(6) rows(1)) ///
scheme(plotplainblind)




