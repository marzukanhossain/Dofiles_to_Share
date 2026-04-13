/*******************************************************************************************
*Title: 20250826_IPV_Analysis
*Created by: Marzuk
*Created on: AUG 26, 2025
*Last Modified on:  AUG 26, 2025
*Last Modified by: 	Marzuk
*Purpose :  Analysis of IPV Data 
	
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
	
	global data_er_main		"$data_endline\02_Raw\20241201_Main_Survey"
		
	global data_e_analysis  			"$data_endline\04_Analysis"
	
	global data_e_clean		"$data_endline\03_Clean"
	
	global results_endline			"$proj_dir\06_Results\03_Endline"
	
	global data_baseline		"$data_dir\01_Baseline\TUP 2007 data"
	
	global data_b_household		"$data_baseline\Household module\Stata label data"
	
	global do_file			"$proj_dir\04_Code\01_Baseline\01_Sample"
	*/		
	
	global data_b_clean		"$data_dir\01_Baseline\03_Clean"
	
	global pilot "$proj_dir\04_Code\05_Pilot"
	
	global data_2018 "$proj_dir\03_Data\Fifth round survey of TUP (Phase-II)_2018_correction_from_LSE\Household\Stata data" 
	
	
	global mrdata_dfm		"$base_dir\RA_IUPG_Main_survey_2024\long"
	
	global trdata_dfm		"$base_dir\RA_IUPG_traced_survey_2024"
	
	
	
	
 
	
	//# Balance Table Data prep
	
			
	use "$data_dir\03_Endline\03_Clean\Main_Survey_Clean_npii\20250616_Pre_Panel_Data", clear


	keep idno child_lino_* wife_lino_* ext_gen_*  resp_24same07 resps_relation2024
	
	reshape long child_lino_ wife_lino_ ext_gen_, i(idno) j(tracee_lino)
	
	keep idno tracee_lino child_lino_ wife_lino_ ext_gen_ resp_24same07 resps_relation2024
	
	split child_lino_, gen(c_lino) destring
	
	split wife_lino_, gen(w_lino) destring
	
	label values tracee_lino
	
	keep if w_lino1!=.
	
	*keep if ext_gen_=="2"
	
	ren w_lino1 lino
	
	keep idno lino tracee_lino
		
	merge m:1 idno lino using "$data_e_raw\20241201_Main_Survey\Long\s1_Roster.dta"
	
	keep if _merge==3
	
	drop _merge
	
	gen lives_with_spouse = hhmc1_p3==1 | hhmc1_p3==3 | hhmc1_p3==9 | hhmc1_p3==10 
	
	ren lino splino
	
	ren tracee_lino lino
	
	keep idno lino lives_with_spouse
	
	tempfile spouse_cohabits
	
	save `spouse_cohabits'
	
	/*
	use "$data_endline\05_Others\G2LMLIC_Data_Submission\20251130_Clean_Traced_Resp_Data.dta", clear
	
	sort idno lino
	
	count if lino!=.
	
	gen lives_with_spouse = .
	
	
	
	local a = 1
	
	local c = `r(N)'/7
	
	local b = `c'
	
	foreach z of numlist 1/7 {
	
		foreach x of numlist `a'/`b' {
			
			local trl = lino[`x']
			
			local spl = substr(hhmem_wifelinos_traced_`trl'[`x'], 1, 1)
			
			if `spl'!= . {
				
				replace lives_with_spouse = hhmem_currentstatus_`spl'[`x'] in `x'
			
			}
		
		}
		
		local a = `a' + `c'
		
		local b = `b' + `c'
	
	}
	
	recode lives_with_spouse (1 3 9 10 = 1) (2 4/8 11 12 = 0)
	
	keep idno lino lives_with_spouse been_married_years
	
	tempfile haaahaha
	
	save `haaahaha'
	
	*/
	
	
	
	use "$data_e_clean\20250217_IUPG_traced_survey_clean_hh", clear
	
	preserve 
	
	keep if tracee_own_hh==1
	
	keep idno lino remittance_received_tr - hhmem_num
	
	tempfile trhh
	
	save `trhh'
	
	restore
	
	keep if tracee_own_hh==0
	
	keep idno lino remittance_received_tr - hhmem_num
	
	tempfile orhh
	
	save `orhh'
	
	
	
	use "$data_e_raw\20241201_Traced_Res_Survey\long\s1_Roster", clear
	
	keep if hhmc4_tr==2
	
	destring idno lino, replace
	
	split id_lino, parse(_) gen(tr_lino)
	
	ren lino w_lino_trhh
	
	ren tr_lino2 lino
	
	destring lino, replace
	
	keep idno lino w_lino_trhh hhmc1_p1_tr - hhmc7_tr
	
	foreach x of varlist hhmc1_p1_tr - hhmc7_tr {
		
		ren `x' `x'w
		
	}
	
	drop if idno==2877 & w_lino_trhh==3 & lino==6 // Becasue the wife with lino 3 is now divorced. 
	
	
		
	tempfile chacha
	
	save `chacha'
	
	
	
				
	use "$data_dir\03_Endline\03_Clean\Main_Survey_Clean_npii\20250616_Pre_Panel_Data", clear







	keep idno child_lino_* wife_lino_* ext_gen_*  resp_24same07 resps_relation2024
	
	reshape long child_lino_ wife_lino_ ext_gen_, i(idno) j(tracee_lino)
	
	
	keep idno tracee_lino child_lino_ wife_lino_ ext_gen_ resp_24same07 resps_relation2024
	
	split child_lino_, gen(c_lino) destring
	
	split wife_lino_, gen(w_lino) destring
	
	keep if w_lino1!=.
	
	reshape long w_lino, i(idno tracee_lino) j(w_slno)
		
	keep if w_lino!=.
	
	ren w_lino lino
	
	drop if idno==9864 & tracee_lino==4 & lino==6 // Because tracee in lino 4 is a female and her husband is not actually a member of this household. 
	
	drop if idno==13279 & tracee_lino==3 & lino==5 // Because tracee in lino 3 has moved into his own hh with his own wife this is the brother's wife.
	
	drop if idno==16615 & tracee_lino==3 & lino==5 // Because tracee in lino 3 is a female who has moved into her own hh.
	
	drop if idno==24002 & tracee_lino==3 & lino==7 // Because tracee in lino 3 is a female who has moved into her own hh.
	
	drop if idno==25511 & tracee_lino==4 & lino==5 // Because tracee in lino 4 is a male who is still unmarried.
	
	drop if idno==26995 & (tracee_lino==4 | tracee_lino==5) & lino==6 // Because they have all moved into their own hh.
	
	merge 1:1 idno lino using "$data_e_raw\20241201_Main_Survey\Long\s1_Roster.dta"
	
	keep if _merge==3
	
	keep idno tracee_lino w_slno lino hhmc1_p1- hhmc7
	
	ren lino w_lino_mainhh
	
	ren tracee_lino lino
	
	foreach x of varlist hhmc1_p1- hhmc7 {
		
		ren `x' `x'_w
		
	}
	
	duplicates tag idno lino, gen(dup)
	
	sort idno lino dup hhmc2y 
	
	bys idno lino dup: gen polywife_n = _n
	
	keep if polywife_n==1
	
	drop if dup==2
	
	*drop if dup>0
	
	drop dup polywife_n
	
	merge 1:1 idno lino using "$data_e_clean\20241214_IUPG_traced_survey_clean"
		
	drop if _merge==1
	
	drop _merge
	
	order w_slno - hhmc7_w, after(hhmc7) 
	
	
	label values lino 
	
	merge 1:1 idno lino using `chacha'
	
	drop _merge
	
	order w_lino_trhh - hhmc7_trw, after(hhmc7_w)
	
	
	preserve 
	
	keep idno lino tracee_own_hh
	
	keep if tracee_own_hh==1
	
	merge 1:1 idno lino using `trhh'
	
	tempfile trhhinfo
	
	save `trhhinfo'
	
	restore
	
	preserve
	
	keep idno lino tracee_own_hh
	
	keep if tracee_own_hh==0
	
	merge m:1 idno using `orhh'
	
	append using `trhhinfo'
	
	drop _merge
	
	tempfile hhinfo
	
	save `hhinfo'
	
	restore
	
	merge 1:1 idno lino using `hhinfo'
	
	drop _merge
	
	merge 1:1 idno lino using `spouse_cohabits'
	
	drop _merge
 
	
	*use "$data_e_clean\20241214_IUPG_traced_survey_clean", clear
	

	
