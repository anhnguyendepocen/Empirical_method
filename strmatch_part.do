* Row 1-1000

import excel "~\Contract_Bidders_All_wenwei_for_manual_cleaning1-1000.xlsx", sheet("Sheet1") firstrow clear

gen same_as = strmatch(company,"*"+company_core+"*")

export excel using "~\check.xlsx", replace
 
* Row 1001-end 

import excel "~", sheet("Sheet1") firstrow clear

gen same_as = strmatch(company,"*"+company_core+"*")

export excel using "~", replace
