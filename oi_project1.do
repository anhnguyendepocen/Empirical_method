clear
use "~Project1\atlas.dta"

* list all people of the same country and state

* kfr_pooled_p25: Household income ($) at age 31-37 for children with parents 
* at the 25th percentile of the national income distribution

list kfr_pooled_p25 if state == 1 & county == 1

* std
*  are weights that are inversely proportional to the variance of an observation;
* count_pooled: Count of all children
sum kfr_pooled_p25 if state == 1 [aweight = count_pooled]
// sum kfr_pooled_p25 if state == 1 & county == 1 [aweight = count_pooled]

// reg kfr_pooled_p25 kfr_pooled_p100, r


//twoway (scatter kfr_pooled_p25 kfr_pooled_p75) (lfit  kfr_pooled_p25 kfr_pooled_p75)

//twoway (scatter kfr_pooled_p25 kfr_pooled_p100) (lfit  kfr_pooled_p25 kfr_pooled_p100)

xtset state
reg kfr_pooled_p25 kfr_pooled_p75, r
xtreg kfr_pooled_p25 kfr_pooled_p75,fe r

// Step 1: Space difference
// hhinc_mean2000: Mean Household Income 2000 
reg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010,  r
xtreg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010, fe r


// Step 2: Poor
reg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010 poor_share2000, r
xtreg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010 poor_share2000, fe r


// Step 3: Race
reg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010 poor_share2000 share_black2000, r
xtreg kfr_pooled_p25 kfr_pooled_p75 hhinc_mean2000 popdensity2010 poor_share2000 share_black2000, fe r

// Cause and Effect
reg kfr_pooled_p25 hhinc_mean2000 popdensity2010 poor_share2000 share_black2000, r
xtreg kfr_pooled_p25 hhinc_mean2000 popdensity2010 poor_share2000 share_black2000, fe r