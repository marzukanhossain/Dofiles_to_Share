/******************************************************************************************************************
*Title: PROMISE_Analysis_Comments_20231104
*Created by: Marzuk
*Created on: November 04, 2023
*Last Modified on:  November 04, 2023
*Last Modified by: 	Marzuk
*Purpose :  Remaking all the tables to accomodate for reviewers' comments
	
*****************************************************************************************************************/

	clear all
	set more off
	capture log close
	set logtype text

	local date=c(current_date)
	local time=c(current_time)
	
	local mydate : display %tdCCYYNNDD date(c(current_date), "DMY")
	
	local mytime : display %tcCCYYNNDD-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMY hms")
	
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
	
	global do_file			"$base_dir\04_PROMISE\04_Code\03_Endline\04_Analysis\02_Analysis_Marzuk"
	*/		
	
	
	di "`mydate'"
	
	di "`mytime'"
	
	
	local alp "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
	
	local i = 1
	
	foreach y of local alp {
		
		local al`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	di "`al24'"
	
	
	
	use "$data_endline_analysis\Promise_Analysis_Inc_Occu_LSE_labd", clear
	
	
	
	local partloan ""Participant (training and loan)" "Participant (only training)" " Participant (training and loan)""
	
	local i = 1
	
	foreach y of local partloan {
		
		local partloan`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	
	local nopartnoloan ""non-participants" "non-participants" "participants (only training)""
	
	local i = 1
	
	foreach y of local nopartnoloan {
		
		local nopartnoloan`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	
	
	local cond0 ""group" "group" "promiseloan""
		
		local i = 1
		
		foreach y of local cond0 {
			
			local cond`i' "`y'"
			
			local i = `i' + 1
			
		}
		

		local imp ""Training+Loan" "Training" "Addl_Loan""
		
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
		
	
	
	local cov ""year star_part incmnth age p_w_d indigenous yr_emp1 inc_hh_mnth1 assetvalue_hh1 educ1" "year star_part incmnth age p_w_d indigenous assetvalue_hh1 educ1" "year star_part incmnth age p_w_d indigenous yr_emp1 assetvalue_hh1 exp_hh_mnth1 educ1""
	
	local i = 1
	
	foreach y of local cov {
		
		local cov`i' "`y'"
		
		local i = `i' + 1
		
	}
	
	
	

	
	local cond ""group==1 & promiseloan==0" "promiseloan==1" "group==0""
	
	
	

	
	local cond ""group==1 & promiseloan==0" "promiseloan==1" "group==0""
	
	local h = 1
	
	local i = 2
	
	foreach x of local cond {
		
		local j = `i' + 1
		
		qui putexcel set Results_Tables_CA_20231104, modify sheet(Training_vs_Loan)
		
				
		use "$data_endline_analysis\Promise_Analysis_Ready_Inc_labd", clear
	
		drop if `x'
	
		
		local a_2 = 2
		
		local a_1 = 3
		
		local a = 4
		
		local b = `a' + 1
		
		qui putexcel `al1'`a_1' = "Indicators", bold
		
		qui putexcel `al`i''`a_1' = "Impact", bold txtwrap
		
		qui putexcel `al`j''`a_1' = "Mean of `nopartnoloan`h''", bold txtwrap
		
		qui putexcel `al`i''`a_2' = "Panel `al`h''", bold txtwrap
		
		qui putexcel `al`i''`a_2':`al`j''`a_2', merge
		
		
		
		set more off

		qui pscore `cond`h'' `cov`h'', pscore (z)
		
		qui psmatch2 `cond`h'' `cov`h'', outcome (q1000_17) neighbor (5) common ate

		local tstat = `r(att)'/`r(seatt)'
		
		if `r(att)'<0 {
			
			local abatt = abs(`r(att)')
	
			if `tstat' < -2.58 {
			
			qui putexcel `al`i''`a' = `abatt', nformat(???\-0.000"***" "")
			
			}
	
			else if `tstat' < -1.96 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(??\-0.000"**" "")
			
			}
	
			else if `tstat' < -1.65 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `abatt', nformat(\-0.000 "")
				
			}
			
		}
		
		else {
			
			if `tstat' > 2.58 {
			
			qui putexcel `al`i''`a' = `r(att)', nformat(???0.000"***")
			
			}
	
			else if `tstat' > 1.96 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(??0.000"**")
			
			}
	
			else if `tstat' > 1.65 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(?0.000"*")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(0.000)
				
			}
			
		}
			
		
		qui putexcel `al`i''`b' = `r(seatt)', nformat((0.000))
				
		qui sum _q1000_17 if `cond`h'' == 1
		
		qui putexcel `al`j''`a' = `r(mean)', nformat(0.000)
		
		local v: var lab q1000_17
	
		qui putexcel `al1'`a' = ("`v'"), txtwrap
		
		local a = `a' + 2
		
		drop z

		
		
		use "$data_endline_analysis\Promise_Analysis_Ready_Occu_labd", clear
		
		drop if `x'
		
		qui putexcel `al1'`a' = "Employment (Yes=1, No=0) in last one month:", bold txtwrap
		
		local a = `a' + 1
		
		foreach z of varlist y1 y2 y3 y4 {
			
		local b = `a' + 1
		
		set more off

		qui pscore `cond`h'' `cov`h'', pscore (z)

		qui psmatch2 `cond`h'' `cov`h'', outcome (`z') neighbor (5) common ate

		local tstat = `r(att)'/`r(seatt)'
		
		if `r(att)'<0 {
	
			local abatt = abs(`r(att)')
	
			if `tstat' < -2.58 {
			
			qui putexcel `al`i''`a' = `abatt', nformat(???\-0.000"***" "")
			
			}
	
			else if `tstat' < -1.96 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(??\-0.000"**" "")
			
			}
	
			else if `tstat' < -1.65 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `abatt', nformat(\-0.000 "")
				
			}
			
			
		}
		
		else {
			
			if `tstat' > 2.58 {
			
			qui putexcel `al`i''`a' = `r(att)', nformat(???0.000"***")
			
			}
	
			else if `tstat' > 1.96 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(??0.000"**")
			
			}
	
			else if `tstat' > 1.65 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(?0.000"*")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(0.000)
				
			}
			
		}
		
		qui putexcel `al`i''`b' = `r(seatt)', nformat((0.000))
				
		qui sum _`z' if `cond`h'' == 1
		
		qui putexcel `al`j''`a' = `r(mean)', nformat(0.000)
		
		local v: var lab `z'
	
		qui putexcel `al1'`a' = ("`v'"), txtwrap
		
		local a = `a' + 2
		
		drop z
			
		}

		
		qui putexcel `al1'`a' = "Hours worked in a day:", bold
		
		local a = `a' + 1
		

		foreach z of varlist wh* {
			
		local b = `a' + 1
		
		set more off

		qui pscore `cond`h'' `cov`h'', pscore (z)

		qui psmatch2 `cond`h'' `cov`h'', outcome (`z') neighbor (5) common ate

		local tstat = `r(att)'/`r(seatt)'
		
		if `r(att)'<0 {
	
			local abatt = abs(`r(att)')
	
			if `tstat' < -2.58 {
			
			qui putexcel `al`i''`a' = `abatt', nformat(???\-0.000"***" "")
			
			}
	
			else if `tstat' < -1.96 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(??\-0.000"**" "")
			
			}
	
			else if `tstat' < -1.65 {
	
			qui putexcel `al`i''`a' = `abatt', nformat(?\-0.000"*" "")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `abatt', nformat(\-0.000 "")
				
			}
			
			
		}
		
		else {
			
			if `tstat' > 2.58 {
			
			qui putexcel `al`i''`a' = `r(att)', nformat(???0.000"***")
			
			}
	
			else if `tstat' > 1.96 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(??0.000"**")
			
			}
	
			else if `tstat' > 1.65 {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(?0.000"*")
			
			}
	
			else {
	
			qui putexcel `al`i''`a' = `r(att)', nformat(0.000)
				
			}
			
		}
		
		qui putexcel `al`i''`b' = `r(seatt)', nformat((0.000))
				
		qui sum _`z' if `cond`h'' == 1
		
		qui putexcel `al`j''`a' = `r(mean)', nformat(0.000)
		
		local v: var lab `z'
	
		qui putexcel `al1'`a' = ("`v'"), txtwrap
		
		local a = `a' + 2
		
		drop z
			
		}
		
		
		qui putexcel `al1'`a' = "Number of observations", bold
		
		qui count if `cond`h''!=.
		
		qui putexcel `al`i''`a' = `r(N)', bold
		
		qui count if `cond`h'' == 0
		
		qui putexcel `al`j''`a'= `r(N)', bold
			
		
	local h = `h' + 1
	
	local i = `i' + 2
		
	}
	
		
		qui putexcel `al1'1:`al`j''`a', font("Times New Roman", 9)
		
		qui putexcel `al2'1:`al`j''`a', hcenter
		
		qui putexcel `al1'2:`al`j''2, border(top)
		
		qui putexcel `al1'3:`al`j''3, border(bottom)
		
		qui putexcel `al1'`a':`al`j''`a', border(bottom)
		
		
	
	
	
	
	
	
	mata
	
	b = xl()
	
	b.load_book("Results_Tables_CA_20231104.xlsx")
	
	b.set_sheet("Training_vs_Loan")
	
	b.set_column_width(1,1,30) 
	
	b.set_column_width(2,`j',11) 
	
	end
	
	
	
	
	
	
	