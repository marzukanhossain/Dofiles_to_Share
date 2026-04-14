/*******************************************************************************************
*Title: 20250203_IUPG_Analysis_Report_Graphs
*Created by: Marzuk
*Created on: Jan 10, 2025
*Last Modified on:  Jan 10, 2025
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
	
	global results			"$proj_dir\06_Results\03_Endline"
	
	*/		
	
	global pilot "$proj_dir\04_Code\05_Pilot"
	
	global data_2018 "$proj_dir\03_Data\Fifth round survey of TUP (Phase-II)_2018_correction_from_LSE\Household\Stata data" 
	
	
	global mrdata_dfm		"$base_dir\RA_IUPG_Main_survey_2024\long"
	
	global trdata_dfm		"$base_dir\RA_IUPG_traced_survey_2024"
	
	
	
		
	use "$data_e_clean\20241214_IUPG_respof2007_survey_clean", clear
	
	
	cd "$do_file_e_analysis\Graphs"
	
	
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
	
	
	
	local grey1 "230 230 230"
	local grey2 "200 200 200"
	local grey3 "170 170 170"
	local grey4 "140 140 140"
	local grey5 "110 110 110"
	local grey6 "80 80 80"
	local grey7 "50 50 50"
	local grey8 "20 20 20"
	
	
	lab var health_exp_15 "15-day expenses for recent illness"
	
	lab var hsb1 "Likelihood of suffering from an illness within the last 15 days"
	
	
	local v2 "health_exp_15 hsb1 life_satisfaction personal_inc hh_income"
	
	local v4 "mr_agegp==1 mr_agegp==2 mr_agegp==3 mr_agegp==4 mr_agegp==5"
	
	local v3 "<40 40-49 50-59 60-69 70+"
	
	local yl ""-50(50)250" "-0.05(0.05)0.2" "" "" """
	
	local a = 1
	
	foreach x of local yl {
		
		local yl`a' "`x'"
		
		local a = `a' + 1
		
	}
	
	
	
	gen yapp = ""
	
	local f = 0
	
	foreach y of local v2 {
	
	local f = `f' + 1
	
	local a = 1
	
	local v0`f': var lab `y'
	
	local coef "coefplot "
	
	foreach x of local v3 {
		
		reghdfe `y' treatment if tracer==0 & mr_agegp==`a', absorb(upz) vce(cluster pull_bocd)
		
		eststo reg`a'
				
		
		
		
		
		local coef "`coef' (reg`a', aseq("`x'") mcolor("$blue3") msymbol(O) msize(small) ciopts(recast(rcap) color("$blue3%50")) mlabgap(1) mlabsize(vsmall) mlabel(cond(@pval<.01, string(@b, "%9.3fc") + "***", cond(@pval<.05, string(@b, "%9.3fc") + "**", cond(@pval<.1, string(@b, "%9.3fc") + "", string(@b, "%9.3fc"))))))"
		
		local a = `a' + 1
		
	}
 	
	
	`coef', aseq swapnames vertical mlabposition(3) mlabcolor("$blue0") title("`v0`f'' disaggregated by age", justification(left) margin(b+1 t-1 l-1) bexpand size(small)) legend(off) coeflabels(, wrap(40)) drop(_cons)  ylabel(`yl`f'', angle(horizontal) labsize(small)) xlabel(, labsize(small)) mlabgap(*0.5) mlabsize(vsmall) scheme(white_tableau) plotregion(color(white) fcolor(white)) graphregion(color(white) fcolor(white)) yline(0, lcolor("$blue3") noextend lpattern(dash))
	
	graph export "graph_`y'.png", replace 
		
	}
	
	
	