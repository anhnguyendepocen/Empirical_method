import excel "Test 2-1.xlsx",clear firstrow

//gen permonth_mean=0
//gen permonth_weight=0

geodist px py cx cy,gen(dist) miles

drop rand prep_base temp_base

* define the total weight
* extent the same month and position and then sum them
* 1 2 1
* 1 2 2
* 1 2 3 sum is 6
bysort month position: egen total_dis_reverse= sum(1/dist)

* the weight
bysort month position: gen weight_bypm=(1/dist)/total_dis_reverse

* test it
bysort month position: egen test=sum(weight_bypm)
drop test

* weighted indi
gen weighted_p=weight_bypm*prep
gen weighted_t=weight_bypm*temp

* weight sum
bysort month position: egen wsum_prep=sum(weighted_p)
bysort month position: egen wsum_temp=sum(weighted_t)

//sepscatter prep month, separate(position)
//twoway (line price weight if foreign==1, sort) (line price weight if foreign==0, sort)
twoway (scatter prep month if position==1)(scatter prep month if position==2)(scatter prep month if position==3),legend(label(1 "Position1") label(2 "Position2") label(3 "Position3"))

save "EPIC_test2.dta",replace
* ssc install sepscatter




//drop weighted_p weighted_t cx cy px py dist weight_bypm total_dis_reverse temp prep year

//sort position month

//duplicates drop



//foreach v of varlist X

/*
//city
forvalues i=1/7{
//time	
	forvalues j=1/6 {
	replace permonth_weight=(1/Dis)/sum(1/Dis) if A=`i' and time=`j' in 1
	}
	}
	*/