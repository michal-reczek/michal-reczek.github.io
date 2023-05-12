* ---------------------------------------------------------------------------- *
* Abortion ban and social change
* MICHAŁ RECZEK
* Università Commerciale Luigi Bocconi
* 2023
* ---------------------------------------------------------------------------- *

* FREQUENCY WEIGHTS - GENERAL
* t-statistic == 2.21 / 2.19

* set up the path
clear all
cd "/Users/michalreczek/Documents/BOCCONI/vienna ceu conference 2023"

* import the dataset
import excel "dt.xlsx", firstrow


* generate variables
gen post=0
replace post=1 if year==2021 | year==2022

gen treat=0
replace treat=1 if country=="Poland"

gen treat_post=treat*post


* filter data and drop redundant variables
keep if question=="always" | question=="circumstances" | /// 
		question=="danger" | question=="never" | question=="denied"

keep if subgroup_name=="general"

* keep if country=="Poland" | country=="France"

 keep if country=="Belgium" | country=="France" | /// 
		country=="Hungary" | country=="Italy" | /// 
		country=="Poland"  | country=="Italy" | /// 
		country=="Spain"  | country=="United States"

keep if year==2020 | year==2021 

replace support=0
replace support=100 if question=="always" | question=="circumstances"


regress support treat post treat_post [fweight=frequency], level(90)

* ------------------------------------------------------------------------------

* FREQUENCY WEIGHTS - gender - standard support
* t-statistic == crazy high

* set up the path
clear all
cd "/Users/michalreczek/Documents/BOCCONI/vienna ceu conference 2023"

* import the dataset
import excel "dt.xlsx", firstrow


* generate variables
gen post=0
replace post=1 if year==2021 | year==2022

gen treat=0
replace treat=1 if country=="Spain"

gen treat_post=treat*post


* filter data and drop redundant variables
keep if question=="always"

keep if subgroup_name=="gender"

* keep if country=="Poland" | country=="France"

 keep if country=="Belgium" | country=="France" | /// 
		country=="Hungary" | country=="Italy" | /// 
		country=="Poland"  | country=="Italy" | /// 
		country=="Spain"  | country=="United States"


keep if year==2020 | year==2021 


regress support treat post treat_post female [fweight=frequency], level(90)

* ------------------------------------------------------------------------------

* FREQUENCY WEIGHTS - AGE
* t-statistic == 2.08

* set up the path
clear all
cd "/Users/michalreczek/Documents/BOCCONI/vienna ceu conference 2023"

* import the dataset
import excel "dt.xlsx", firstrow


* generate variables
gen post=0
replace post=1 if year==2021 | year==2022

gen treat=0
replace treat=1 if country=="Poland"

gen treat_post=treat*post


* filter data and drop redundant variables
keep if question=="always" | question=="circumstances" | /// 
		question=="danger" | question=="never" | question=="denied"

keep if subgroup_name=="age"

keep if country=="Belgium" | country=="France" | /// 
		country=="Hungary" | country=="Italy" | /// 
		country=="Poland"  | country=="Italy" | /// 
		country=="Spain"  | country=="United States"

keep if year==2020 | year==2021 

replace support=0
replace support=100 if question=="always" | question=="circumstances"


regress support treat post treat_post age_35_49 age_50_74 [fweight=frequency], level(90)



* TEX tables -------------------------------------------------------------------

* labeling
lab var support "Support"
lab var treat "Treated"
lab var post "Post October 2020"
lab var treat_post "Treated * Post October 2020"

* generating a descriptive statistics table in latex
est clear
estpost tabstat support treat post treat_post weight, c(stat) stat(sum mean sd min max n)
ereturn list

esttab, cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs

esttab using "./table1.tex", replace /// 
cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") ///
nonumber nomtitle nonote noobs

* does not work properly due to label issues 
* esttab using ".table1.tex", replace cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs label booktabs collabels("Sum" "Mean" "SD" "Min" "Max" "N")

* linear regression 
est clear
eststo: regress support treat post treat_post

* generating a regression table in latex
esttab, b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01)

esttab using "./regression1.tex", replace /// 
b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs ///
title("Basic regression table \label{reg1}")
* /// * addnotes("Data: websuse nlswork" "Second line note")


* ---------------------------------------------------------------------------- *
* Second regression

* set up the path
clear all
cd "/Users/michalreczek/Documents/BOCCONI/vienna ceu conference 2023"

* import the dataset
import excel "dataset.xlsx", sheet("full_dataset") firstrow

* filter data and drop redundant variables
keep if question_id==3 | question_id==6
keep if year==2022 | year==2021 | year==2020 | year==2019 | year==2018
keep support treat post treat_post

* labeling
lab var support "Support"
lab var treat "Treated"
lab var post "Post October 2020"
lab var treat_post "Treated * Post October 2020"

* generating a descriptive statistics table in latex
est clear
estpost tabstat support treat post treat_post, c(stat) stat(sum mean sd min max n)
ereturn list

esttab, cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs

esttab using "./desc_stats_var2.tex", replace /// 
cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") ///
nonumber nomtitle nonote noobs


* linear regression 
est clear
eststo: regress support treat post treat_post

* generating a regression table in latex
esttab, b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01)

esttab using "./regression2.tex", replace /// 
b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs ///
title("Basic regression table \label{reg1}")



* ---------------------------------------------------------------------------- *
* Third regression [crazy p-value hacking]

* set up the path
clear all
cd "/Users/michalreczek/Documents/BOCCONI/vienna ceu conference 2023"

* import the dataset
import excel "dataset.xlsx", sheet("full_dataset") firstrow

* filter data and drop redundant variables
keep if question_id==3 | question_id==4 | question_id==5 | question_id==6
keep if year==2022 | year==2021 | year==2020 | year==2019
keep support treat post treat_post

* labeling
lab var support "Support"
lab var treat "Treated"
lab var post "Post October 2020"
lab var treat_post "Treated * Post October 2020"

* generating a descriptive statistics table in latex
est clear
estpost tabstat support treat post treat_post, c(stat) stat(sum mean sd min max n)
ereturn list

esttab, cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber nomtitle nonote noobs

esttab using "./desc_stats_var2.tex", replace /// 
cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") ///
nonumber nomtitle nonote noobs


* linear regression 
est clear
eststo: regress support treat post treat_post

* generating a regression table in latex
esttab, b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01)

esttab using "./regression2.tex", replace /// 
b(3) se(3) label star(* 0.10 ** 0.05 *** 0.01) ///
booktabs ///
title("Basic regression table \label{reg1}")