**# rand_valtr & rand_valtr1: variables with random values	
	
// rand_valtr and rand_valtr1 randomly takes the following values:

		// 1 = hybrid (questions read out by the enumerators to the respondents, but they responded on the tab on their own without revealing their answers) and options appear as "Yes" and "No"
		
		// 2 = hybrid and the options appear as a green tick for "Yes" and red cross for "No".
		
		// 3 = ACASI and yes/no options
		
		// 4 = ACASI and symbols as options (according to the SurveyCTO form)
		
	// rand_valtr1 is the variable used when the household survey was conducted with the wives of the tracees and the variable rand_valtr was used when the tracees themselves were the respondents (according to the SurveyCTO form).	
	

	

**# pr_rand & pr_rand1: variables with random values	
	
// pr_rand and pr_rand1 randomly takes any values in the range [0,1) (according to the SurveyCTO form and the explanation of the function used in the calculations field)

		// Values of pr_rand & pr_rand1 in the range [0,0.9] => Privacy statement had been reiterated, not reiterated otherwise (according to the SurveyCTO form).  
		
	// pr_rand1 is the variable used when the household survey was conducted with the wives of the tracees and the variable pr_rand was used when the tracees themselves were the respondents (according to the SurveyCTO form).	

	
	
	
**# rand_val: variable with random values

