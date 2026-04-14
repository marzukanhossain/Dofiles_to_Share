/*******************************************************************************************
*Title: 20250223_IUPG_Analysis_Output_Graphs_MS
*Created by: Marzuk
*Created on: Feb 23, 2025
*Last Modified on:  Feb 23, 2025
*Last Modified by: 	Marzuk
*Purpose :  Creating Analysis Graphs 
	
*******************************************************************************************/

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
	
			global base_dir "D:\Dropbox\BIGD"
			
	} 
	else if "`c(username)'"=="Dell" {
	
			global base_dir "C:\Users\Mozumder\Dropbox"
			
	}
	else if "`c(username)'"=="tanvi" {
	
			global base_dir "C:\Users\tanvi\Dropbox"
			
	}	
	
			
	global proj_dir 	"$base_dir\UPGP intergeneration"
	
	global data_dir   		"$proj_dir\03_Data"
	
	global data_endline		"$data_dir\03_Endline"
	
	global data_e_sample		"$data_endline\01_Sample"
	
	global data_e_raw		"$data_endline\02_Raw"
	
	global data_er_mainlong		"$data_endline\02_Raw\20241201_Main_Survey\Long"
		
	global data_e_analysis  			"$data_endline\04_Analysis"
	
	global data_e_clean		"$data_endline\03_Clean"
	
	global results_endline			"$proj_dir\06_Results\03_Endline"
	
	global data_baseline		"$data_dir\01_Baseline\TUP 2007 data"
	
	global data_b_household		"$data_baseline\Household module\Stata label data"
	
	global do_file			"$proj_dir\04_Code\01_Baseline\01_Sample"
	
	global do_file_e_analysis			"$proj_dir\04_Code\03_Endline\04_Analysis"
	
	*/		
	
	global pilot "$proj_dir\04_Code\05_Pilot"
	
	global data_2018 "$proj_dir\03_Data\Fifth round survey of TUP (Phase-II)_2018_correction_from_LSE\Household\Stata data" 
	
	
	global mrdata_dfm		"$base_dir\RA_IUPG_Main_survey_2024\long"
	
	global trdata_dfm		"$base_dir\RA_IUPG_traced_survey_2024"
	
	
	
	
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
	global blue0 "15 36 98"
	global blue1 "158 202 225"
	global blue2 "66 146 198"
	global blue3 "8 81 156"
	
	global purple1 "188 189 220"
	global purple2 "128 125 186"
	global purple3 "84 39 143"
	
	
	
		
