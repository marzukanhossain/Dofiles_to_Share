/******************************************************************************************************************
*Title: 20221107_Phone-Survey_Sample_Primary_Analysis
*Created by: Marzuk
*Created on: November 7, 2022
*Last Modified on:  November 7, 2022
*Last Modified by: 	Marzuk
*Purpose :  Primary analysis of the phone survey data
	
*****************************************************************************************************************/
	*clear all
	set more off
	capture log close
	set logtype text

	local date=c(current_date)
	local time=c(current_time)
	
	**Appropriate directory based on user
	
	if "`c(username)'"=="KWR"  {
	
			global base_dir "H:/.shortcut-targets-by-id/1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW" 
			
	}
	else if "`c(username)'"=="marzu" {
	
			global base_dir "G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW"
			
	}
	else if "`c(username)'"=="User" {
	
			global base_dir "G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW"
			
	}
			
	global proj_dir 	"$base_dir\1.3.3 World Fish"
	
	global data_dir   		"$proj_dir\04_Data"
	
	global listing_data  "$data_dir\01_TRK_Initial_Listing_Survey"
	
	global Phone_Survey_data 	"$data_dir\03_Phone_Survey"

	global In_Person_Survey		"$data_dir\04_In_Person_Survey"
	
	global Phone_Survey_sample	"$Phone_Survey_data\01_Selected-Sample"
	
	global Phone_Survey_raw		"$Phone_Survey_data\02_Raw_Data"
	
	global Phone_Survey_clean		"$Phone_Survey_data\03_Cleaned_Data"
	
	global Phone_Survey_A_D	"$Phone_Survey_data\04_Analysis_Data"
	
	global In_Person_sample	"$In_Person_Survey\01_Selected_Sample"
	
	global In_Person_raw		"$In_Person_Survey\02_Raw_Data"
	
	global In_Person_clean		"$In_Person_Survey\03_Cleaned_Data"
	
	global In_Person_A_D		"$In_Person_Survey\04_Analysis_Data"
	 
	global do_dir  			"$proj_dir\05_Code"
	
			
			
	use "$Phone_Survey_clean\20221120_Aquaculture_Training_Evaluation_Cleaned_For_Analysis.dta", clear
	
	tab treatment
	
	tab treat_old
	
	drop if _merge != 3 
	
	drop _merge
	
	count if q9 != res_age
	
	*drop q9
		
	****Primary Analysis

		
	gen ssc_lvl = pq1>=10
	
	lab var ssc_lvl "At least SSC level completed"

	gen youth_yngr = res_age<=35
	
	lab var youth_yngr "35 years old or younger"
	
	gen youth_oldr = res_age<=40
	
	lab var youth_oldr "40 years old or younger"
	
	
	*keep if youth_yngr==1

	*keep if youth_oldr==1
	
	*keep if ssc_lvl==1
	
	local v1 "pq11 pq12 pq13 pq15 pq16 pq17 pq18"
	/*
	gen uptake1 = 0
	
	foreach x of varlist `v1' {
	
	replace uptake1 = uptake+1 if `x'==1
	
	*reg `x' treat_old 
	
	}
	
	reg uptake1 treat_old
	*/
	/*
	foreach x of local v1 {
		
		gen `x'_upt = 1 if `x' == 1 //& !missing(`x')
		
		reg `x' treat_old 
	
	}
	
	egen uptake2 = rowtotal(*upt)
	
	reg uptake2 treat_old
	*/
	
	local a = 0
	
	foreach x of local v1 {
		
		gen `x'_up = `x' == 1 
		
		reg `x' treat_old 
	
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_up "`s'"
		
		local a = `a' + 1
		
	}
	
	di "`a'"
	
	egen uptake = rowtotal(*up)
	
	gen pp_uptake = uptake/`a'  //* 7 is the total number of components of social media usage composite variable
	
	label variable uptake "Social Media Usage Index"
	
	label variable pp_uptake "(Social Media Usage Index) / 7 (total no. of components)"
		
	areg uptake treat_old, absorb(union_cd) vce(robust)
	
	factor *up, pcf
	
	predict up
	
	label variable up "Principal component factor analysis of social media usage index"
	
	cor uptake up
	
	reghdfe uptake treat_old, absorb(union_cd) vce(robust)
	
	reghdfe up treat_old, absorb(union_cd) vce(robust)
	
	reghdfe pp_uptake treat_old, absorb(union_cd) vce(robust)
	
	
	
	local v2 "pq14 pq19 pq20 pq21 pq22 pq23 pq24 pq24a_2 pq24a_5 pq24a_6 pq25 pq26_3 pq26_4 pq26_6 pq26_9 pq27 pq28_1 pq28_3 pq28_5 pq28_7 pq28_9 pq29 pq30 pq31 pq32 pq32a_2 pq32a_3 pq33_2 pq33_3 pq35 pq35a_1 pq35a_2 pq38 pq39"
	
	local v3 "pq34 pq36 pq37 pq38c" 
	
	local v4 "pq27b pq38d pq38e"
	
	local v5 "pq24b pq30a pq38a pq38f pq39a pq39c"
		
	
	/*
	gen knowledge1 = 0
	
	foreach y of local v2 {
	
	replace knowledge1 = knowledge1+1 if `y'==1
	
	*reg `y' treat_old 
	
	}
	
	
	foreach y of varlist `v3' {
	
	replace knowledge1 = knowledge1+1 if `y'==1
	
	}
	
	
	foreach z of local v4 {
	
	replace knowledge1 = knowledge1+1 if `z'==2
	
	}
	
	
	replace knowledge1 = knowledge1+1 if pq24b==0
	
	replace knowledge1 = knowledge1+1 if pq38a==3
	
	replace knowledge1 = knowledge1+1 if pq39a==3
	
	replace knowledge1 = knowledge1+1 if pq39c==4
	
	reg knowledge1 treat_old
	*/
	
	
	/*
	foreach y of local v2 {
		
		gen `y'_kno = 1 if `y' == 1
		
	*	reg `y' treat_old
		
	}
	
	foreach y of local v3 {

		gen `y'_kno = 1 if `y' == 1
		
	*	reg `y'_kno treat_old
		
		
	}		
		
	
	foreach y of local v4 {
		
		gen `y'_kno = 1 if `y' == 2
		
	*	reg `y'_kno treat_old
		
	}	
	
	gen pq24b_kno = 1 if pq24b == 0
	
	gen pq38a_kno = 1 if pq38a == 3
	
	gen pq39a_kno = 1 if pq39a == 3
	
	gen pq39c_kno = 1 if pq39c == 4
		
	egen knowledge2 = rowtotal(*kno)
	
	reg knowledge2 treat_old
	
	foreach var of varlist *kno{
      recode `var' .=0
	  }

	factor *kno, pcf
	
	predict kno
	
	cor knowledge kno
	
	reg knowledge treat_old
	
	reg kno treat_old
	
	areg knowledge treat_old, absorb (upaz_code)
	
	*/
	
	local a = 0
	
	foreach y of local v2 {
		
		gen `y'_kn = `y' == 1
		
	*	reg `y' treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_kn "`s'"
		
		local a = `a' + 1
		
	}
	
	foreach y of local v3 {

		gen `y'_kn = `y' == 1
		
	*	reg `y'_kn treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_kn "`s'"
				
		local a = `a' + 1
		
	}		
		
	
	foreach y of local v4 {
		
		gen `y'_kn = `y' == 2
		
	*	reg `y'_kn treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_kn "`s'"
		
		local a = `a' + 1
		
	}	
			
	gen pq24b_kn = pq24b == 0
	
	gen pq30a_kn = pq30a == 1 | pq30a == 2 | pq30a == 5
	
	gen pq38a_kn = pq38a == 3
	
	gen pq38f_kn = pq38f == 1 | pq38f == 3
	
	gen pq39a_kn = pq39a == 3
	
	gen pq39c_kn = pq39c == 4
	
	foreach y of local v5 {
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_kn "`s'"
	
		local a = `a' + 1
	
	}
	
	di "`a'"
	
	egen knowledge = rowtotal(*kn)
	
	gen pp_knowledge = knowledge/`a' //* total number of components of knowledge composite is 47
	
	label variable knowledge "Knowledge Index"
			
	label variable pp_knowledge "(Knowledge Index) / 47 (total no. of components)"
		
	reg knowledge treat_old
	
	
	factor *kn, pcf
	
	predict kn
	
	label variable kn "Principal component factor analysis of knowledge index"
	
	cor knowledge kn
	
	reghdfe knowledge treat_old, absorb(union_cd) vce(robust)
	
	reghdfe kn treat_old, absorb (union_cd) vce(robust)
	
	reghdfe pp_knowledge treat_old, absorb(union_cd) vce(robust)
	
	
	
	
	
	
	
	local v6 "pq14 pq19"
	
	local a = 0
	
	foreach y of local v6 {
		
		gen `y'_smp = `y' == 1
		
	*	reg `y' treat_old
		
		local s: var lab `y'
	
		label variable `y'_smp "`s'"
		
		local a = `a' + 1
		
	}
	
	di "`a'"
	
	egen know_smp = rowtotal(*smp)
	
	gen pp_know_smp = know_smp/`a' //* total number of components of knowledge from social media post composite are 2
	
	
	label variable know_smp "Knowledge from social media posts index (smpi)"
			
	label variable pp_know_smp "(Knowledge from smpi) / 2 (no. of components)"
	
	
	
	reg know_smp treat_old
	
	
	factor *smp, pcf
	
	predict smp
	
	label variable smp "Principal component factor analysis of knowledge from smp composite"
	
	cor know_smp smp
	
	reghdfe know_smp treat_old, absorb(union_cd) vce(robust)
	
	reghdfe smp treat_old, absorb (union_cd) vce(robust)
	
	reghdfe pp_know_smp treat_old, absorb(union_cd) vce(robust)
	
	
	
	
	local v2 "pq20 pq21 pq22 pq23 pq24 pq24a_2 pq24a_5 pq24a_6 pq25 pq26_3 pq26_4 pq26_6 pq26_9 pq27 pq28_1 pq28_3 pq28_5 pq28_7 pq28_9 pq29 pq30 pq31 pq32 pq32a_2 pq32a_3 pq33_2 pq33_3 pq35 pq35a_1 pq35a_2 pq38 pq39"
	
	local v3 "pq34 pq36 pq37 pq38c" 
	
	local v4 "pq27b pq38d pq38e"
	
	local v5 "pq24b pq30a pq38a pq38f pq39a pq39c"
		
	local a = 0
	
	foreach y of local v2 {
		
		gen `y'_smv = `y' == 1
		
	*	reg `y' treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_smv "`s'"
		
		local a = `a' + 1
		
	}
	
	foreach y of local v3 {

		gen `y'_smv = `y' == 1
		
	*	reg `y'_kn treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_smv "`s'"
		
		local a = `a' + 1
		
	}		
		
	
	foreach y of local v4 {
		
		gen `y'_smv = `y' == 2
		
	*	reg `y'_kn treat_old
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_smv "`s'"
		
		local a = `a' + 1
		
	}	
			
	gen pq24b_smv = pq24b == 0
	
	gen pq30a_smv = pq30a == 1 | pq30a == 2 | pq30a == 5
	
	gen pq38a_smv = pq38a == 3
	
	gen pq38f_smv = pq38f == 1 | pq38f == 3
	
	gen pq39a_smv = pq39a == 3
	
	gen pq39c_smv = pq39c == 4
	
	foreach y of local v5 {
		
		qui describe `y'
	
		local s: var lab `y'
	
		label variable `y'_smv "`s'"
	
		local a = `a' + 1
	
	}
	
	di "`a'"	
	
	egen know_smv = rowtotal(*smv)
	
	gen pp_know_smv = know_smv/45 //* total number of components of knowledge from smv composite are 45
	
	label variable know_smv "Knowledge from social media videos index (smvi)"
			
	label variable pp_know_smv "(Knowledge from smvi) / 45 (no. of components)"
		
	reg know_smv treat_old
	
	
	factor *smv, pcf
	
	predict smv
	
	label variable smv "Principal component factor analysis of knowledge from smvi"
	
	cor know_smv smv
	
	reghdfe know_smv treat_old, absorb(union_cd) vce(robust)
	
	reghdfe smv treat_old, absorb(union_cd) vce(robust)
	
	reghdfe pp_know_smv treat_old, absorb(union_cd) vce(robust)
	
	
	sort idno
	
	
	save "$Phone_Survey_A_D\20221107_Aquaculture_Training_Evaluation_Analysed_Data.dta", replace
	
	
	