// rand_val randomly takes the following values:

		// 1 = prompted IPV with attitude questions first
		
		// 2 = attitude questions come after the IPV questions (according to the SurveyCTO form)
	
	
	
// Own reminder - int function floors a number to the lower integer round function takes it to the closest integer, works for both STATA and SurveyCTO.	
	
	
/*
        *
      /-/
     /-/
  . /-/ 
 /|\   
 / \
 
 */

	
	
	
**# Treatment variables generation
 
 
	egen treat_hybrid_acasi = anymatch (rand_valtr rand_valtr1), values(3 4)
	
	replace treat_hybrid_acasi = . if rand_valtr==. & rand_valtr1==.
	
	lab var treat_hybrid_acasi "Treatment A: 1 = ACASI used for IPV 0 = question read out, but response furtive"
	
	egen treat_word_sym = anymatch (rand_valtr rand_valtr1), values(2 4)
		
	replace treat_word_sym = . if rand_valtr==. & rand_valtr1==.
	
	lab var treat_word_sym "Treatment O: 1 = symbols used as y/n options 0 = yes/no used as y/n options"
		
	gen treat_privacy_reiterated = 0
	
	replace treat_privacy_reiterated = 1 if pr_rand<=0.9 | pr_rand1<=0.9
		
	replace treat_privacy_reiterated = . if rand_valtr==. & rand_valtr1==.
	
	lab var treat_privacy_reiterated "1 = privacy statement reiterated, 0 otherwise."
	
	
	
	gen treat_order_prompt = rand_val == 1
	
	replace treat_order_prompt = . if rand_val==.
	
	lab var treat_order_prompt "Treatment P: 1 = attitude prompted before IPV, 0 = IPV before attitude"
	
	
	gen treat_order_reverse = rand_val == 2
	
	replace treat_order_reverse = . if rand_val==.
	
	lab var treat_order_reverse "Treatment R: 1 = IPV prompted before attitude, 0 = attitude before IPV"
	
	
	// Treatment variables for the 4 arms
	
	gen treat_pa = treat_hybrid_acasi==1 & treat_order_prompt==1 if consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	lab var treat_pa "Prompted and ACASI"
	
	gen treat_ph = treat_hybrid_acasi==0 & treat_order_prompt==1 if consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	lab var treat_ph "Prompted and Hybrid"
	
	gen treat_ra = treat_hybrid_acasi==1 & treat_order_reverse==1 if consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1

	lab var treat_ra "Prompt reversed and ACASI"
		
	gen treat_rh = treat_hybrid_acasi==0 & treat_order_reverse==1 if consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1

	lab var treat_rh "Prompt reversed and Hybrid"
	
			
	gen treat_hybrid = treat_hybrid_acasi==0 if consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	lab var treat_hybrid "Hybrid"
	
	
	gen treat_arms = 1 if treat_pa==1 & consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	replace treat_arms = 2 if treat_ph==1 & consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	replace treat_arms = 3 if treat_ra==1 & consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	replace treat_arms = 4 if treat_rh==1 & consent==1 & just_wife_survey!=. & treat_privacy_reiterated==1
	
	lab define treatarms 1 "Prompted and ACASI" 2 "Prompted and Hybrid" 3 "Prompt reversed and ACASI" 4 "Prompt reversed and Hybrid"
	
	lab values treat_arms treatarms
	
	
	
	
