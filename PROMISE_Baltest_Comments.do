/******************************************************************************************************************
*Title: PROMISE_Baltest_Comments
*Created by: Marzuk
*Created on: July 11, 2023
*Last Modified on:  July 11, 2023
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
	lab var year "Probability of being:   2017 cohort"
	
	
	tab assetvalue_hh1, gen(av)
	
	local avlab ""Household with asset value - less than BDT 200,000" "Household with asset value - between BDT 200,000 and 500,000" "Household with asset value - more than BDT 500,000""
	 
	 local i = 1
	 
	 foreach x of local avlab {
	 	
		lab var av`i' "`x'"
		
		local i = `i' + 1
		
	 }
	 
	 
	tab inc_hh_mnth1, gen(inc)
	 
	local inclab ""Household with monthly income - less than BDT 5,000" "Household with monthly income - between BDT 5,000 and 6,000" "Household with monthly income - between BDT 6,000 and 7,000" "Household with monthly income - more than BDT 8,000""
			 
	 local i = 1
	 
	 foreach x of local inclab {
	 	
		lab var inc`i' "`x'"
		
		local i = `i' + 1
		
	 }
	
	
	 
	tab exp_hh_mnth1, gen(exp)
	 
	local explab ""Household with monthly spending - less than BDT 5,000" "Household with monthly spending - between BDT 5,000 and 6,000" "Household with monthly spending - between BDT 6,000 and 7,000" "Household with monthly spending - more than BDT 8,000""
			 
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
	
	
	save "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd1", replace
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
	
	
	
	local cov ""age" "educ1" "yr_emp1" "percapinc" "year" "star_part" "p_w_d" "indigenous"  "av1" "av2" "av3" "inc1" "inc2" "inc3" "inc4" "exp1" "exp2" "exp3" "exp4""
	
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
	
	
	
	
	
	
		
	
	
		local cond ""group==." "group==0""
	
		local h = 1
	
		foreach x of local cond {
			
			qui putexcel set Bal_Test_CA, modify sheet(`sam`h'')
			
			use "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd1", clear
			
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
	
	b.load_book("Bal_Test_CA.xlsx")
	
	b.set_sheet("`sam1'")
	
	b.set_column_width(1,1,45) 
	
	b.set_column_width(2,4,15) 
	
	b.set_sheet("`sam2'")
	
	b.set_column_width(1,1,45) 
	
	b.set_column_width(2,4,15) 
	
	end
	
			
	
	
		local imp ""Overall" "Training and Loan" "Training" "Additional Loan""
		
		local i = 1
		
		foreach y of local imp {
			
			local imp`i' "`y'"
			
			local i = `i' + 1
			
		}	
		
		
	
	/*
	probit group year star_part incmnth age p_w_d assetvalue_hh1 educ1 indigenous yr_emp1 inc_hh_mnth1 exp_hh_mnth1
		
	lincom year 
	
	return list
	*/
	
	
	
	
	local cov ""year star_part incmnth age p_w_d assetvalue_hh1 educ1 indigenous yr_emp1 inc_hh_mnth1 exp_hh_mnth1" "year star_part incmnth age p_w_d assetvalue_hh1 educ1 indigenous yr_emp1 inc_hh_mnth1" "year star_part incmnth age p_w_d assetvalue_hh1 educ1 indigenous" "year star_part incmnth age p_w_d yr_emp1 assetvalue_hh1 educ1 indigenous exp_hh_mnth1""
	
	local i = 1
	
	foreach y of local cov {
		
		local cov`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	local k = 0
	
	foreach y of local cov1 {
		
		local k = `k' + 1
		
	}
	
	di "`k'"
		
	local cond0 ""group" "group" "group" "promiseloan""
		
		local i = 1
		
		foreach y of local cond0 {
			
			local cond`i' "`y'"
			
			local i = `i' + 1
			
		}
		

		
		
		
		
	
	local alph "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	
	local i = 1
	
	foreach y of local alph {
		
		local alp`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	di "`alp24'"
	
	
	use "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd1", clear
	
	
	
	
	
	local colab ""Range of values of household's assets (in BDT)" "Household's monthly income range (in BDT)" "Household's monthly expenditure range (in BDT)""
	
	local i = 1
		
		foreach y of local colab {
			
			local colab`i' "`y'"
			
			local i = `i' + 1
			
		}	
		
		local i = 1
		
	foreach y of varlist assetvalue_hh1 inc_hh_mnth1 exp_hh_mnth1 {
		
		lab var `y' "`colab`i''"
		
			local i = `i' + 1
			
	}
	
	
	lab var incmnth "Household per capita monthly income (in BDT)"
	
	
	local cond ""group==." "group==1 & promiseloan==0" "promiseloan==1" "group==0""
	/*
	local h = 1
	
	foreach x of local cond {
	
	preserve
	
	probit `cond`h'' `cov`h'' 
	
	foreach y of 
	
	lincom year 
	
	return list
	
	restore
	
	local h = `h' + 1
	
	}
	*/
	
	
	
	
	local h = 1
	
	local i = 2
	
	foreach x of local cond {
		
		qui putexcel set Probit_CA, modify sheet(All4)
		
		local j = `i' + 1
				
		preserve
	
		drop if `x'
	
		
		local a_2 = 2
		
		local a_1 = 3
		
		local a = 4
		
		local b = `a' + 1
		
		qui putexcel `alp1'`a_1' = "Indicators", bold
		
		qui putexcel `alp`i''`a_1' = "Coefficient", bold txtwrap
		
		qui putexcel `alp`j''`a_1' = "Standard Error", bold txtwrap
		
		qui putexcel `alp`i''`a_2' = "`imp`h''", bold 
		
		qui putexcel `alp`i''`a_2':`alp`j''`a_2', merge
		
		
		
		
		probit `cond`h'' `cov`h''
				
		foreach y of local cov`h' {
		
		qui lincom `y'
		
		if `r(estimate)' < 0 {
		
		local abest = abs(`r(estimate)')
	
			if `r(p)' < 0.01 {
			
			qui putexcel `alp`i''`a' = `abest', nformat(???\-0.000"***" "")
			
			}
	
			else if `r(p)' < 0.05 {
	
			qui putexcel `alp`i''`a' = `abest', nformat(??\-0.000"**" "")
			
			}
	
			else if `r(p)' < 0.1 {
	
			qui putexcel `alp`i''`a' = `abest', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `alp`i''`a' = `abest', nformat(\-0.000 "")
				
			}
			
			
		}
		
		else {
		
		if `r(p)'<0.01 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(???0.000"***")
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(??0.000"**")
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(?0.000"*")
			
		}
	
		else {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(0.000)
				
		}
		
			
		}
			qui putexcel `alp`j''`a' = `r(se)', nformat(0.000)
				
		local v: var lab `y'
	
		qui putexcel `alp1'`a' = ("`v'"), txtwrap
		
		local a = `a' + 1
		
		}
			
		local a = `k' + 4
		
		qui putexcel `alp1'`a' = "Number of observations", bold
		
		qui count
		
		qui putexcel `alp`i''`a' = `r(N)', bold
		
		*qui putexcel `alp`i''`a':`alp`j''`a', merge
		
		
		restore
		
	local h = `h' + 1
	
	local i = `i' + 2
		
	}
	
		qui putexcel `alp1'1:`alp`j''`a', font("Times New Roman", 9)
		
		qui putexcel `alp2'1:`alp`j''`a', hcenter
		
		qui putexcel `alp1'2:`alp`j''2, border(top)
		
		qui putexcel `alp1'3:`alp`j''3, border(bottom)
		
		qui putexcel `alp1'`a':`alp`j''`a', border(bottom)
		
	
	
	local c = `a' - 2
	
	local i = `j' - 1
	
	
	local a = `a' - 1
	
	preserve 
	
	drop if group==0
	
	
	probit `cond4' `cov4'
		
		qui lincom exp_hh_mnth1
		
		
		if `r(estimate)' < 0 {
		
		local abest = abs(`r(estimate)')
	
			if `r(p)' < 0.01 {
			
			qui putexcel `alp`i''`a' = `abest', nformat(???\-0.000"***" "")
			
			}
	
			else if `r(p)' < 0.05 {
	
			qui putexcel `alp`i''`a' = `abest', nformat(??\-0.000"**" "")
			
			}
	
			else if `r(p)' < 0.1 {
	
			qui putexcel `alp`i''`a' = `abest', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `alp`i''`a' = `abest', nformat(\-0.000 "")
				
			}
			
			
		}
		
		else {
		
		if `r(p)'<0.01 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(???0.000"***")
			
		}
	
		else if `r(p)'<0.05 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(??0.000"**")
			
		}
	
		else if `r(p)'<0.1 {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(?0.000"*")
			
		}
	
		else {
	
			qui putexcel `alp`i''`a' = `r(estimate)', nformat(0.000)
				
		}
		
		}
		
		qui putexcel `alp`j''`a' = `r(se)', nformat(0.000)
			
		
				
		qui putexcel `alp`i''`c' = ""
		
		qui putexcel `alp`j''`c' = ""
	
	
	foreach z of varlist inc_hh_mnth1 exp_hh_mnth1 {
						
		local v: var lab `z'
	
		qui putexcel `alp1'`c' = ("`v'"), txtwrap
		
		local c = `c' + 1
		
		local j = `j' - 1
				
	}
	
	restore
	
	
	
	 
	mata
	
	b = xl()
	
	b.load_book("Probit_CA.xlsx")
	
	b.set_sheet("All4")
	
	b.set_column_width(1,1,36) 
	
	b.set_column_width(2,9,10) 
	
	end
	
	
		
		
		
	
	
	
	
	
	
	
	
	
	
	
			
			
			