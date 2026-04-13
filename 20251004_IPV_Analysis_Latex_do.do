/************************************************************************************
*Title: 20251004_IPV_Analysis_Latex_do
*Created by: Marzuk
*Created on: Oct 04, 2025
*Last Modified on:  Oct 04, 2025
*Last Modified by: 	Marzuk
*Purpose :  To run all the IPV analysis LaTeX do-files 
	
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
	
	global results_end_fig	"$proj_dir\06_Results\03_Endline\Figures"
	
	global results_end_tab	"$proj_dir\06_Results\03_Endline\Tables"
	
	global results_end_excel	"$proj_dir\06_Results\03_Endline\Excel"
	
	
	
	
	
	
	texdoc do "$do_file_e_analysis\IPV\20251004_IPV_Analysis_Study_Design_Latex"
	
	texdoc do "$do_file_e_analysis\IPV\20251006_IPV_Analysis_Tables_latex"
	
