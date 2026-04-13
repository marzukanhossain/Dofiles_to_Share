/******************************************************************************************************************
*Title: 20230511_In_Person_Survey_Primary_Analysis
*Created by: Marzuk
*Created on: May 11, 2023
*Last Modified on:  May 11, 2023
*Last Modified by: 	Marzuk
*Purpose :  Priimary Analysis after in-person survey
	
*****************************************************************************************************************/
	clear all
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
	
	
	
	
	local b "ab"
	
	foreach x of numlist 1/5{
		
		local b "`b'&`x'"
	}
	
	
	di "`b'"
	
	
	
	
	use "$In_Person_clean\20230505_ATE_IP_Analysis_Ready.dta", clear
	
	
	
	
	
	
	
	/*
	tab2xl ip12 treatment using treat_ctrl_mis, col(1) row(1)
	
	
	tab2xl ip14 if treatment==0 & ip12==1 using treat_ctrl_mis, col(1) row(11)
	
	
	tab2xl ip15 if treatment==0 & ip12==1 using treat_ctrl_mis, col(1) row(21)
	
	
	tab2xl ip15a if treatment==0 & ip12==1 using treat_ctrl_mis, col(1) row(31)
	
	
	tab2xl ip15 if treatment==1 using treat_ctrl_mis, col(1) row(41)
	
	
	tab2xl ip15a if treatment==1 using treat_ctrl_mis, col(1) row(51)
	*/
	
	/*
	drop if inlist(union_cd, 16, 22, 24) //these three singleton observations are dropped during reghdfe
	*/
	
