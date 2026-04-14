/*******************************************************************************************
*Title: 20250216_IUPG_Analysis_MS_Graphs
*Created by: Marzuk
*Created on: Feb 16, 2025
*Last Modified on:  Feb 16, 2025
*Last Modified by: 	Marzuk
*Purpose :  Creating Analysis Graphs for Munshi Bhai 
	
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
	
			global base_dir "C:\Users\marzu\Dropbox\BIGD"
			
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
	
	
	
			
	//Healthcare Illness
	
	local v1 ""2 years follow-up" "4 years follow-up" "7 years follow-up" "17 years follow-up""
	
	
	
	
	local v5 ""
	
	local v7 ""tracer==0 & hsb1!=." "tracer==0 & hsb2!=.""
	
	
	local a = 1
	
	foreach x of local v1 {
		
		local v0`a' "`x'"
		
		local a =`a'+1
		
		
		
	}
	
	
	
	local a = `a' + 1
	
	
	
	
	set obs `a'
	
	gen cond = _n
	
	replace cond = cond - 1
	
	replace cond = 0.5 if cond==0
	
	replace cond = 4.5 if cond==5
	
	gen y = .
	
	gen y07 = .
	
	gen ub = .
	
	gen ub07 = .
	
	gen lb = .
	
	gen lb07 = .
	
	gen yapp = ""
	
	
	local y1  ""112.2" "358.2" "327.2""
	
	local ys1  ""112.2*" "358.2***" "327.2***""
	
	local se1  ""62.6" "63.5" "119.5""
	
	local y2  ""606.4" "972.6" "782.8""
	
	local ys2  ""606.4***" "972.6***" "782.8***""
	
	local se2  ""92.1" "158.3" "214.6""
		
	local y3  ""62.3" "87.8" "0""
		
	local ys3  ""62.3**" "87.8***" """
	
	local se3  ""30.2" "28.6" "0""
		
	local yse  "y ys se"
	
	
	foreach z of local yse {
	
	foreach y of numlist 1/3{
	
	local a = 0
	
	foreach x of local `z'`y' {
		
		local a =`a'+1
		
		local `z'`y'`a' "`x'"
		
	}
	
	}
	
	}
	
	
	
	local vars "yr_cons productive_asset personal_inc"
	
	local a = 1
	
	foreach x of local vars{
	
	
	
	tempfile tada
	
	
	foreach y of numlist 1/4 {
	
	if `y'<4 {
	
	replace y07 = `y`a'`y'' if cond==`y'
	
	replace ub07 = y07 + (`se`a'`y''*1.96) if cond==`y'
	
	replace lb07 = y07 - (`se`a'`y''*1.96) if cond==`y'
	
	
	replace y = y07*28.63/18.46 if cond==`y'
	
	replace ub = ub07*28.63/18.46 if cond==`y'
	
	replace lb = lb07*28.63/18.46 if cond==`y'
	
	if `a'==1 & `y'==1{
		
		replace yapp = "*" if cond==`y'
		
	}
	
	else if `a'==3 & `y'==1 {
		
		replace yapp = "**" if cond==`y'
				
	}
	
	else if `a'==3 & `y'==3 {
		
		replace yapp = "" if cond==`y'
				
	}
	
	else {
		
		replace yapp = "***" if cond==`y'
				
	}
	
	
	save `tada', replace
	
	
	}
	
	else {
		
	if `a' <3 {
		
		use "$data_e_clean\20241214_IUPG_mainresp_survey_clean", clear
				
	reghdfe `x' treatment if consent==1, absorb(upz) vce(cluster pull_bocd)
	
	lab var yr_cons "Consumption (in 2007 PPP)"
	
	local vlab: var lab `x'
		
	}	
	
	else {
		
		use "$data_e_clean\20241214_IUPG_respof2007_survey_clean", clear
		
		reghdfe `x' treatment if tracer==0, absorb(upz) vce(cluster pull_bocd)
		
	local vlab: var lab `x'
	
	}
		
	
			lincom treatment
			
			local r(estimate) = `r(estimate)'
			
			local r(ub) = `r(ub)'
			
			local r(lb) = `r(lb)'
			
			use `tada', clear
			
			replace y = `r(estimate)' if cond==`y'
			
			replace ub = `r(ub)' if cond==`y'
			
			replace lb = `r(lb)' if cond==`y'
			
		replace y07 = ((y/1.0973)/28.63)*(18.46/28.63) if cond==`y'
	
			replace ub07 = ((ub/1.0973)/28.63)*(18.46/28.63) if cond==`y'
			
			replace lb07 = ((lb/1.0973)/28.63)*(18.46/28.63) if cond==`y'
			
			local be: display cond(`r(p)'<.01, "***", cond(`r(p)'<.05, "**", cond(`r(p)'<.1, "*", "")))
			
	replace yapp = "`be'" if cond==`y'
		
	}
	
	}
	
	egen ys = concat (y07 yapp), format(%9.1fc) punct("")
	
	twoway  (scatter y07 cond, msymbol(O) mcolor("$blue3") mlabel(ys) mlabposition(3) mlabcolor("$blue0")) (rcap ub07 lb07 cond, color("$blue3%50")) ///  change mlabposition if 6 if you want the values to be inside
			,xlabel(1 "`v01'" 2 "`v02'" 3 "`v03'" 4 "`v04'",) ///
			legend( off) ///
			ytitle("") subtitle("", justification(left) margin(b+1 t-1 l-1) bexpand size(1)) ///
			ylabel(, labsize(small)) title("Impact on `vlab'", justification(left) margin(b+1 t-1 l-1) bexpand size(small))  ///
			graphregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white)) ///
			plotregion(color(white) fcolor(white) icolor(white) ifcolor(white) lcolor(white) ilcolor(white))       xtitle("", size(small)) ///
			note(, size(vsmall)) ///
			caption(, size(vsmall)) yline(0, lcolor("$blue3") noextend lpattern(dash))
			
			
	cd "$do_file_e_analysis\Graphs"
	
		drop ys
			
	graph export "20250223_Graph_followup_comparison_`x'.png", replace	
	
	
	
	
	
	local a = `a' + 1
	
	}


