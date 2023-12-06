/******************************************************************************************************************
*Title: PROMISE_Baltest_Comments_CA_20231105
*Created by: Marzuk
*Created on: November 05, 2023
*Last Modified on:  November 05, 2023
*Last Modified by: 	Marzuk
*Purpose :  Balance test tables to accomodate for reviewers' comments
	
*****************************************************************************************************************/

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
	
	
	use "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd", clear
	
	
	*
	lab var year "2017 cohort"
	
	tab sex, gen(sx)
	
	local sxlab ""Proportion of the following (Yes=1, No=0):          Male" "Female" "Intersex""
		
	local i = 1
	 
	foreach x of local sxlab {
	 	
		lab var sx`i' "`x'"
		
		local i = `i' + 1
		
	 }
	 
	
	tab q6_26, gen(skl)
	
	gen skl0 = skl5==1 | skl6==1 | skl7==1
	
	drop skl5-skl7 skl12 skl13
	
	order skl0, after(skl4)
	
	local i = 1
	 
	foreach x of varlist skl* {
	 	
		ren `x' skl`i'
		
		local i = `i' + 1
		
	 }
	 
	local sklab ""Proportion of education level (Yes=1, No=0):         Never went to school" "Went to school but did not pass" "Playgroup/nursery/pre-primary level" "Class 1 – less than class 8/equivalent" "Class 8 – less than SSC" "SSC/equivalent" "HSC/equivalent" "Honor's/equivalent" "Masters/equivalent""
		
	local i = 1
	 
	foreach x of local sklab {
	 	
		lab var skl`i' "`x'"
		
		local i = `i' + 1
		
	 }
	 
	
	tab assetvalue_hh1, gen(av)
	
	local avlab ""Household with asset value (Yes=1, No=0):          Less than BDT 200,000" "Between BDT 200,000 and 500,000" "More than BDT 500,000""
	 
	 local i = 1
	 
	 foreach x of local avlab {
	 	
		lab var av`i' "`x'"
		
		local i = `i' + 1
		
	 }
	 
	 
	tab inc_hh_mnth1, gen(inc)
	 
	local inclab ""Household with monthly income (Yes=1, No=0):    Less than BDT 5,000" "Between BDT 5,000 and 6,000" "Between BDT 6,000 and 7,000" "More than BDT 8,000""
			 
	 local i = 1
	 
	 foreach x of local inclab {
	 	
		lab var inc`i' "`x'"
		
		local i = `i' + 1
		
	 }
	
	
	 
	tab exp_hh_mnth1, gen(exp)
	 
	local explab ""Household with monthly spending (Yes=1, No=0):   Less than BDT 5,000" "Between BDT 5,000 and 6,000" "Between BDT 6,000 and 7,000" "More than BDT 8,000""
			 
	 local i = 1
	 
	 foreach x of local explab {
	 	
		lab var exp`i' "`x'"
		
		local i = `i' + 1
		
	 }
	
	
	
	
	
	
	gen percapinc = incmnth/1000
	
	lab var percapinc "Household per capita monthly income (in 1000 BDT)"
	
	
	lab var educ1 "Years of education"
	
	lab var star_part "STAR participant"
	
	lab var age "Age (in years)"
	
	lab var p_w_d "Person with disability"
	
	lab var indigenous "Non-Bengali ethnicity"
	
	lab var yr_emp1 "Years of employment experience"
	
	
	save "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd2", replace
	*/
	
	
	
	
	local partloan ""Participant" "Training and Loan""
	
	local i = 1
	
	foreach y of local partloan {
		
		local partloan`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	
	local nopartnoloan ""Non-participant" "Only Training""
	
	local i = 1
	
	foreach y of local nopartnoloan {
		
		local nopartnoloan`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	
	local cov ""age" "sx1" "sx2" "sx3" "year" "star_part" "p_w_d" "indigenous" "educ1" "skl1" "skl2" "skl3" "skl4" "skl5" "skl6" "skl7" "skl8" "skl9" "yr_emp1" "percapinc" "inc1" "inc2" "inc3" "inc4" "exp1" "exp2" "exp3" "exp4" "av1" "av2" "av3""
	
	/*
	local i = 1
	
	foreach y of local cov {
		
		local cov`i' "`y'"
		
		local j = 1
		
		foreach x of local cov`i' {
			
			local cov`i'`j' "`x'"
			
			local j = `j' + 1
		}
		
		local i = `i' + 1
		
	}
	
	di "`cov13'"
	*/
	
	local cond0 ""group" "promiseloan""
		
		local i = 1
		
		foreach y of local cond0 {
			
			local cond`i' "`y'"
			
			local i = `i' + 1
			
		}
		
	
	local sam ""Total Sample" "Loanee vs Trainee""
		
		local i = 1
		
		foreach y of local sam {
			
			local sam`i' "`y'"
			
			local i = `i' + 1
			
		}	
		
			
	local star "star_part no_star_part"
	
	local i = 1
	
	foreach y of local star {
		
		local star`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	
	
	
	
		
	
	
		local cond ""group==.""
	
		local h = 1
	
		foreach x of local cond {
			
			qui putexcel set Bal_Test_CA_20231105, modify sheet(`sam`h'')
			
			use "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd2", clear
			
			drop if `x'
			
			local a_2 = 2
		
			local a_1 = 3
		
			local a = 4
		
			local b = `a' + 1
		
			qui putexcel A`a_2' = "Indicators", bold
		
			qui putexcel B`a_2' = "`partloan`h''", bold txtwrap
		
			qui putexcel C`a_2' = "`nopartnoloan`h''", bold txtwrap
		
			qui putexcel D`a_2' = "Difference", bold txtwrap
			
			qui putexcel B`a_1' = "(1)"
		
			qui putexcel C`a_1' = "(2)"
		
			qui putexcel D`a_1' = "(3=1-2)"
			
			
			foreach z of local cov {
				
				qui ttest `z', by(`cond`h'')
				
				qui putexcel B`a' = `r(mu_2)', nformat(0.000)
	
				qui putexcel C`a' = `r(mu_1)', nformat(0.000)
	
				
				qui reg `z' `cond`h'', vce(robust)
				
				qui lincom `cond`h''
		
		if `r(estimate)' < 0 {
			
			local abest = abs(`r(estimate)')
		
		if `r(p)'<0.01 {
	
			qui putexcel D`a' = `abest', nformat(???\-0.000"***" "")
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel D`a' = `abest', nformat(??\-0.000"**" "")
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel D`a' = `abest', nformat(?\-0.000"*" "")
			
		}
	
		else {
	
			qui putexcel D`a' = `abest', nformat(\-0.000 "")
				
		}
		
		}
		
		else {
		
		if `r(p)'<0.01 {
	
			qui putexcel D`a' = `r(estimate)', nformat(???0.000"***")
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel D`a' = `r(estimate)', nformat(??0.000"**")
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel D`a' = `r(estimate)', nformat(?0.000"*")
			
		}
	
		else {
	
			qui putexcel D`a' = `r(estimate)', nformat(0.000)
				
		}
		
			
		}
		
			qui putexcel D`b' = `r(se)', nformat((0.000))
			
			qui describe `z'
	
			local v: var lab `z'
	
			qui putexcel A`a' = ("`v'"), txtwrap
			
			local a = `a' + 2
			
			local b = `a' + 1
			
			}
			
		qui putexcel A`a' = "Number of observations", bold
		
		qui count if `cond`h'' == 1 
		
		qui putexcel B`a' = `r(N)', bold
		
		qui count if `cond`h'' == 0
		
		qui putexcel C`a'= `r(N)', bold
		
		
		qui putexcel A1:D`a', font("Times New Roman", 9)
		
		qui putexcel B1:D`a', hcenter
		
		qui putexcel A2:D2, border(top)
		
		qui putexcel A3:D3, border(bottom)
		
		qui putexcel A`a':D`a', border(bottom)
		
		
		
	local h = `h' + 1
		
	}
	
	
	
				
			
	mata
	
	b = xl()
	
	b.load_book("Bal_Test_CA_20231105.xlsx")
	
	b.set_sheet("`sam1'")
	
	b.set_column_width(1,1,37.5) 
	
	b.set_column_width(2,4,15) 
	
	end
	
	
	
	
	