**# Generating treatment interactions

	gen treat_acasi_sym = treat_hybrid_acasi * treat_word_sym
	
	lab var treat_acasi_sym "Treatment (A * O)"
	
	gen treat_acasi_prompt = treat_hybrid_acasi * treat_order_prompt
	
	lab var treat_acasi_prompt "Treatment (A * P)"
	
	gen treat_acasi_reverse = treat_hybrid_acasi * treat_order_reverse
	
	lab var treat_acasi_reverse "Treatment (A * R)"
	
	gen treat_sym_prompt = treat_word_sym * treat_order_prompt
	
	lab var treat_sym_prompt "Treatment (O * P)"
	
	gen treat_sym_reverse = treat_word_sym * treat_order_reverse
	
	lab var treat_sym_reverse "Treatment (O * R)"
	
	gen treat_acasi_sym_prompt = treat_hybrid_acasi * treat_word_sym * treat_order_prompt
	
	lab var treat_acasi_sym_prompt "Treatment (A * O * P)"
	
	gen treat_acasi_sym_reverse = treat_hybrid_acasi * treat_word_sym * treat_order_reverse
	
	lab var treat_acasi_sym_reverse "Treatment (A * O * R)"
	
	
	
	
	
	
	
	
	
	
	
**# Overstatement variable creation	
	
	gen overstatement = 1 if (cal_hipvt0_3_tr==1 | cal_hipvt0_3a_tr==1 | cal_hipvt0_3b_tr==1 | cal_hipvt0_3c_tr==1) & hhmc6<8
	
	replace overstatement = 0 if overstatement==. & (rand_valtr!=. | rand_valtr1!=.)
	
	
	bys sex: tab treat_word_sym if consent==1 & just_wife!=1 & treat_privacy_reiterated==1
	
	
	
	
	
	
