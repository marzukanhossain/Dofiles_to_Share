/******************************************************************************************************************
*Title: Balance_Tests
*Created by: Marzuk
*Created on: May 11, 2023
*Last Modified on:  May 11, 2023
*Last Modified by: 	Marzuk
*Purpose :  Balance Tests after in-person survey
	
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
	
	
		
	use "$In_Person_clean\ATE_IP_Baltest_Ready.dta", clear
	

	tab treatment
	
	tab treat_old
	
	tab ip_treat
	/*
	local d=1
	
	foreach x of numlist 37/44 {
		
		recode q3 (37=1)
		
		local d=`d'+1
		
	}
	
	  label define q3 1 "Deluya bari" 2 "Kisomgankoair" 3 "Nowapara" 4 "Pananagar" 5 "Saluya" 6 "Sardaho " 7 "Yusufpur" 8 "Zaluka", replace
	*/
	
	
	
	/*
	drop if _merge != 3 
	
	drop _merge
		
	count if q9 != res_age
	*/
	
	local a = 1 
	
	di `a'
	
	
	 
	
	gen trk_sample = inlist(treatment, 0, 1)
	
	gen ph_sample = inlist(treat_old, 0, 1)
	
	gen ip_sample = inlist(ip_treat_cd_pull, 0, 1)
	
	
	keep if ip_sample == 1
	
	
	/*
	drop if inlist(union_cd, 16, 22, 24) //these three singleton observations are dropped during reghdfe
	*/
	
	recode q10 (2=0)
	
	label define q10 1 "Male" 0 "Female", replace
	
	
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
	
	
	
	
	
	
	local v1 "q10 q9 pq1 q13_cl q12_s q17_cl q17_1_cl q16_cl q16a_1 q16a_2 q16a_3"
	
	local l1 ""Sex of the farmer (Male = 1; Female = 0)" "Farmers' age (in years)" "Farmers' years of education" "Monthly spending on internet (in hundred BDT)" "Likelihood of farmers: Owning smartphones themselves" "Total production during 2021-2022 (in tonnes)" "Total revenue during 2021-2022 (in million BDT)" "Total area of just ponds being farmed (in acres)" "Likelihood of the type of pond ownership: Own land" "Leased land" "Combination of both – owned and leased""
	

	
	
	/*	
	count if ip2 ==1 & ip4 != ip6
	
	replace ip6 = ip4 if ip2 == 1
	
	tab ip6, gen (ip6_)
	
	order ip6_*, after (ip6)
	
	
	local v2 "ip6_1	ip6_2	ip6_3	ip6_4	ip6_5	ip6_6	ip6_7	ip6_8	ip6_9	ip6_10	ip6_11	ip6_12	ip6_13	ip6_14	ip6_15"
	
	local l2 ""No class passes" "Class 01" "Class 02" "Class 03" "Class 04" "Class 05" "Class 06" "Class 07" "Class 08" "Class 09" "SSC/Dakhil" "HSC/Alim" "Diploma/Degree/Technological" "BA/B.Com/ Honours/Fazil" "MA/Masters/Kamil"" 
	*/
	
	
	gen ip10_1 = ip10==1
	
	
	

	
	
	
	local v2 q14 q12_1 q12_21 q12_22 q12_23 q12_24 q12_25 q12_26 q12_27 q12_28
	
	local l2 ""Searching aquaculture information online (likelihood)" "Likelihood of farmer/household member using: Facebook"  "IMO" "Whatsapp" "Viber" "Instagram" "Tiktok" "Youtube" "Telegram" "None of the applications (excluding Facebook) used""
	
	
	
	
	
	egen sps = rowtotal(ipps*)
	
	tab ip52b, gen (ip52b_)
	
	local v3 ip52a_cl ip52b_1 ip52b_2 ip52b_3 sps q17_cl q17_1_cl
	
	local l3 ""Simple poverty score""
	
	
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
	
	
	
	
	
	qui putexcel set Bal_Test3, replace
	
	local a = 1
	
	local b ""Demographic characteristics, assets and production" "Farmers' use of social media""
	
	foreach y of local b {
	
	local t=3
	
	local lm=`t'- 1
	
	
	
	qui putexcel set Bal_Test3, modify sheet("Table 1.`a'")
	
	qui putexcel A`lm' = "Variables "
	
	qui putexcel B`lm' = "Treatment "
	
	
	
	qui putexcel C`lm' = "Control"
	
	
	
	qui putexcel D`lm' = "P value"

	
	
	qui putexcel A`lm':D`lm', bold 
	
	qui putexcel A`lm':D`lm', border(top)
		
	qui putexcel A`lm':D`lm', border(bottom)
	
	
	foreach x of local v`a' {
	
	local u = `t'+1
	
	quietly ttest `x', by(treatment)
	
	qui putexcel B`t' = `r(mu_2)', nformat(0.00)
	
	qui putexcel B`u' = `r(sd_2)', nformat((0.00))
	
	qui putexcel C`t' = `r(mu_1)', nformat(0.00)
	
	qui putexcel C`u' = `r(sd_1)', nformat((0.00))
	
	quietly reghdfe `x' treatment, absorb(upazilla) vce(robust)
	
	qui lincom treatment
	
	/** qui putexcel D`t' = `r(p)', nformat(0.00) **/
	
	if `r(p)'<0.01 {
	
			qui putexcel D`t' = `r(p)', nformat(\\\h\s\p\a\c\e\{\5\m\m\} 0.00\*\*\*)
			
	}
	
	else if `r(p)'<0.05 {
	
		qui putexcel D`t' = `r(p)', nformat(\\\h\s\p\a\c\e\{\2\.\5\m\m\} 0.00\*\*)
			
	}
	
	else if `r(p)'<0.1 {
	
		qui putexcel D`t' = `r(p)', nformat(\\\h\s\p\a\c\e\{\0\.\2\5\m\m\} 0.00\*)
			
	}
	
	else {
	
		qui putexcel D`t' = `r(p)', nformat(0.00)
			
	}
	
	/** qui putexcel E`t' = `r(estimate)', nformat(0.00)
	
	matrix z = e(b)
	
	local zz = z[1,1]
	
	qui putexcel E`t' = `zz', nformat(0.00) **/
	
	/** qui test treatment == 0
	
	qui putexcel D`t' = `r(p)', nformat(0.00) **/
	
	qui describe `x'
	
	local v: var lab `x'
	
	qui putexcel A`t' = ("`v'")
	
	local t=`t'+2
	
	}
	
	local s=`t'+1
	
	local k=`lm'-1
				
	qui putexcel A`t' = "No. of Observations"
	
	quietly ttest q9, by (treatment)
	
	qui putexcel B`t' = `r(N_2)', nformat(#,###)
	
	qui putexcel C`t' = `r(N_1)', nformat(#,###)
	
	qui count
	
	qui putexcel D`t' = `r(N)', nformat(#,###)
	
	qui putexcel A`t':D`t', bold
	
	qui putexcel A`k':D`s', font("Times New Roman", 10)
	
	qui putexcel B`lm':D`t', hcenter vcenter
	
	qui putexcel A`t':D`t', border(bottom)
	
	qui putexcel A`k' = "`y'"
		
	qui putexcel A`k':D`k', merge bottom bold
	
	qui putexcel A`s' = "Notes: The values in parentheses are standard errors and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_i_u = \alpha_u + \beta T_i_u + e_i_u\) where \(Y_i_u\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_i_u\) is the indicator for being assigned to the treatment group; and \(e_i_u\) is the error term. Robust standard errors are used.", txtwrap
			
	qui putexcel A`s':D`s', merge top 
	
	
	
	local a = `a'+1
	
	}
		

	mata
	
	b = xl()
	
	b.load_book("Bal_Test3.xlsx")
	
	b.set_sheet("Table 1.1")
	
	b.set_column_width(1,1,45) 
	
	b.set_column_width(2,3,11)
	
	b.set_column_width(4,4,35)
		
	b.set_row_height(`st1',`st1',80) 
	
	b.set_sheet("Table 1.2")
	
	b.set_column_width(1,1,45) 
	
	b.set_column_width(2,3,11) 
	
	b.set_column_width(4,4,35)
		
	b.set_row_height(`st2',`st2',80)
	/*
	b.set_sheet("Table 1.3")
	
	b.set_column_width(1,1,40) 
	
	b.set_column_width(2,4,11) 
		
	b.set_row_height(`st3',`st3',80)
	*/
	/*
	b.set_sheet("Fixed-Effect3")
	
	b.set_column_width(1,1,68) 
	
	b.set_column_width(2,3,15) 
	
	b.set_column_width(4,4,21) 
	
	b.set_row_height(45,45,70) 
	*/
	end
	