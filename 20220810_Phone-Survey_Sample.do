/******************************************************************************************************************
*Title: 20220810_Phone-Survey_Sample
*Created by: Marzuk
*Created on: May 26, 2022
*Last Modified on:  Aug 10, 2022
*Last Modified by: 	Marzuk
*Purpose :  Draw Sample for Phone Survey SurveyCTO
	
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
	else if "`c(username)'"=="User" {
	
			global base_dir "G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW"
			
	}
			
	
	global proj_dir 	"$base_dir\1.3.3 World Fish"
	
	global data_dir   		"$proj_dir\04_Data"
	
	global listing_data  "$data_dir\01_TRK_Initial_Listing_Survey"
	
	global Phone_Survey_data 	"$data_dir\03_Phone_Survey"

	global Phone_Survey_sample	"$Phone_Survey_data\01_Selected-Sample"
	
	global do_dir  			"$proj_dir\05_Code"
	
	***TRK Randomisation****

	use "$listing_data\20220808_TRK_survey_2022_clean.dta", replace 

	
	*destring treatment, replace
	
	destring _id, replace
	
	format %11.0g _id
	
	ren _id id
	
	order id


	
	*Fixing others in res_relation
	
	*q12 and res_relation has been recoded to add 13 and 14 that includes mother/father and mother/father in law, respectively.
	
	label define res_relation 1 "Self" 2 "husband/wife" 3 "son/daughter" 4 "sister/brother" 5 "son's wife/sister's husband" 6 "brother's wife/sister's husband" 7 "cousin" 8 "nephew/niece" 9 "housekeeper/ maid/ servant" 10 "granddaughter/ grandson" 11 "granddaughter's husband/ grandson's wife" 12 "sister-in-law/ brother-in-law" 13 "mother/father" 14 "mother/father in law" 555 "other(specify)", replace

	label define q12 1 "Self" 2 "husband/wife" 3 "son/daughter" 4 "sister/brother" 5 "son's wife/sister's husband" 6 "brother's wife/sister's husband" 7 "cousin" 8 "nephew/niece" 9 "housekeeper/ maid/ servant" 10 "granddaughter/ grandson" 11 "granddaughter's husband/ grandson's wife" 12 "sister-in-law/ brother-in-law" 13 "mother/father" 14 "mother/father in law" 555 "other(specify)", replace
	
	local r_ot13 "Baba ma Ma"
	
	foreach x of local r_ot13{
	
	replace res_relation = 13 if strpos(res_relation_ot, "`x'")
	
	}
	
	replace res_relation = 14 if strpos(res_relation_ot, "Law")
	
	foreach x of varlist res_relation q12{
	
	replace `x' = 8 if strpos(`x'_ot, "Bhaipo")
	
	}
	
	
	
	* Data collector coded
	
	encode datacollector, gen (data_coll_cd)
	
	order data_, before (q1)
	
	
	* The Sample
	
	drop if q12a == 0
	
	order idno
	
	
	
	
	save "$Phone_Survey_sample\20220810_Phone-Survey_Sample", replace
	
	
	use "$Phone_Survey_sample\20220810_Phone-Survey_Sample", clear
	
	keep idno q2 q4 q5 res_relation q9 q10 q12 q12_1 q12_21 q12_22 q12_23 q12_24 q12_25 q12_26 q12_27 q12_28 q13 q14 q15 q16 q16a q17 q17_1 q18 treatment q20 endtime gps_latitude gps_longitude gps_altitude gps_precision
	
	tab q16a, gen (q16a_)
	
	order q16a_*, after(q16a)
	
	sort idno
	
	save "$Phone_Survey_sample\20220810_Phone-Survey_Sample_4_Merge", replace
	
	
