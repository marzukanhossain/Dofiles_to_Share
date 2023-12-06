/******************************************************************************************************************
*Title: PROMISE_Robcheck_Comments_20231112
*Created by: Marzuk
*Created on: November 12, 2023
*Last Modified on:  November 12, 2023
*Last Modified by: 	Marzuk
*Purpose :  Robustness check tables to accomodate for reviewers' comments
	
*****************************************************************************************************************/

	global steps "a b c"

// step 1
local k "c"
if `: list k in global(steps)' {
	di "step 1"
}
di "$steps"

	clear all
	set more off
	capture log close
	set logtype text

	local date=c(current_date)
	local time=c(current_time)
	
	**Appropriate directory based on user
	
	if "`c(username)'"=="marzu" {
	
			global base_dir "C:\Users\marzu\OneDrive\BIGD\Work\01_BIGD_Projects"
			
	}
			
	global proj_dir 	"$base_dir\04_PROMISE"
	
	global data_dir   		"$proj_dir\03_Data"
	
	global data_endline		"$data_dir\03_Endline"
	
	global data_endline_analysis  			"$data_endline\04_Analysis"
	
	global data_endline_clean		"$data_endline\03_Clean"
	
	global results_endline			"$proj_dir\06_Results\03_Endline"
	*/		
	
	
	local mydate : display %tdCCYYNNDD date(c(current_date), "DMY")
	
	local mytime : display %tcCCYYNNDD-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMY hms")
	
	
	
	local cond0 ""group" "group" "group" "promiseloan""
		
		local i = 1
		
		foreach y of local cond0 {
			
			local cond`i' "`y'"
			
			local i = `i' + 1
			
		}
		

		local imp ""Overall" "Training+Loan" "Training" "Addl_Loan""
		
		local i = 1
		
		foreach y of local imp {
			
			local imp`i' "`y'"
			
			local i = `i' + 1
			
		}	
		
	
	
	local star "star_part no_star_part"
	
	local i = 1
	
	foreach y of local star {
		
		local star`i' "`y'"
		
		local i = `i' + 1
		
	}
		
	
	
	local cov ""year star_part incmnth age p_w_d indigenous yr_emp1 assetvalue_hh1 inc_hh_mnth1 exp_hh_mnth1 educ1""
	
	local i = 1
	
	foreach y of local cov {
		
		**di "`y'"
		
		local cov`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	di "`cov2'"
	
	
	
	
	/*
	global cov1 "year star_part incmnth age p_w_d indigenous yr_emp1 assetvalue_hh1 inc_hh_mnth1 exp_hh_mnth1 educ1"
	
	global cov2 "year star_part incmnth age p_w_d indigenous yr_emp1 assetvalue_hh1 inc_hh_mnth1 exp_hh_mnth1 educ1 sx2 gp_sexf"
	
	
	di "$cov2"
	*/
	
	
	
	use "$data_endline_analysis\Promise_Analysis_Inc_Occu_LSE_labd", clear
	
	/*
	label define sex 1 "Male" 2 "Female" 3 "Other"

	label values sex sex

		
	save "$data_endline_analysis\Promise_Analysis_Inc_Occu_LSE_labd", replace
	*/	
	
	*tab sex, gen (sx)
	
	*gen gp_sexf = group*sx2
	
	
	
	*local alp "A	B	C	D	E	F	G	H	I	J	K	L	M	N	O	P	Q	R	S	T	U	V	W	X	Y	Z"
	
	local a = 1
	
	foreach x in `c(ALPHA)' {
		
		local al`a' "`x'"
		
		local a = `a' + 1
		
	}
	
	di "`al25'"
	

	
	local v0 ""q1000_17 y1 y2 y3 y4 wh1 wh2 wh3 wh4""
	
	local a = 1
	
	foreach x of local v0 {
		
		local v`a' "`x'"
		
		local a = `a' + 1
		
	}
	
	
	
	local ylab ""Self-employed (Yes=1, No=0)" "Salaried job (Yes=1, No=0)" "Wage labour (Yes=1, No=0)" "Unemployed (Yes=1, No=0)""
	
	
	
	local a = 1
	
	foreach x of local ylab {
		
		local ylab`a' "`x'"
		
		lab var y`a' "`ylab`a''"
		
		des y`a'
		
		local a = `a' + 1
		
	}
	
	
	
	local whlab ""Self-employed (hours worked per day)" "Salaried job (hours worked per day)" "Wage labour (hours worked per day)" "Total working hours per day""
	
	
	
	local a = 1
	
	foreach x of local whlab {
		
		local whlab`a' "`x'"
		
		lab var wh`a' "`whlab`a''"
		
		des wh`a'
		
		local a = `a' + 1
		
	}
	
	
	
	
	qui putexcel set Rob_Check_CA_20231112, modify sheet (Inc_Emp)
	
	qui putexcel `al1'4 = "Treatment (A)"
	
	qui putexcel `al1'8 = "Comparison group mean", txtwrap
	
	qui putexcel `al1'9 = "Covariates controlled", txtwrap
	
	qui putexcel `al1'10 = "Number of observations", txtwrap bold
	
	
	
	
	
	
	
	local h = 1
	
	local i = 2

		foreach y of local v`h' {
		
		local a = 2
		
		local i_1 = `i' - 1
			
		qui putexcel `al`i''`a' = "(`i_1')"
		
		local a = `a' + 1
		
		local v: var lab `y'
	
		qui putexcel `al`i''`a' = ("`v'"), bold txtwrap
		
		local a = `a' + 1
		
		
		qui reg `y' group `cov`h'', vce(robust)
		
			qui lincom group
			
					if `r(estimate)' < 0 {
		
		local abest = abs(`r(estimate)')
	
			if `r(p)' < 0.01 {
			
			qui putexcel `al`i''`a' = `abest', nformat(???\-0.000"***" "")
			
			}
	
			else if `r(p)' < 0.05 {
	
			qui putexcel `al`i''`a' = `abest', nformat(??\-0.000"**" "")
			
			}
	
			else if `r(p)' < 0.1 {
	
			qui putexcel `al`i''`a' = `abest', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `abest', nformat(\-0.000 "")
				
			}
			
			
		}
		
		else {
		
		if `r(p)'<0.01 {
	
			qui putexcel `al`i''`a' = `r(estimate)', nformat(???0.000"***")
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel `al`i''`a' = `r(estimate)', nformat(??0.000"**")
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel `al`i''`a' = `r(estimate)', nformat(?0.000"*")
			
		}
	
		else {
	
			qui putexcel `al`i''`a' = `r(estimate)', nformat(0.000)
				
		}
		
			
		}
		
		local a = `a' + 1
		
			qui putexcel `al`i''`a' = `r(se)', nformat((0.000))
		
		local a = `a' + 3
		
					
		qui ttest `y', by(group)
		
		qui putexcel `al`i''`a' = `r(mu_1)', nformat(0.000)
		
		local a = `a' + 1
		
		qui putexcel `al`i''`a' = "Yes"
		
		local a = `a' + 1
		
		
		qui count
		
		qui putexcel `al`i''`a' = `r(N)', bold
		
		
	
		
		
		local i = `i' + 1
		
		
		local h = `h' + 1
		
			
		}
		
		
		
		
		
	
	
	local j = `i' - 1
	
		qui putexcel `al1'1:`al`j''`a', font("Times New Roman", 9)
		
		qui putexcel `al2'1:`al`j''`a', hcenter
		
		qui putexcel `al1'2:`al`j''2, border(top)
		
		qui putexcel `al1'3:`al`j''3, border(bottom)
		
		qui putexcel `al1'`a':`al`j''`a', border(bottom)
		
		
		
		
		 
	mata
	
	b = xl()
	
	b.load_book("Rob_Check_CA_20231112.xlsx")
	
	b.set_sheet("Inc_Emp")
	
	b.set_column_width(1,1,15) 
	
	b.set_column_width(2,`j',10) 
	
	end
	
	
		
		
		
	
	