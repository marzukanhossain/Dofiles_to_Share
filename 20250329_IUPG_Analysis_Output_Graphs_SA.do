/*******************************************************************************************
*Title: 20250329_IUPG_Analysis_Output_Graphs_SA
*Created by: Marzuk
*Created on: Mar 29, 2025
*Last Modified on:  Mar 29, 2025
*Last Modified by: 	Marzuk
*Purpose :  Creating Analysis Graphs for Shaila Apa 
	
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
	
	
	
	
	/* The Do-file running requirements
	
	Change the variable names on the "local v5" and add the required conditions on "local v7"
	
	
	
	*/
	
	
	
				
**# Female having child
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "have_child1 have_child1 have_child1 have_child1"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==0&tr_agegp==1&condition==1" "consent==1&hpcp1_tr!=.&sex==0&tr_agegp==2&condition==2" "consent==1&hpcp1_tr!=.&sex==0&tr_agegp==3&condition==3" "consent==1&hpcp1_tr!=.&sex==0&tr_agegp==4&condition==4""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_agegp `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_agegp `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(15) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(15) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabgap() mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabgap(tiny) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "16-17" 4.5 "18-20" 7.5 "21-25" 10.5 "26-33",) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5))  ///
			ylabel(0(0.2)1, labsize(small)) ///
			title("Proportion of Traced Girls Having Children Disaggregated by Age", justification(left) margin(b+1 t-1 l-1) bexpand size() pos(11) orientation(horizontal))  ///
			b1title("Age", justification(right) size(small) pos(4) margin(b-16 t+65 l-10)) ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "Graph_tracee_f_chl_sa.png", replace	
	
	
	
	
	
	
			
**# Male years of schooling
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "hhmc6 hhmc6 hhmc6"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==1&condition==1" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==0&condition==2" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==1&condition==3""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(20) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(20) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabgap(tiny) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "All traced boys" 4.5 `"`r(secondbar)'"' 7.5 `"`r(thirdbar)'"',) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(2)6, labsize(small)) title("Boys' Average Years of Schooling", justification(left) margin(b+1 t-1 l-1) bexpand size())  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5) size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "20260318_Graph_tracee_m_skl_sa.png", replace	
	
	
	
	
	
	
**# Male IGA
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "inc_gen_job1 inc_gen_job1 inc_gen_job1"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==1&condition==1" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==0&condition==2" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==1&condition==3""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(20) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(20) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabgap(tiny) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "All traced boys" 4.5 `"`r(secondbar)'"' 7.5 `"`r(thirdbar)'"',) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(0.2)1, labsize(small)) title("Proportion of Traced Boys Involved in an Income Generating Activity", justification(left) margin(b+1 t-1 l-1) bexpand size())  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5) size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "20260318_Graph_tracee_m_iga_sa.png", replace	
	
	
	
	
	
**# Male savings
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "personal_savings personal_savings personal_savings"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==1&condition==1" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==0&condition==2" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==1&condition==3""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(20) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(20) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "All traced boys" 4.5 `"`r(secondbar)'"' 7.5 `"`r(thirdbar)'"',) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(2000)8000, labsize(small) format(%9.0fc)) title("Savings of Traced Boys", justification(left) margin(b+1 t-1 l-1) bexpand size())  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5) size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "20260318_Graph_tracee_m_sav_sa.png", replace	
	
	
	
	
	
	
	
	
	
	
	
**# Male father-in-law land
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "father_inlaw_extland father_inlaw_extland father_inlaw_extland"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==1&condition==1" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==0&condition==2" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==1&condition==3""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
	
		local con : display %4.2fc `cona'
		
		local ub = `ub' + `r(mean)'
		
		local lb = `lb' + `r(mean)'
		
		local ba = `bet' + `r(mean)'
		
		local b : display %4.2fc `ba'
		
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(20) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(20) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "All traced boys" 4.5 `"`r(secondbar)'"' 7.5 `"`r(thirdbar)'"',) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(5)20, labsize(small)) title("Extra Land Owned by Father-in-law Compared to Father During Wedding of the Traced Boys", justification(left) margin(b+1 t-1 l-7) bexpand size())  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5) size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "20260318_Graph_tracee_m_fln_sa.png", replace	
	
	
	
	
	
**# Male mahr payment
	
	
	use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear

		
	local v5 "hhmne5_p1_tr hhmne5_p1_tr hhmne5_p1_tr"
	
	local v7 ""consent==1&hpcp1_tr!=.&sex==1&condition==1" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==0&condition==2" "consent==1&hpcp1_tr!=.&sex==1&tr_ch_2007res==1&condition==3""
	
	
	local a = 1
	
	
	
	foreach x of local v5 {
		
		preserve
		
		local b = `a' - 1
		
		if `a'==1 {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
						
		}
		
		else {
			
			keep treatment upz pull_bocd tracer sex consent hpcp1_tr tr_ch_2007res `x'
			
			gen condition = `a'
			
			tempfile tada`a'
			
			save `tada`a''
			
			append using `ladida'
			
						
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
		
	
	linewrap , longstring(`"Traced boys (not children of baseline respondent)"') maxlength(20) stack name(secondbar)
	
	linewrap , longstring(`"Traced boys (children of baseline respondent)"') maxlength(20) stack name(thirdbar) add
	
		
		
	
	twoway  (bar y trea_cond if treatment==0, color("$blue1")) ///
			(bar y trea_cond if treatment==1, color("$blue3")) ///
			(rcap ub lb trea_cond if treatment==1, color("$blue0") msize(0.25cm)) ///
			(scatter y trea_cond if treatment==0, msymbol(i) mlabel(yapp) mlabposition(10) mlabcolor("$blue0")) (scatter y trea_cond if treatment==1, msymbol(i) mlabel(yapp) mlabposition(2) mlabcolor("$blue0")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1.5 "All traced boys" 4.5 `"`r(secondbar)'"' 7.5 `"`r(thirdbar)'"',) ///
			legend(order(1 "Control" 2 "Treatment") row(1) pos(7) size()) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(0(5000)25000, labsize(small) format(%9.0fc)) title("Mahr Payment Made by the Traced Boys", justification(left) margin(b+1 t-1 l-1) bexpand size())  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note("Note: ***, ** and * represent 10%, 5% and 1% significance levels, respectively.", justification(left) margin(b+2 t-15 l-1) pos(5) size(vsmall)) ///
			caption(, size(vsmall))
			
			
			
		drop cond y yapp ub lb trea_cond
		
		cd "$do_file_e_analysis\Graphs"
			
	graph export "20260318_Graph_tracee_m_mhr_sa.png", replace	
	
	
	
	
	
	//#The End
	
	
	
	
	