**# IPV reporting variable creation
	
	
	local t "ever lastyr"
	
	local ipv "slap push kick batonbash"

	local a = 0
	
	foreach y of local t {
		
		local a = `a' + 1
		
		local b = 0
		
		foreach x of local ipv {
			
			local b = `b' + 1
			
			egen hvaw`a'_`y'_`x' = anymatch(cal_hvaw`b'`a'_tr cal_hvaw`b'`a'a_tr cal_hvaw`b'`a'b_tr cal_hvaw`b'`a'c_tr cal_hvaw`b'`a'_p2tr cal_hvaw`b'`a'a_p2tr cal_hvaw`b'`a'b_p2tr cal_hvaw`b'`a'c_p2tr), values (1)
	
			replace hvaw`a'_`y'_`x' = . if hvaw`a'_`y'_`x'!=1
	
			replace hvaw`a'_`y'_`x' = 0 if (cal_hvaw`b'`a'_tr==0 | cal_hvaw`b'`a'a_tr==0 | cal_hvaw`b'`a'b_tr==0 | cal_hvaw`b'`a'c_tr==0 | cal_hvaw`b'`a'_p2tr==0 | cal_hvaw`b'`a'a_p2tr==0 | cal_hvaw`b'`a'b_p2tr==0 | cal_hvaw`b'`a'c_p2tr==0) & cal_hvaw`b'`a'_tr!=1 & cal_hvaw`b'`a'a_tr!=1 & cal_hvaw`b'`a'b_tr!=1 & cal_hvaw`b'`a'c_tr!=1 & cal_hvaw`b'`a'_p2tr!=1 & cal_hvaw`b'`a'a_p2tr!=1 & cal_hvaw`b'`a'b_p2tr!=1 & cal_hvaw`b'`a'c_p2tr!=1
			
			lab var hvaw`a'_`y'_`x' "Husband `y' `x'"
			
			
			
			egen hvaw`a'_`y'_`x'_dk = anymatch(cal_hvaw`b'`a'_tr cal_hvaw`b'`a'a_tr cal_hvaw`b'`a'b_tr cal_hvaw`b'`a'c_tr cal_hvaw`b'`a'_p2tr cal_hvaw`b'`a'a_p2tr cal_hvaw`b'`a'b_p2tr cal_hvaw`b'`a'c_p2tr), values (-999)
			
			replace hvaw`a'_`y'_`x'_dk = . if hvaw`a'_`y'_`x'_dk!=1
			
			if `a'==2 {
				
				replace hvaw1_ever_`x' = 1 if hvaw`a'_`y'_`x'==1 & hvaw1_ever_`x'==0 // We use this to change the errors (the error being: last year 1 but ever 0) to 1 for the ever variables. This is because we assume that it is rather plausible that it takes 2 tries for the respondents to fully understand the question and answer accordingly.  
				
				*replace hvaw1_ever_`x' = 1 if hvaw`a'_`y'_`x'==1 & hvaw1_ever_`x'==.
				
				*replace hvaw1_ever_`x' = 0 if hvaw`a'_`y'_`x'==0 & hvaw1_ever_`x'==. // We are not doing the last 2 because in these cases there is no error, they themselves decided not to share, so we are not including them.
				
			}
 	
		}
		
	}
	
		
	gen hvaw_ever_ipv = 0 if hvaw1_ever_slap==0 | hvaw1_ever_push==0 | hvaw1_ever_kick==0 | hvaw1_ever_batonbash==0
	
	replace hvaw_ever_ipv = 1 if hvaw1_ever_slap==1 | hvaw1_ever_push==1 | hvaw1_ever_kick==1 | hvaw1_ever_batonbash==1 
	
	lab var hvaw_ever_ipv "Ever any IPV experienced"
	
	gen hvaw_lastyr_ipv = 0 if hvaw2_lastyr_slap==0 | hvaw2_lastyr_push==0 |  hvaw2_lastyr_kick==0 | hvaw2_lastyr_batonbash==0 
	
	replace hvaw_lastyr_ipv = 1 if hvaw2_lastyr_slap==1 | hvaw2_lastyr_push==1 |  hvaw2_lastyr_kick==1 | hvaw2_lastyr_batonbash==1
	
	lab var hvaw_lastyr_ipv "Last year any IPV experienced"
		
	replace hvaw_ever_ipv = 1 if hvaw_lastyr_ipv==1 & hvaw_ever_ipv==0 // We use this to change the errors (the error being: last year 1 but ever 0) to 1 for the ever variables. This is because we assume that it is rather plausible that it takes 2 tries for the respondents to fully understand the question and answer accordingly.
	
	*replace hvaw_ever_ipv = 1 if hvaw_lastyr_ipv==1 & hvaw_ever_ipv==.
	
	*replace hvaw_ever_ipv = 0 if hvaw_lastyr_ipv==0 & hvaw_ever_ipv==. // We are not doing the last 2 because in these cases there is no error, they themselves decided not to share, so we are not including them. 
	
	encode pull_district, gen(pull_dist_code)
	
	
	
	
