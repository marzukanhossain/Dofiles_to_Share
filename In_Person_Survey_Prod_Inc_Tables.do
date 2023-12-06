/******************************************************************************************************************
*Title: In_Person_Survey_Prod_Inc_Tables
*Created by: Marzuk
*Created on: May 11, 2023
*Last Modified on:  May 11, 2023
*Last Modified by: 	Marzuk
*Purpose :  Impact on Production and Income tabulated after in-person survey 
	
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
	
	

	run "$do_dir\04_In_Person_Survey\03_Analysis\ATE_IP_Primary_Analysis.do"

	run "$do_dir\04_In_Person_Survey\03_Analysis\ATE_IP_Primary_Analysis_Practice.do"
	
	
	
	
	
	
	use "$In_Person_clean\ATE_IP_Additional_Tables.dta", clear
	
	
	
	*****Regressions for the impact on production and income from the phone survey
	
	
	egen prod12 = rowtotal(ip64ib*)
	
	egen prod6 = rowtotal(ip64ia*)
	
	
	
	egen inc12_hi = rowtotal(ip64iib*)
	
	egen inc6_hi = rowtotal(ip64iia*)
	
	
	local inc "inc12 inc6"
	
	foreach x of local inc {
		
		gen `x' = `x'_hi/1000000
		
	}
	
	
	
	local ippro "prod12 inc12 prod6 inc6"
	
	
	foreach x of local ippro {
	
		reghdfe `x' treatment, absorb(upazilla) vce(robust) 
	
	}
	
	
	local labpro ""Yearly production (tonnes)" "Yearly income (million BDT)" "Half-yearly production (tonnes)" "Half-yearly income (million BDT)""
	
	local a = 1
	
	foreach x of local labpro {
		
		local labp`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	local a = 1
	
	foreach x of local ippro {
		
		lab var `x' "`labp`a''"
		
		local a = `a' + 1
				
	}
	
	
	
	
	local alp "A	B	C	D	E	F	G	H	I	J	K	L	M	N	O	P	Q	R	S	T	U	V	W	X	Y	Z"
	
	local a = 1
	
	foreach x of local alp {
		
		local al`a' "`x'"
		
		local a = `a' + 1
		
	}
	
	
	
	qui putexcel set IP_Results, replace
	
	local a = 2
	
	qui putexcel set IP_Results, modify sheet(IP_Prod_Inc)
	
	foreach x of local ippro {
	
		local b = `a' - 1
		
		qui putexcel `al`a''2 = "(`b')"
		
		
		qui describe `x'
	
		local v: var lab `x'
	
		qui putexcel `al`a''3 = ("`v'"), txtwrap
		
		local k = 4
		
		qui reghdfe `x' treatment, absorb(upazilla) vce(robust)
		
		qui lincom treatment
		
		if `r(estimate)' < 0 {
		
		local est = abs(`r(estimate)')
		
		if `r(p)'<0.01 {
	
			qui putexcel `al`a''`k' = `est', nformat(\\\h\s\p\a\c\e\{\5\m\m\} \-0.000\*\*\* \\\h\s\p\a\c\e\{\0\.\2\5\m\m\})
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel `al`a''`k' = `est', nformat(\\\h\s\p\a\c\e\{\2\.\5\m\m\} \-0.000\*\* \\\h\s\p\a\c\e\{\0\.\2\5\m\m\})
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel `al`a''`k' = `est', nformat(\\\h\s\p\a\c\e\{\0\.\2\5\m\m\} \-0.000\* \\\h\s\p\a\c\e\{\0\.\2\5\m\m\})
			
		}
	
		else {
	
			qui putexcel `al`a''`k' = `r(estimate)', nformat(0.000 \\\h\s\p\a\c\e\{\0\.\2\5\m\m\})
				
		}
		
		}
		
		else {
		
		if `r(p)'<0.01 {
	
			qui putexcel `al`a''`k' = `r(estimate)', nformat(\\\h\s\p\a\c\e\{\5\m\m\} 0.000\*\*\*)
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel `al`a''`k' = `r(estimate)', nformat(\\\h\s\p\a\c\e\{\2\.\5\m\m\} 0.000\*\*)
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel `al`a''`k' = `r(estimate)', nformat(\\\h\s\p\a\c\e\{\0\.\2\5\m\m\} 0.000\*)
			
		}
	
		else {
	
			qui putexcel `al`a''`k' = `r(estimate)', nformat(0.000)
				
		}
		
			
		}
		
		qui putexcel `al`a''5 = `r(se)', nformat((0.000))
		
		
		qui ttest `x', by(treatment)
		
		qui putexcel `al`a''7 = `r(mu_1)', nformat(0.000)
						
		qui count
		
		qui putexcel `al`a''8 = `r(N)'
		
		local a = `a' + 1
		
	}

	local c = `a' - 1
	
	qui putexcel A4 = "Treatment"
	
	qui putexcel A7 = "Control Mean"
	
	qui putexcel A8 = "Observations"
	
	qui putexcel A2:`al`c''8, font("Times New Roman", 10)
	
	qui putexcel B2:`al`c''8, hcenter
		
	qui putexcel A2:`al`c''2, border(top)
	
	qui putexcel A4:`al`c''4, border(top)
	
	qui putexcel A8:`al`c''8, border(bottom)
	
	
	
	

	mata
	
	b = xl()
	
	b.load_book("IP_Results.xlsx")
	
	b.set_sheet("IP_Prod_Inc")
	
	b.set_column_width(1,1,11) 
	
	b.set_column_width(2,`c',35) 
		
	end
		
	
	
	
	
	