/************************************************************************************
*Title: 20250914_IPV_Analysis_Regressions
*Created by: Marzuk
*Created on: Sep 14, 2025
*Last Modified on:  Sep 14, 2025
*Last Modified by: 	Marzuk
*Purpose :  Analysis of IPV Data Regressions 
	
************************************************************************************/

	
/*
        *
      /-/
     /-/
  . /-/ 
 /|\   
 / \
 
 */
 



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
	
			global base_dir "D:\Dropbox\BIGD\"
			
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
	
	global data_er_main		"$data_endline\02_Raw\20241201_Main_Survey"
		
	global data_e_analysis  			"$data_endline\04_Analysis"
	
	global data_e_clean		"$data_endline\03_Clean"
	
	global results_endline			"$proj_dir\06_Results\03_Endline"
	
	global data_baseline		"$data_dir\01_Baseline\TUP 2007 data"
	
	global data_b_household		"$data_baseline\Household module\Stata label data"
	
	global do_file			"$proj_dir\04_Code\01_Baseline\01_Sample"
	
	global do_file_e_analysis			"$proj_dir\04_Code\03_Endline\04_Analysis"
	*/		
	
	global data_b_clean		"$data_dir\01_Baseline\03_Clean"
	
	global pilot "$proj_dir\04_Code\05_Pilot"
	
	global data_2018 "$proj_dir\03_Data\Fifth round survey of TUP (Phase-II)_2018_correction_from_LSE\Household\Stata data" 
	
	
	global mrdata_dfm		"$base_dir\RA_IUPG_Main_survey_2024\long"
	
	global trdata_dfm		"$base_dir\RA_IUPG_traced_survey_2024"
	
	

	
	use "$data_e_analysis\20250912_IPV_Analysis", clear
	
	cd "$do_file_e_analysis\Excel"
	
	reg overstatement treat_hybrib_acasi treat_word_sym treat_acasi_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, vce(robust)
	
	local abs ""a(enu_code pull_dist_code) vce(robust)""
	
	local note1 "Notes: Robust standard errors are in parantheses with district and enumerator fixed effects. *, ** and *** represent 10%, 5% and 1% significance levels, respectively."
	
	local nam "_fe"
	
	local a = 0
	/*
	foreach x of local note {
		
		local a = `a' + 1
		
		local note`a' "`x'"
		
	}
	*/
	
	local a = 0
	
	foreach x of local nam {
		
		local a = `a' + 1
		
		local nam`a' "`x'"
		
	}
	
	
	
	local vars ""hvaw_ever_ipv hvaw_lastyr_ipv" "hvaw1_ever_slap hvaw1_ever_push hvaw1_ever_kick hvaw1_ever_batonbash  hvaw2_lastyr_slap hvaw2_lastyr_push hvaw2_lastyr_kick hvaw2_lastyr_batonbash" "hdhs_gen_ipv hdhs_gen_ipv_pc" "hdhs_goes_out hdhs_neglects_child hdhs_argues hdhs_refuses_intimacy hdhs_burns_food""
	
	
	local treats "treat_hybrib_acasi treat_word_sym treat_order_prompt treat_acasi_sym treat_acasi_prompt treat_sym_prompt treat_acasi_sym_prompt _cons"
	
	
	*local sex """ "& sex==0""
	
	local s "Any_IPV IPV_Types Gen_Atd Gen_Atd_typ"
	
	local s2 "IPV_Types"
	
	
	local a = 0
	
	foreach x of local s {
		
		local a = `a' + 1
		
		local s`a' "`x'"
		
	}
	
	
	local e "end"
	
	local g = 0
	
	foreach opt of local abs {
	
	local g = `g' + 1
	
	local f = 0
	
	foreach z of local vars {
		
		local f = `f' + 1
		
		local var`f' "`z'"
	
	local c = 1
	
	foreach x of local var`f' {
		
		local c = `c' + 1
		
		local lb2_`c' : var lab `x'
		
		if `f' <=2 {
		
		local treats "treat_hybrib_acasi treat_order_prompt treat_acasi_prompt _cons"
	
		reghdfe `x' treat_hybrib_acasi treat_order_prompt  treat_acasi_prompt treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, `opt' 
		
			
	}
		
		else {
		
		
		local treats "treat_hybrib_acasi treat_order_reverse treat_acasi_reverse _cons"
	
		
		reghdfe `x' treat_hybrib_acasi treat_order_reverse treat_acasi_reverse treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, `opt' 
		
		
		
	}
		
		local n26_`c' : display %9.0fc `e(N)'
		
		
	di `n26_`c''
	
		
		local r = 1
		
		foreach y of local treats {
			
			local r = `r' + 3
			
			local w = `r' + 1
			
			if  `r'<13 {
				
				
			local la`r'_1: var lab `y'
			
				
			qui lincom `y'
			
			local bet = `r(estimate)'
	
		local se`w'_`c' : display cond(`bet'>0 | `bet'<=0, "(" + string(`r(se)', "%9.3fc") + ")", "(" + string(`r(se)', "%9.3fc") + ")")
		
				
			} 
			/*
			else if `f'>2 &`r'<25 {
			
			local la`r'_1: var lab `y'
			
				
			qui lincom `y'
			
			local bet = `r(estimate)'
	
		local se`w'_`c' : display cond(`bet'>0 | `bet'<=0, "(" + string(`r(se)', "%9.3fc") + ")", "(" + string(`r(se)', "%9.3fc") + ")")
		
			
			}
			*/
			else {
			
			qui lincom `y'
			
			local bet = `r(estimate)'
	
			}
		
		local b`r'_`c' : display cond(`bet'>=0, cond(`r(p)'<.01, "     " + string(`r(estimate)', "%9.3fc") + "***", cond(`r(p)'<.05, "   " + string(`r(estimate)', "%9.3fc") + "**", cond(`r(p)'<.1, " " + string(`r(estimate)', "%9.3fc") + "*", string(`r(estimate)', "%9.3fc") ))), cond(`r(p)'<.01, "     " + string(`r(estimate)', "%9.3fc") + "*** ", cond(`r(p)'<.05, "   " + string(`r(estimate)', "%9.3fc") + "** ", cond(`r(p)'<.1, " " + string(`r(estimate)', "%9.3fc") + "* ", string(`r(estimate)', "%9.3fc") + " " ))))
			
			
		}
		
		local c_1 = `c' - 1
		
		local top_3_`c'  "(`c_1')"
					
		
	} 
	
	di `w'
	
	local w = `w' + 1
	
	local v = `w' + 1
	
	di `n26_`c''
	
			qui putexcel set Table_Excel_IPV_Analysis, modify sheet(`s`f''`nam`g'', replace)
			
			putexcel B2 = "1"
			
			putexcel save
			
			
			mata
			
			b = xl()
			
			b.load_book("Table_Excel_IPV_Analysis.xlsx")
			
			b.set_sheet("`s`f''`nam`g''")
			
			b.set_mode("open")
			
						
				
	
			
			b.put_string(1, 1, "Impact of modes of data collection on IPV reporting")
			
			b.put_string(`v', 1, "`note1'")
					
			b.set_merge((1,1), (1,`c'))
			
			b.set_text_wrap((1,1), (1,`c'), "on")
						
			b.set_merge((`v',`v'), (1,`c'))
			
			b.set_text_wrap((`v',`v'), (1,`c'), "on")
			
			b.set_text_wrap((4,`w'), 1, "on")
			
			b.put_string(`r', 1, "Constant")
			
			b.put_string(`w', 1, "Observations")
			
			
			
			
		rows = (1,`w')
		
		cols = (1,`c')
				
		b.set_font_bold((2,2), cols, "on")
				
		b.set_font_bold((`w',`w'), cols, "on")
				
		b.set_text_wrap((2,2), cols, "on")
					
		b.set_font((1,`v'), cols, "Times new roman", 9)
		
		b.set_vertical_align(rows, cols, "center")
		
		b.set_top_border((2,2), cols, "medium")
		
		b.set_bottom_border((3,3), cols, "thin")
		
		cols = (2,`c')
		
		b.set_horizontal_align((4,`w'), cols, "center")
		
		b.set_horizontal_align((2,3), cols, "center")
		
		rows = (`w',`w')
		
		cols = (1,`c')
		
		b.set_bottom_border(rows, cols, "medium")
		
		
		b.set_column_width(1,1,40) 
	
		b.set_column_width(2,`c',15) 
	
		b.set_row_height(`v',`v',50)
		
		
		
		
		for (i=4; i<`r'; i=i+3) {
			
				la_loc = "la" + strofreal(i) + "_1"
				
				la_name = st_local(la_loc)
								
				b.put_string(i, 1, la_name)
							
		}
		
		
		
		i = `w'
		
		do {
				
			for (j=2; j<=`c'; j=j+1) {
				
				
				lb_loc = "lb2_" + strofreal(j)
				
				lb_name = st_local(lb_loc)
				
				b.put_string(2, j, lb_name)
				
				nt_toploc = "top_3_" + strofreal(j)
				
				nt_topnum = st_local(nt_toploc)
				
				b.put_string(3, j, nt_topnum)
				
				nb_botloc = "n26_" + strofreal(j)
				
				nb_botnum = st_local(nb_botloc)
				
				b.put_string(i, j, nb_botnum)
				
				
				
				}
			
		} while (i<`w')
		
		
		
			
			for (i=4; i<=`w'; i=i+3) {
				
				for (j=2; j<=`c'; j=j+1) {
				
				b_loc = "b" + strofreal(i) + "_" + strofreal(j) 
				
				b_num = st_local(b_loc)
								
				b.put_string(i, j, b_num)
				
				
			}	
			
			}
				
				
			for (i=5; i<=`w'; i=i+3) {
				
				for (j=2; j<=`c'; j=j+1) {
							
				se_loc = "se" + strofreal(i) + "_" + strofreal(j)
				
				se_num = st_local(se_loc)
								
				b.put_string(i, j, se_num)
				
				}
			}	
			
	
	
		
		b.close_book()
		
		`e'	
			
	
	
	}
	
	}
	
	
	