**# IPV attitude variables creation

		
	local ipv ""goes_out" "neglects_child" "argues" "refuses_intimacy" "burns_food" "use_condom_cause_STD" "refuses_intimacy_cause_ext" "refuse_intimacy_cause_uwant" "use_condom_cause_uwant""
	
	local a = 5
	
	foreach x of local ipv {
		
		local a = `a' + 1
		
		gen hdhs_`x' = 0 if cal_hdhs`a'b_tr==0 | cal_hdhs`a'c_tr==0 | cal_hdhs`a'b_p2tr==0 | cal_hdhs`a'c_p2tr==0
		
		replace hdhs_`x' = 1 if cal_hdhs`a'b_tr==1 | cal_hdhs`a'c_tr==1 | cal_hdhs`a'b_p2tr==1 | cal_hdhs`a'c_p2tr==1
		
		if `a'==11 {
			
			lab var hdhs_`x' "Wife can ask husband to `x' of husband known"
						
		}
		
		else if `a'==12 {
			
			lab var hdhs_`x' "Wife can `x'ramarital intimacy of husband known"
			
		}
				
		else if `a'==13 {
			
			lab var hdhs_`x' "You can `x'"
			
		}
		
		else if `a'==14 {
			
			lab var hdhs_`x' "You can ask husband to `x'"
			
		}
		
		else {
			
			lab var hdhs_`x' "Husband can beat wife if wife `x'"
			
		}
		
		
				
	}
	
	
	gen hdhs_gen_ipv = 0 if hdhs_goes_out==0 | hdhs_neglects_child==0 | hdhs_argues==0 | hdhs_refuses_intimacy==0 | hdhs_burns_food==0 
	
	replace hdhs_gen_ipv = 1 if hdhs_goes_out==1 | hdhs_neglects_child==1 | hdhs_argues==1 | hdhs_refuses_intimacy==1 | hdhs_burns_food==1
	
	lab var hdhs_gen_ipv "General IPV attitude"
	
	factor hdhs_goes_out hdhs_neglects_child hdhs_argues hdhs_refuses_intimacy hdhs_burns_food, pcf
	
	predict hdhs_gen_ipv_pc hdhs_gen_ipv_pcf
	
	lab var hdhs_gen_ipv_pc "General IPV attitude PCF"
	
	
	
	
	
	
	
	
	gen hdhs_per_ipv = 0 if hdhs_refuse_intimacy_cause_uwant==0 | hdhs_use_condom_cause_uwant==0
	
	replace hdhs_per_ipv = 1 if hdhs_refuse_intimacy_cause_uwant==0 | hdhs_use_condom_cause_uwant==0
	
	lab var hdhs_per_ipv "Personal IPV attitude"
	
	factor hdhs_refuse_intimacy_cause_uwant hdhs_use_condom_cause_uwant, pcf
	
	predict hdhs_per_ipv_pcf
	
	lab var hdhs_per_ipv_pcf "Personal IPV attitude PCF"

	
	
	*tab2xl
	