**# Social Media Usage Index #1
	**** For socila media usage
	
	local v1 "ip21 ip22 ip23 ip25 ip26 ip27 ip28"
	
	
	local a = 0
	
	foreach x of local v1 {
		
		gen `x'_ipupt = `x' == 1 
		
		reghdfe `x'_ipupt treatment, absorb(union_cd) vce(robust)
	
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipupt "`s'"
		
		local a = `a' + 1
	}
	
	di `a'
	
	egen uptake_total_ipupt = rowtotal(*ipupt)
	
	gen uptake_ipupt = uptake_total_ipupt/`a' 
	//Social Media Index contains 7 items
	
	label variable uptake_ipupt "Social Media Usage"
	
	reghdfe uptake_ipupt treatment, absorb(union_cd) vce(robust)
	
	gen ins = ip15==1
	
	ivreg uptake_ipupt (ins=treatment), first
	
	
	
**# Knowledge Index #2
	****For knowledge index
	
	local v2 "ip24	ip29 ip30a	ip31a	ip32a	ip33a	ip34a	ip35a	ip36 ip40a	ip41a	ip42a	ip43	ip46a	ip47	ip48a ip34b_2 ip34b_5 ip34b_6 ip35b_3 ip35b_4 ip35b_6 ip35b_9 ip35d_1 ip35d_2 ip35d_3 ip35d_4 ip35d_5 ip35d_6 ip35f_1 ip35f_2 ip35f_3 ip37_2 ip37_4 ip37_6 ip37_7 ip37_9 ip37_11 ip39_1 ip39_3 ip39_5 ip39_7 ip39_9 ip40b_1 ip40b_2 ip40b_3 ip40b_4 ip40b_5 ip41b_1 ip41b_2 ip41b_3 ip41b_4 ip42b_1 ip42b_2 ip42b_3 ip42b_4 ip42b_5 ip42b_6 ip42b_7 ip43a_2 ip43a_3 ip46e_1 ip46e_2 ip46e_3 ip49f_1 ip49f_2 ip49f_3 ip49f_4 ip49f_5 ip49f_6"
	
	
	
	local a = 0
	
	local x "ip34d"
	
	gen `x'_ipkno = `x' == 0 
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"

	local a = `a' + 1
	
	
	
	local x "ip35g"
	
	gen `x'_ipkno = `x' == 2 
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
	
	local x "ip38"
	
	gen `x'_ipkno = `x' == 2 
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
	
	local x "ip41c"
	
	gen `x'_ipkno = `x' == 1 | `x' == 2 | `x' == 5    
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
	
	
	local x "ip44a_2"
	
	gen `x'_ipkno = `x' == 1 | ip44a_r2_2 == 1   
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
		
	local x "ip44a_3"
	
	gen `x'_ipkno = `x' == 1 | ip44a_r2_3 == 1   
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
	
	
	local x "ip45"
	
	gen `x'_ipkno = `x' == 1 | ip45_r2 == 1   
		
	reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipkno "`s'"
	
	local a = `a' + 1
	
	
	
	foreach x of local v2 {
		
		gen `x'_ipkno = `x' == 1 
		
		reghdfe `x'_ipkno treatment, absorb(union_cd) vce(robust)
	
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipkno "`s'"
		
		local a = `a' + 1
	}
	
	di `a'
	
	egen knowledge_total_ipkno = rowtotal(*ipkno)
	
	gen knowledge_ipkno = knowledge_total_ipkno/`a'
	// The knowledge index contains 77 items.
	
	label variable knowledge_ipkno "Knowledge"
	
	reghdfe knowledge_ipkno treatment, absorb(union_cd) vce(robust)
	
	
	
	
	local v3 "ip24 ip29"
	
	local a = 0
	
	foreach x of local v3 {
		
		gen `x'_ipkns = `x' == 1 
		
		reghdfe `x'_ipkns treatment, absorb(union_cd) vce(robust)
	
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipkns "`s'"
		
		local a = `a' + 1
	}
	
	di `a'
	
	egen know_static_total_ipkns = rowtotal(*ipkns)
	
	gen know_static_ipkns = know_static_total_ipkns/`a'
	
	
	label variable know_static_ipkns "Knowledge from Static Posts"
	
	reghdfe know_static_ipkns treatment, absorb(union_cd) vce(robust)
	
	ivreg know_static_ipkns (ins=treatment), first
	
	
	local v4 "ip30a	ip31a	ip32a	ip33a	ip34a	ip35a	ip36 ip40a	ip41a	ip42a	ip43	ip46a	ip47	ip48a ip34b_2 ip34b_5 ip34b_6 ip35b_3 ip35b_4 ip35b_6 ip35b_9 ip35d_1 ip35d_2 ip35d_3 ip35d_4 ip35d_5 ip35d_6 ip35f_1 ip35f_2 ip35f_3 ip37_2 ip37_4 ip37_6 ip37_7 ip37_9 ip37_11 ip39_1 ip39_3 ip39_5 ip39_7 ip39_9 ip40b_1 ip40b_2 ip40b_3 ip40b_4 ip40b_5 ip41b_1 ip41b_2 ip41b_3 ip41b_4 ip42b_1 ip42b_2 ip42b_3 ip42b_4 ip42b_5 ip42b_6 ip42b_7 ip43a_2 ip43a_3 ip46e_1 ip46e_2 ip46e_3 ip49f_1 ip49f_2 ip49f_3 ip49f_4 ip49f_5 ip49f_6"
	
	
	
	local a = 0
	
	local x "ip34d"
	
	gen `x'_ipknv = `x' == 0 
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"

	local a = `a' + 1
	
	
	
	local x "ip35g"
	
	gen `x'_ipknv = `x' == 2 
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
	
	local x "ip38"
	
	gen `x'_ipknv = `x' == 2 
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
	
	local x "ip41c"
	
	gen `x'_ipknv = `x' == 1 | `x' == 2 | `x' == 5    
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
	
	
	local x "ip44a_2"
	
	gen `x'_ipknv = `x' == 1 | ip44a_r2_2 == 1   
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
		
	local x "ip44a_3"
	
	gen `x'_ipknv = `x' == 1 | ip44a_r2_3 == 1   
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
	
	
	local x "ip45"
	
	gen `x'_ipknv = `x' == 1 | ip45_r2 == 1   
		
	reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipknv "`s'"
	
	local a = `a' + 1
	
	
	
	foreach x of local v2 {
		
		gen `x'_ipknv = `x' == 1 
		
		reghdfe `x'_ipknv treatment, absorb(union_cd) vce(robust)
	
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipknv "`s'"
		
		local a = `a' + 1
	}
	
	di `a'
	
	egen know_video_total_ipknv = rowtotal(*ipknv)
	
	gen know_video_ipknv = know_video_total_ipknv/`a'
	
	
	label variable know_video_ipknv "Knowledge from Video Posts"
	
	reghdfe know_video_ipknv treatment, absorb(union_cd) vce(robust)
	
	
	ivreg know_video_ipknv (ins=treatment), first
	
	
	
	local v5 "uptake_ipupt know_video_ipknv know_static_ipkns knowledge_ipkno"
	
	
	foreach x of local v5 {
		
		ttest `x', by(treatment)
	
		reghdfe `x' treatment, absorb(upazilla) vce(robust)
		
		lincom _cons
		
		return list
		
	}
	
	
	
	gen ipspo = ip10 == 1
	
	gen int_ipspo_treat = ipspo * treatment
	
	
	foreach x of local v5 {
		
		ttest `x', by(treatment)
	
		reghdfe `x' treatment ipspo int_ipspo_treat, absorb(union_cd) vce(robust)
	
	}
	
	
	
	
	*******phone survey social media usage*******
	

	
	label variable pp_uptake "Social Media Usage"
	
	reghdfe pp_uptake treatment, absorb(union_cd) vce(robust)
	
	
	
	
	
	******phone survey knowledge*******
	
	

	label variable pp_knowledge "Knowledge"
		
	
	reghdfe pp_knowledge treatment, absorb(union_cd) vce(robust)
	
	
	
	
	******Farming practices*******
	
	/*
	drop if inlist(union_cd, 16, 22, 24) //these three singleton observations are dropped during reghdfe
	*/
	
	local v1 "ip24a ip29b ip30	ip31	ip32	ip33	ip34 ip34c	ip35	ip36a	ip40	ip41	ip42	ip46 ip46b_1 ip46b_2 ip46d_1 ip46d_2 ip46d_3 ip46d_4 ip46d_5 ip46d_6	ip48	ip49 ip49b ip49e_1 ip49e_3	ip50"

		
	local v2 "ip49c ip49d"
	
	
	local v3 "ip46c ip49a ip50a"
	
	
	local a = 0
	
		local x "ip50b"
	
		gen `x'_ippr = `x' == 4 
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ippr "`s'"
		
		reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	
	local x "ip44_2"
	
	gen `x'_ippr = `x' == 1 | ip44_r2_2 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ippr "`s'"
		
	reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	local x "ip44_3"
	
	gen `x'_ippr = `x' == 1 | ip44_r2_3 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ippr "`s'"
		
	reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	local x "ip45a"
	
	gen `x'_ippr = `x' == 1 | ip45a_r2 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ippr "`s'"
		
	reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	foreach x of local v3 {
		
		gen `x'_ippr = `x' == 3
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ippr "`s'"
		
		reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	foreach x of local v2 {
		
		gen `x'_ippr = `x' == 2
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ippr "`s'"
		
		reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	
	
	foreach x of local v1 {
		
		gen `x'_ippr = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ippr "`s'"
		
		reghdfe `x'_ippr treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ippr = rowtotal(*ippr)
	
	gen practice_ippr = prac_total_ippr/`a'
	
	
	label variable practice_ippr "Farming Practice"
	
	reghdfe practice_ippr treatment, absorb(union_cd) vce(robust)
	
	
	ivreg practice_ippr (ins=treatment), first
	
	
	
	*******Best Practices adopted from static posts
	
	local a = 0
	
	local v1 "ip24a ip29b"
	
	foreach x of local v1 {
		
		gen `x'_ipprs = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprs "`s'"
		
		reghdfe `x'_ipprs treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ipprs = rowtotal(*ipprs)
	
	gen practice_ipprs = prac_total_ipprs/`a'
	
	
	label variable practice_ipprs "Index for practices from static posts"
	
	reghdfe practice_ipprs treatment, absorb(union_cd) vce(robust)
	
	
	ivreg practice_ipprs (ins=treatment), first
	
	
	
	
	
	
	*******Best Practice for Pond Preparation
	
	local v1 "ip30	ip31	ip32	ip33	ip34 ip34c	ip35"
	
	
	local a = 0
	
	foreach x of local v1 {
		
		gen `x'_ippra = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ippra "`s'"
		
		reghdfe `x'_ippra treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ippra = rowtotal(*ippra)
	
	gen practice_ippra = prac_total_ippra/`a'
	
	
	label variable practice_ippra "Best Practice for Pond Preparation Index"
	
	reghdfe practice_ippra treatment, absorb(union_cd) vce(robust)
	
	
	
	
	
	****Best Practices while releasing fish fry
	
	local v1 "ip36a	ip40	ip41	ip42"
	
	local a = 0
	
	foreach x of local v1 {
		
		gen `x'_ipprb = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprb "`s'"
		
		reghdfe `x'_ipprb treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ipprb = rowtotal(*ipprb)
	
	gen practice_ipprb = prac_total_ipprb/`a'
	
	
	label variable practice_ipprb "Index for best practices while releasing fish fry"
	
	reghdfe practice_ipprb treatment, absorb(union_cd) vce(robust)
	
	
	
	
	*****Best practices after releasing fish fry
	
	
	local a = 0
	
	
	local x "ip44_2"
	
	gen `x'_ipprc = `x' == 1 | ip44_r2_2 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipprc "`s'"
		
	reghdfe `x'_ipprc treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	local x "ip44_3"
	
	gen `x'_ipprc = `x' == 1 | ip44_r2_3 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipprc "`s'"
		
	reghdfe `x'_ipprc treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	local x "ip45a"
	
	gen `x'_ipprc = `x' == 1 | ip45a_r2 == 1
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipprc "`s'"
		
	reghdfe `x'_ipprc treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	local x "ip46c"
	
	gen `x'_ipprc = `x' == 3
		
	qui describe `x'
	
	local s: var lab `x'
	
	label variable `x'_ipprc "`s'"
		
	reghdfe `x'_ipprc treatment, absorb(union_cd) vce(robust)
	
	local a = `a' + 1
	
	
	
	local v1 "ip46 ip46b_1 ip46b_2 ip46d_1 ip46d_2 ip46d_3 ip46d_4 ip46d_5 ip46d_6	ip48"
	
	
	foreach x of local v1 {
		
		gen `x'_ipprc = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprc "`s'"
		
		reghdfe `x'_ipprc treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ipprc = rowtotal(*ipprc)
	
	gen practice_ipprc = prac_total_ipprc/`a'
	
	
	label variable practice_ipprc "Index for best practices after releasing fish fry"
	
	reghdfe practice_ipprc treatment, absorb(union_cd) vce(robust)
	
	
	****Best Practices for Lime and Fertiliser Usage*****
	
	
	local v1 "ip49 ip49b ip49e_1 ip49e_3	ip50"
	
	
	local v2 "ip49c ip49d"
	
	
	local v3 "ip49a ip50a"
	
	local a = 0
	
	local x "ip50b"
	
		gen `x'_ipprd = `x' == 4 
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprd "`s'"
		
		reghdfe `x'_ipprd treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	
	
	
	foreach x of local v3 {
		
		gen `x'_ipprd = `x' == 3
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprd "`s'"
		
		reghdfe `x'_ipprd treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	foreach x of local v2 {
		
		gen `x'_ipprd = `x' == 2
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprd "`s'"
		
		reghdfe `x'_ipprd treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	
	
	foreach x of local v1 {
		
		gen `x'_ipprd = `x' == 1
		
		qui describe `x'
	
		local s: var lab `x'
	
		label variable `x'_ipprd "`s'"
		
		reghdfe `x'_ipprd treatment, absorb(union_cd) vce(robust)
	
		local a = `a' + 1
	
	}
	
	di `a'
	
	egen prac_total_ipprd = rowtotal(*ipprd)
	
	gen practice_ipprd = prac_total_ipprd/`a'
	
	
	label variable practice_ipprd "Index for lime and fertiliser usage"
	
	reghdfe practice_ipprd treatment, absorb(union_cd) vce(robust)
	
	
	
	
	
	
	
	
	
	
	
	ren dist_name district_name
	
	gsort -treatment idno
	
	count if treatment == 1
	
	foreach i of numlist 1/`r(N)' {
		
		gen lat_`i' = gps_latitude[`i'] 
		
		gen long_`i' = gps_longitude[`i']
		
		}
	
	gsort treatment idno
	
	foreach i of numlist 1/`r(N)' {
	
		geodist gps_latitude gps_longitude lat_`i' long_`i' if treatment == 0, gen(dist_`i')
    
	}
		
		egen displacement = rowmin(dist_*) if treatment==0
		
	gen treat_density = 0
	
	foreach x of varlist dist_* {
		
		qui replace treat_density = treat_density + 1 if `x' < 0.1
		
	}
	
	
	
	*drop lat_* long_* dist_*
	
	
	
	local v5 "pp_knowledge knowledge_ipkno"
	
	
	foreach x of local v5 {
		
		reghdfe `x' displacement if treatment == 0, absorb(union_cd) vce(robust)
		
	}
	
	egen test=cut(displacement), group(4)
	
	oneway know~e_ipkno test,t
	
	oneway displacement test,t
	
	
	reg knowledge_ipkno treat_density if treatment == 0, vce(robust)
	
	drop lat_* long_* dist_* 
	
	
	tab q2, gen(upaz_)
	
	
	foreach x of numlist 1/3 {
		
		*reg knowledge_ipkno upaz_`x' if treatment == 0, vce(robust)
		
		*reg knowledge_ipkno upaz_`x' if treatment == 1, vce(robust)
		
		reg knowledge_ipkno treatment if upaz_`x' == 1, vce(robust)

	}
	
	save "$In_Person_A_D\ATE_IP_ITT_Analysis.dta", replace 
	
	
	
	
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_itt_analysis.do"
	
	
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_iv_analysis.do"
	
	
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_robust.do"
	
	
	
	
	use "$In_Person_clean\20230505_ATE_IP_Attrition_Analysis_Ready", clear
	
	
		
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_attr_analysis.do"
	
	
	
	
	
	

	
	
	