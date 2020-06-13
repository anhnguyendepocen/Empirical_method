cd "C:\EPIC_China_2020\Data"

//import excel "Precipitation.xlsx",clear firstrow

import excel "Test 1-1.xlsx", firstrow clear

sort A

rename D_1 center_D1
rename D_2 center_D2

save "Test 1-1.dta", replace

import excel "Test 1-2.xlsx", firstrow clear

sort A

merge A using "Test 1-1.dta"

//drop _merge
sort A D_1

//ssc install GEODIST
//ssc install VINCENTY

geodist D_1 D_2 center_D1 center_D2, miles generate(distance_mile)
geodist D_1 D_2 center_D1 center_D2, generate(distance_km)

//gen distance_2=(D_1-center_D1)^2+(D_2-center_D2)^2

* From upper to lower, gen accumulate the sum
//bysort A: gen total_dis_2_gen=sum(distance_km)

* By group, gen accumulate the sum
bysort A: egen total_dis_2_egen=sum(distance_km)

gen weight=distance_km/total_dis_2_egen

replace weight=1 if weight==. 
// change the missing value
//mvencode weight, mv(0.999999) 

bysort A: egen prep_weight=sum(prep*weight)
bysort A: egen prep_temp=sum(temp*weight)
drop rand

save "Merged Data.dta",replace

keep A prep_weight prep_temp
duplicates drop
save "Weighted_Prep.dta",replace