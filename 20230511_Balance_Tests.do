/******************************************************************************************************************
*Title: 20230511_Balance_Tests
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
	
	global ip_r_tables		"$proj_dir\06_Results\04_In_Person_Survey\01_Tables"
	
	
		
	use "$In_Person_clean\20230505_ATE_IP_Baltest_Ready.dta", clear
	

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
	
	
	*keep if ip_sample == 1
	
	
	/*
	drop if inlist(union_cd, 16, 22, 24) //these three singleton observations are dropped during reghdfe
	*/
	
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
	
	
	
	
	local v1 "ip1 ip3 q10 q9 pq1 ip51 q16_cl q17_cl q17_1_cl sps q13_cl" 
	
	local l1 ""Household size" "Sex of household head (Female = 1)" "Sex of the farmer (Female = 1)" "Farmers' age (in years)" "Farmers' years of education" "Number of ponds farmed (2021-2022)" "Area of just ponds farmed in 2021-2022 (in acres)" "Production during 2021-2022 (in tonnes)" "Revenue during 2021-2022 (in million BDT)" "Simple poverty score" "Monthly spending on internet (in 100 BDT)""
	
	
	
	
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
	
	
	

	
	///
	
	local v3 q14 q12_1 q12_21 q12_22 q12_23 q12_24 q12_25 q12_26 q12_27 q12_28
	
	local l3 ""Searching aquaculture information online" "Facebook"  "IMO" "WhatsApp" "Viber" "Instagram" "Tiktok" "Youtube" "Telegram" "None of the applications (excluding Facebook) used""
	
	*/
	
	
	
	*egen sps = rowtotal(ipps*)
	
	tab ip52b, gen (ip52b_)
	
	local v7 ip52a_cl ip52b_1 ip52b_2 ip52b_3 sps q17_cl q17_1_cl
	
	*local l3 ""Simple poverty score""
	
	
	/*
	label variable q17_cl "Total production from pond in the year 2021-2022 (in tonnes)"
	
	label variable q17_1_cl "Total revenue generated in the year 2021-2022 (in million taka)"
	*/
	foreach x of numlist 1/3 {
		
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
	
	
	save "$In_Person_A_D\ATE_IP_Baltest_Analysis.dta", replace
	
	
 
	set scheme plotplainblind
	**color
	global skyblue "86 180 233"
	global blue "0 114 178"
	global teal "17 222 245"
	global orange "213 94 0"
	global green "0 158 115"
	global yellow "230 159 0"
	global purple "204 121 167"
	global lavendar "154 121 204"
	
	**sequential color
	global blue1 "158 202 225"
	global blue2 "66 146 198"
	global blue3 "8 81 156"
	
	global purple1 "188 189 220"
	global purple2 "128 125 186"
	global purple3 "84 39 143"
	
	
	
	
	local grey1 "230 230 230"
	local grey2 "200 200 200"
	local grey3 "170 170 170"
	local grey4 "140 140 140"
	local grey5 "110 110 110"
	local grey6 "80 80 80"
	local grey7 "50 50 50"
	local grey8 "20 20 20"
	
	
	local v3 "q12_1 q12_21 q12_22 q12_23 q12_24 q12_25 q12_26 q12_27"
	
	
	local a = 1
	
	local coef "coefplot "
	
	foreach x of local v3 {
		
		reghdfe `x' treatment, absorb(union) vce(robust)
		
		eststo reg`a'
		
		local v: var lab `x'
		
		local coef "`coef' (reg`a', aseq("`v'") mcolor(gs`a') msymbol(O) msize(small) ciopts(recast(rcap) color(gs`a')))"
		
		local a = `a' + 1
		
	}
 	
	
	`coef', aseq swapnames legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(, angle(horizontal) labsize(small)) xlabel(, labsize(small)) mlabgap(*0.5) mlabsize(vsmall) scheme(white_tableau) plotregion(color(white) fcolor(white)) graphregion(color(white) fcolor(white)) xline(0, lcolor("`grey8'") noextend lpattern(dash))
	
	graph export "coefplot.png", replace 
	
	/*
	local v1 "q10 q9 pq1 q13_cl q12_s q17_cl q17_1_cl q16_cl q16a_1 q16a_2 q16a_3"
	*/
	
	
	
	reghdfe q10 treatment, absorb(union) vce(robust)
	
	lincom treatment 
	
	return list, all
	
	local bet = `r(estimate)'
	
	local b : display %4.3f `r(estimate)'
	
	local se : display %4.3f `r(se)'
	
	
	if `r(p)'<0.01 {
	
			local be : display "`b'***"
			
	}
	
	else if `r(p)'<0.05 {
	
		local be : display "`b'**"
			
	}
	
	else if `r(p)'<0.1 {
	
		local be : display "`b'*"
			
	}
	
	else {
	
		local be : display "`b'"
			
	}
	
	display "`be'"
	
	
	lincom _cons
	
	local con : display %4.3f `r(estimate)'
	
	local treat : display %4.3f `bet'+`r(estimate)'  
	
	
	display "`treat'"
	
	
	matrix z = (`treat', `con', `be' \ .z, .z, `se' )
	
	matlist z, nodotz underscore
	
	 
	 
	 
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_baltab.do"
	
	