**# Female Income
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "personal_inc personal_inc personal_inc personal_inc"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0 
		
		local cona = `r(mean)'
	
		local con : display %9.0fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.0fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(6) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+1 t-1 l-1))  ///
			ylabel(0(500)2500, labsize(small) format(%9.0fc)) title("Income (BDT) of Traced Girls, by Age", justification(left) margin(b+1 t-1 l-1) bexpand size(small))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_f_inc.png", replace	
	
	
	
	
	
**# Male Income 
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "personal_inc personal_inc personal_inc personal_inc"
	
	local v7 ""sex==1&tr_agegp==1" "sex==1&tr_agegp==2" "sex==1&tr_agegp==3" "sex==1&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %9.0fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.0fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(6) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(5000)30000, labsize(small) format(%9.0fc)) title("Annual Income (BDT) of Traced Boys Disaggregated by Age", justification(left) margin(b+1 t-1 l-1) bexpand size(small))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_m_inc.png", replace	
	
	
	
	
*/	
	
**# Female IGA 
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "inc_gen_job1 inc_gen_job1 inc_gen_job1 inc_gen_job1"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %9.3fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.3fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.20cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(11) mlabangle(0) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(1) mlabangle(0) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-16 t+65 l-10)) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) pos(5) margin(b+2 t-15 l-1))  ///
			ylabel(0.2(0.1)0.7, labsize(small) format(%9.1fc) angle(0)) ///
			title("Proportion of Traced Girls in an Income Generating Activity Disaggregated by Age", justification() margin(b+1 t-1 l-1) pos(11) bexpand size() orientation(horizontal))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_f_iga.png", replace	
	
	
	
**# Female IGA combo
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "inc_gen_job1 inc_gen_job1 inc_gen_job1 inc_gen_job1"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %9.2fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.2fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.20cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(12) mlabangle(0) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(11) mlabangle(0) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-43.5 t+70 l-4)) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) pos(7) margin(b-1 t-5 l+2))  ///
			ylabel(0.2(0.1)0.7, labsize(small) format(%9.1fc) angle(90)) ///
			title("Proportion of Traced Girls in an Income Generating Activity", justification() margin(b+1 t-1 l-1) pos(9) bexpand size(small) orientation(vertical))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
	
	graph save "Graph_tracee_f_iga.gph", replace
	
	
	
	
	
**# Male IGA 
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "inc_gen_job1 inc_gen_job1 inc_gen_job1 inc_gen_job1"
	
	local v7 ""sex==1&tr_agegp==1" "sex==1&tr_agegp==2" "sex==1&tr_agegp==3" "sex==1&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %4.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %4.3fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %4.3fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(6) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(0.2)1, labsize(small)) title("Proportion of Traced Boys Involved in an Income Generating Activity Disaggregated by Age", justification(left) margin(b+1 t-1 l-1) bexpand size(small))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_m_iga.png", replace	
	
	
	
	
	
	
**# Female Savings 
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "personal_savings personal_savings personal_savings personal_savings"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %9.0fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.0fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.20cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(11) mlabangle(0) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(1) mlabangle(0) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) pos(5) margin(b+2 t-15 l-1))  ///
			ylabel(0(2000)8000, labsize(small) format(%9.0fc) angle(0)) ///
			title("Savings of Traced Girls Disaggregated by Age", justification() margin(b+1 t-1 l-1) pos(11) bexpand size() orientation(horizontal))  ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-16 t+65 l-10)) ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))

			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_f_sav.png", replace	

	
	
	
	
**# Female Savings combo
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "personal_savings personal_savings personal_savings personal_savings"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %9.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %9.0fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %9.0fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.20cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(12) mlabangle(0) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(11) mlabangle(0) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) pos(7) margin(b-1 t-5 l+2))  ///
			ylabel(0(2000)8000, labsize(small) format(%9.0fc) angle(90)) ///
			title("Personal Savings of Traced Girls", justification() margin(b+1 t-1 l-1) pos(9) bexpand size(small) orientation(vertical))  ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-43.5 t+70 l-4)) ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
		
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
	
	graph save "Graph_tracee_f_sav.gph", replace
		
	graph combine "Graph_tracee_f_iga.gph" "Graph_tracee_f_sav.gph", cols(2)
	
	graph export "Graph_tracee_f_iga_sav3.png", replace
	
	
	
	
	
**# Female Years fo Education
	
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "hhmc6 hhmc6 hhmc6 hhmc6"
	
	local v7 ""sex==0&tr_agegp==1" "sex==0&tr_agegp==2" "sex==0&tr_agegp==3" "sex==0&tr_agegp==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex tr_agegp `x'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `tada`b''
			
						
		}
		
		tempfile ladida
		
		save `ladida', replace
		
		restore
		
		local a = `a' + 1
						
	}
	
	use `ladida', clear
	
	
	gen cond = .
	
	gen y = .
	
	gen ub = .
	
	gen lb = .
	
	gen yapp = ""
	
	
	
	
	local a = 1
	
	foreach x of local v7 {
		
		replace cond = `a' if `x'
		
		//local v`a' "`x'"
		
		local a = `a' + 3
	
	}
	
	
	local a = 1
	
	foreach x of local v5 {
		
		local v0`a' "`x'"
		
		local a = `a' + 1
	
	}
	
	
	
	
	
	
	gen trea_cond = cond + treatment
	
	
	local a = 1
	
		foreach x of local v7 {
						
						
			reghdfe `v0`a'' treatment if `x', absorb(upz) vce(cluster pull_bocd)
			
			lincom treatment
			
			local bet = `r(estimate)'
			
			local no : display %4.0fc `e(N_full)'
			
			local ub = `r(ub)'
			
			local lb = `r(lb)'
			
			
		sum `v0`a'' if `x' & treatment==0
		
		local cona = `r(mean)'
	
		local con : display %4.1fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %4.1fc `ba'
		
		replace y = `cona' if `x' & treatment==0
		
		replace yapp = "`con'" if `x' & treatment==0
				
			replace ub = `ub' if `x' & treatment==1
			
			replace lb = `lb' if `x' & treatment==1
				
		replace y = `ba' if `x' & treatment==1
		
		lincom treatment
	
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
	
		replace yapp = "`be'" if `x' & treatment==1
			
		
		local a = `a' + 1		
		
		
		}
		
		
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) pos(5) margin(b+2 t-15 l-1))  ///
			ylabel(0(2)8, labsize(small)) ///
			title("Girls' Average Years of Schooling Disaggregated by Age", justification(left) margin(b+1 t-1 l-1) bexpand size() pos(11) orientation(horizontal))  ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-16 t+65 l-10)) ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_f_yedu.png", replace	
	
	
	
	//#The End
	
	
	