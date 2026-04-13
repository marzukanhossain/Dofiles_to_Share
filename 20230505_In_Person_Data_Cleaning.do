/******************************************************************************************************************
*Title: 20230505_In_Person_Data_Cleaning
*Created by: Marzuk
*Created on: May 05, 2023
*Last Modified on:  May 05, 2023
*Last Modified by: 	Marzuk
*Purpose :  Cleaning in-person surveg data for analysis
	
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
	
	
	
	
	use "$In_Person_raw\20230414_Aquaculture_training_evaluation_2023_clean", clear
	
	
	label define treat_cd 0 "Control" 1 "Treatment"
	
	label values treat_cd_pull treat_cd
	
	
	*keep if consent == 1
	
	keep if ip8 == 1
	
	order key, after (idno)
	
	
	local a "enu_code union_cd_pull vill_nm_pull treat_cd_pull res_age key"
	
	foreach x of local a {
		
		ren `x' ip_`x'
		
	}
	
	foreach x of varlist fish* {
		
		ren `x' ip_`x'
		
	}
	
	keep idno ip* gps_place gpslatitude gpslongitude gpsaccuracy survey_day starttime endtime interviewdate startdate enddate subdate
	
	sort idno
	
	
	
	/* The treatment of the 3 singleton observations union-wise:

	• The unions mentioned in our data does not match the government data base.
	• Looking at the google maps, I found out the closest upazillas to the ones with singleton observations.
	• This is how they have been treated.
		○ Included Bagha in Monigram.
		○ Bausa in Orani.
		○ Talbaria in Poranpur.
*/
	
	local un "17 15 23"
	
	local old "16 22 24"
	
	local a = 1
	
	foreach x of local old {
		
		local old`a' = `x'
		
		local a = `a' + 1
		
	}
	
	local a = 1
	
	foreach x of local un {
	
	replace ip_union_cd_pull = `x' if ip_union_cd_pull==`old`a''
		
	local a = `a' + 1	
		
	}
	
	
	preserve
	
	merge 1:1 idno using "$Phone_Survey_clean\20221120_Aquaculture_Training_Evaluation_Cleaned_For_Analysis", gen (merge_1)
	
	g attr_m = _merge == 2
	
	g attr_e = merge_1 == 2
	
	
	
	recode q10 (1=0)
	
	recode q10 (2=1)
	
	label define q10 0 "Male" 1 "Female", replace
	
	
	gen q12_s = q12==1
	
	
	label variable q16 "Total pond area (no surronding area) (in decimal)"

	foreach a of varlist q13 ip20a q15 q16 q18 ip52a{
		
		clonevar `a'_cl= `a'
		
		replace `a'_cl= `a'_cl/100
		
	}
	
	
	
	local b "q17 q17_1"
	
	local f=1000
	
	foreach c of varlist q17 q17_1{
		
		clonevar `c'_cl = `c' 
	
		replace `c'_cl = `c'/`f'
		
		local f = `f'*1000
	}
	
	
	
	gen ip10_1 = ip10==1
	
	
	egen sps = rowtotal(ipps*)
	
	
	
	
	local v1 "ip1 ip3 q10 q9 pq1 ip51 q16_cl q17_cl q17_1_cl sps q13_cl attr_m attr_e" 
	
	local l1 ""Household size" "Sex of household head (Female = 1)" "Sex of the farmer (Female = 1)" "Farmers' age (in years)" "Farmers' years of education" "Number of ponds farmed (2021-2022)" "Area of just ponds farmed in 2021-2022 (in acres)" "Production during 2021-2022 (in tonnes)" "Revenue during 2021-2022 (in million BDT)" "Simple poverty score" "Monthly spending on internet (in 100 BDT)" "Midline Attrition" "Endline Attrition""
	
	
	
	
	local v2 q12_s q14
	
	local l2 ""Owning smartphones themselves" "Searching fish-farming-related information online""

	
	
	
	/*	
	count if ip2 ==1 & ip4 != ip6
	
	replace ip6 = ip4 if ip2 == 1
	
	tab ip6, gen (ip6_)
	
	order ip6_*, after (ip6)
	
	
	local v2 "ip6_1	ip6_2	ip6_3	ip6_4	ip6_5	ip6_6	ip6_7	ip6_8	ip6_9	ip6_10	ip6_11	ip6_12	ip6_13	ip6_14	ip6_15"
	
	local l2 ""No class passes" "Class 01" "Class 02" "Class 03" "Class 04" "Class 05" "Class 06" "Class 07" "Class 08" "Class 09" "SSC/Dakhil" "HSC/Alim" "Diploma/Degree/Technological" "BA/B.Com/ Honours/Fazil" "MA/Masters/Kamil"" 
	*/
	
	
	*gen ip10_1 = ip10==1
	
	
	

	
	/*
	
	local v2 q14 q12_1 q12_21 q12_22 q12_23 q12_24 q12_25 q12_26 q12_27 q12_28
	
	local l2 ""Searching aquaculture information online (likelihood)" "Likelihood of farmer/household member using: Facebook"  "IMO" "Whatsapp" "Viber" "Instagram" "Tiktok" "Youtube" "Telegram" "None of the applications (excluding Facebook) used""
	
	*/
	
	
	
	*egen sps = rowtotal(ipps*)
	
	tab ip52b, gen (ip52b_)
	
	local v3 ip52a_cl ip52b_1 ip52b_2 ip52b_3 sps q17_cl q17_1_cl
	
	*local l3 ""Simple poverty score""
	
	
	/*
	label variable q17_cl "Total production from pond in the year 2021-2022 (in tonnes)"
	
	label variable q17_1_cl "Total revenue generated in the year 2021-2022 (in million taka)"
	*/
	foreach x of numlist 1/2 {
		
		local a = 1
		
		foreach y of local v`x' {
			
			ren `y' var`a'
			
			local a = `a'+1
			
		}
		
		local a = 1
		
		foreach y of local l`x'	{
			
			lab var var`a' "`y'"
			
			local a = `a'+1
		
		}
		
		local a = 1
		
		foreach y of local v`x' {
			
			ren var`a' `y'
			
			local a = `a' + 1
			
		}
		
		local st`x' = `a'*2 + 2
	}
	
	
	
	
	local v1 "ip1 ip3 q10 q9 pq1 ip51 q16_cl q17_cl q17_1_cl sps q13_cl q12_s q14"	
	
	
	foreach x of local v1 {
		
		gen `x'_treat = `x'*treatment
		
	}
	
	
	
	
	
	save "$In_Person_clean\20230505_ATE_IP_Attrition_Analysis_Ready", replace
	
	restore
	
	
	
	preserve
	
	merge idno using "$Phone_Survey_A_D\20221107_Aquaculture_Training_Evaluation_Analysed_Data"
	
	keep if _merge == 3
	
	
	label define pq1 0 "No class passes" 1 "Class 01" 2 "Class 2" 3 "Class 3" 4 " Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" 10 "SSC/Dakhil" 12 "HSC/Alim" 15 "Diploma/Technological" 16 " BA/Degree /B.Com/Honours/BSc/Fazil" 18 "MA/MSc/ Masters/Kamil" 20 "PhD" 21 "Religious education / Hafez" 555 "Others", replace

	lab var pq1 pq1
	
	recode pq1 (17=18)
	
	
	local a = 1
	
	foreach x of local un {
	
	replace union_cd = `x' if union_cd==`old`a''
		
	local a = `a' + 1	
		
	}
	
	
	sort idno
	
	save "$In_Person_clean\20230505_ATE_IP_Analysis_Ready", replace
	
	restore
	
	preserve
	
	merge 1:1 idno using "$Phone_Survey_clean\20221120_Aquaculture_Training_Evaluation_Cleaned_For_Analysis.dta", nogenerate
	
	
	label define pq1 0 "No class passes" 1 "Class 01" 2 "Class 2" 3 "Class 3" 4 " Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" 10 "SSC/Dakhil" 12 "HSC/Alim" 15 "Diploma/Technological" 16 " BA/Degree /B.Com/Honours/BSc/Fazil" 18 "MA/MSc/ Masters/Kamil" 20 "PhD" 21 "Religious education / Hafez" 555 "Others", replace

	lab var pq1 pq1
	
	recode pq1 (17=18)
	
	
	
	local a = 1
	
	foreach x of local un {
	
	replace union_cd = `x' if union_cd==`old`a''
		
	local a = `a' + 1	
		
	}
	
	
	
	sort idno
	
	save "$In_Person_clean\20230505_ATE_IP_Baltest_Ready", replace
	
	restore
	
	merge idno using "$Phone_Survey_A_D\20221107_Aquaculture_Training_Evaluation_Analysed_Data"
	
	
	local a = 1
	
	foreach x of local un {
	
	replace union_cd = `x' if union_cd==`old`a''
		
	local a = `a' + 1	
		
	}
	
	
	
	sort idno
	
	save "$In_Person_clean\20230505_ATE_PH_Analysis_Ready", replace
	