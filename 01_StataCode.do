******** Stata Conference 2022
******** Visualizing survey data-analysis results: Marrying the best from Stata and R
******** Code written by: Nel Jason L. Haw
******** Last updated: July 25, 2022
******** GENERATION OF DUMBBELL PLOT DATA

******** Change directory based on your local folder - leave blank when making public
cd "C:\Users\neljasonhaw\OneDrive - Johns Hopkins\Dissertation\81 Stata Conference"


******** Setting up and saving log file
clear all
capture log close _all
log using "01 StataCode.log", replace name(Log01_StataCode)
set more off
version 17


******** Load data set and only keep select variables
use "tob_alc_health_final.dta"
rename poor_new2015 poverty
keep id psu weight stratum survey poverty prev_tobacco



******** Survey set declarations
svyset psu [pweight = weight], strata(stratum) singleunit(centered)



*************************************************************************************
******** Store summary data in a new Stata .dta file and this will be fed into the R code to generate the dumbbell plot
postfile dumbbell int survey float (nonpoor poor N) using "dumbbell.dta", replace
// Run summary statistics commands for prevalence
svyset psu [pweight = weight], strata(stratum) singleunit(centered)
svy: mean prev_tobacco, over(survey poverty)
post dumbbell (2012) (e(b)[1,1]) (e(b)[1,2]) (e(_N)[1,1] + e(_N)[1,2])
post dumbbell (2015) (e(b)[1,3]) (e(b)[1,4]) (e(_N)[1,3] + e(_N)[1,4])
post dumbbell (2018) (e(b)[1,5]) (e(b)[1,6]) (e(_N)[1,5] + e(_N)[1,6])
postclose dumbbell

**** Check output
use dumbbell.dta, clear
list

log close Log01_StataCode