**# IPV Mismatch 	
	
	local ipv "slap push kick batonbash"
	
	cd "$results_endline\Excel"
	
	local a = 2
	
	local b = 15
	
	foreach x of local ipv {
		
		gen mismatch_`x' = hvaw1_ever_`x'==0 & hvaw2_lastyr_`x'==1
		
		*tab2xl hvaw2_lastyr_`x' hvaw1_ever_`x' if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 using IPV_mismatch, perc row(`a') col(2) 
		
		*tab2xl hvaw2_lastyr_`x' hvaw1_ever_`x' if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_hybrid_acasi==1 using IPV_mismatch, perc row(`b') col(2)
		
		*reg mismatch_`x' treat_hybrid_acasi if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		*reg mismatch_`x' treat_order_prompt if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		local a = `a' + 30
		
		local b = `b' + 30
		
	}
	
	
	gen mismatch_ipv = hvaw_ever_ipv==0 & hvaw_lastyr_ipv==1
	
	
	
	//# IPV Balance test variables
	
	// Reading and writing
	
	gen can_read_ipv = (hhmne22_tr==1 & sex==0) | (hhmne22_tr==2 & sex==0) | (hhmne13_tr==1 & sex==1) | (hhmne13_tr==2 & sex==1) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 
	
	lab var can_read_ipv "Can read (=1)"
		
	gen read_write_ipv = 1 if (hhmne13_tr==1 | hhmne13_tr==2) &	treat_hybrid_acasi!=. & sex==1 & consent==1 & just_wife!=1 & treat_privacy_reiterated==1
		
	replace read_write_ipv = 1 if (hhmne22_tr==1 | hhmne22_tr==2) & treat_hybrid_acasi!=. & sex==0 & consent==1 & just_wife!=1 & treat_privacy_reiterated==1	
	
	replace read_write_ipv = 0 if read_write_ipv!=1 & treat_hybrid_acasi!=. & consent==1 & just_wife!=1 & treat_privacy_reiterated==1
	
	
	
	// Years of education
	
	recode hhmc6_w hhmc6_trw (55=0) (13=5) // Hafez or memorising the whole quran is considered to be 5 years of schooling.
	
	
	clonevar yrs_education_ipv = hhmc6 if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
	
	replace yrs_education_ipv = hhmc6_w if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1 
	
	replace yrs_education_ipv = hhmc6_trw if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1 
	
	lab var yrs_education_ipv "Years of education"
	
	
	// Occupation - IGA
	
	egen iga_involved = anymatch(hhmc7) if consent==1 & just_wife_survey!=1, values(2/27 29 32/46 555) 
	
	egen iga_involved_w = anymatch(hhmc7_w) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1, values(2/27 29 32/46 555)
	
	egen iga_involved_trw = anymatch(hhmc7_trw) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1, values(2/27 29 32/46 555) 
	
	gen iga_involved_ipv = iga_involved if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
	
	replace iga_involved_ipv = iga_involved_w if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1
	
	replace iga_involved_ipv = iga_involved_trw if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1
	
	lab var iga_involved_ipv "Involved in IGA (=1)"
	
	replace iga_involved_ipv = . if consent!=1 | just_wife_survey==1 | treat_privacy_reiterated!=1
	
	
	//Occupation - Animal Rearing
	
	egen animal_rearing_ipv = anymatch(hhmc7) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, values(6 7 34) 
	
	egen animal_rearing_ipv_w = anymatch(hhmc7_w) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1, values(6 7 34)
	
	egen animal_rearing_ipv_trw = anymatch(hhmc7_trw) if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1, values(6 7 34)
	
	replace animal_rearing_ipv = animal_rearing_ipv_w if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1
	
	replace animal_rearing_ipv = animal_rearing_ipv_trw if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1
	
	lab var animal_rearing_ipv "Animal/poultry rearing (=1)"
	
	replace animal_rearing_ipv = . if consent!=1 | just_wife_survey==1 | treat_privacy_reiterated!=1
	
		
	
	//Occupation - Day Labour
	
	gen daylabour_ipv = hhmc7==3 | hhmc7==4 if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
	
	replace daylabour_ipv = 1 if (hhmc7_w==3 | hhmc7_w==4) & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1
	
	replace daylabour_ipv = 1 if (hhmc7_trw==3 | hhmc7_trw==4) & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1
	
	lab var daylabour_ipv "Day labour (=1)"
	
	
	
	// Age
	
	replace hhmc2y_w = hhmc2y_w + 1 if hhmc2m_w>=6 & hhmc2m_w<.
		
	replace hhmc2y = hhmc2y + 1 if hhmc2m>=6 & hhmc2m<.
	
	replace hhmc2y_trw = hhmc2y_trw + 1 if hhmc2m_trw>=6 & hhmc2m_trw<.
		
	gen ipvf_age = hhmc2y if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
	
	replace ipvf_age = hhmc2y_w if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & hh_mem_2007==1
	
	replace ipvf_age = hhmc2y_trw if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & sex==1 & tracee_own_hh==1
	
	lab var ipvf_age "Age (years)"
	
	
	// No. of children
	
	gen num_children_ipv = hced5a_tr
	
	lab var num_children_ipv "Number of children"
	
	
	
	// Lives with Spouse
	
	replace lives_with_spouse = 1 if (hhmc1_p3==1 | hhmc1_p3==3 | hhmc1_p3==9 | hhmc1_p3==10) & (rel_stat_tr==3 | rel_stat_tr==5 | rel_stat_tr==6)
	
	
	
	
	// Household level characteristics
	
	
	local v1 "remittance_received hh_income yr_cons hh_saving land_value livestock_value other_asset_value"
	
	foreach x of local v1 {
			
		replace `x' = 0 if `x'==.
		
		replace `x' = `x'/1000
	
	}
	
	
	gen hh_income_pcap = hh_income/hhmem_num
	
	gen yr_cons_pcap = yr_cons/hhmem_num
	
	
	
	lab var remittance_received "Remittance received" 
	
	lab var hh_income_pcap "Yearly per capita income"
	
	lab var yr_cons_pcap "Yearly per capita consumption"
	
	lab var hh_saving "Savings"
	
	lab var land_value "Land value"
	
	lab var livestock_value "Livestock value"
	
	lab var other_asset_value "Other asset value"
	
	
	
	
	// Migration of husband needs to be added look at old do-files
	
	// For household level characteristics; merge with tracee household data using idno m:1 m for this data and 1 for tracee 
	
	
	
	
	
	
	
	//# Regressions
	
	sum hvaw_ever_ipv if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_arms==4
	
	sum hvaw_lastyr_ipv if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_arms==4
	
	sum hdhs_gen_ipv_pc if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_arms==4
	
	
		reg mismatch_ipv treat_hybrid_acasi if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		reg mismatch_ipv treat_order_prompt if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		reghdfe mismatch_ipv treat_hybrid_acasi treat_order_prompt treat_acasi_prompt if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code) vce(robust)
		
		
		
	gen read_write = 1 if (hhmne13_tr==1 | hhmne13_tr==2) &	treat_hybrid_acasi!=. & sex==1 & consent==1 & just_wife!=1 & treat_privacy_reiterated==1
		
	replace read_write = 1 if (hhmne22_tr==1 | hhmne22_tr==2) & treat_hybrid_acasi!=. & sex==0 & consent==1 & just_wife!=1 & treat_privacy_reiterated==1	
	
	replace read_write = 0 if read_write!=1 & treat_hybrid_acasi!=. & consent==1 & just_wife!=1 & treat_privacy_reiterated==1
		
			
	save "$data_e_analysis\20250912_IPV_Analysis", replace 
	/*
	preserve 
	
	keep if treat_hybrid_acasi!=. sex==0 consent==1 & just_wife!=1 & treat_privacy_reiterated==1 
	
	restore
	
	*/
	
	