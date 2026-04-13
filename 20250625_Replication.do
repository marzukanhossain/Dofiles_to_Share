/******************************************************************************************************************
*Title: 20250625_Replication
*Created by: Marzuk
*Created on: May 11, 2023
*Last Modified on:  May 11, 2023
*Last Modified by: 	Marzuk
*Purpose :  Do-file for replication
	
*****************************************************************************************************************/
	clear all
	set more off
	capture log close
	set logtype text

	local date=c(current_date)
	local time=c(current_time)
	
	**Appropriate directory based on user
	
	if "`c(username)'"=="KWR"  {
	
			global base_dir "H:/.shortcut-targets-by-id/1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW" 
			
	}
	else if "`c(username)'"=="marzu" {
	
			global base_dir "G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW"
			
	}
	else if "`c(username)'"=="User" {
	
			global base_dir "G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW"
			
	}
			
	global proj_dir 	"$base_dir\1.3.3 World Fish"
	
	global data_dir   		"$proj_dir\04_Data"
	
	global listing_data  "$data_dir\01_TRK_Initial_Listing_Survey"
	
	global Phone_Survey_data 	"$data_dir\03_Phone_Survey"

	global In_Person_Survey		"$data_dir\04_In_Person_Survey"
	
	global Phone_Survey_sample	"$Phone_Survey_data\01_Selected-Sample"
	
	global Phone_Survey_raw		"$Phone_Survey_data\02_Raw_Data"
	
	global Phone_Survey_clean		"$Phone_Survey_data\03_Cleaned_Data"
	
	global Phone_Survey_A_D	"$Phone_Survey_data\04_Analysis_Data"
	
	global In_Person_sample	"$In_Person_Survey\01_Selected_Sample"
	
	global In_Person_raw		"$In_Person_Survey\02_Raw_Data"
	
	global In_Person_clean		"$In_Person_Survey\03_Cleaned_Data"
	
	global In_Person_A_D		"$In_Person_Survey\04_Analysis_Data"
	 
	global do_dir  			"$proj_dir\05_Code"
	
	
	
	do "$do_dir\03_Phone_Survey\01_Sample\20220810_Phone-Survey_Sample.do"
	
	
	do "$do_dir\03_Phone_Survey\02_Cleaning\20221120_Phone-Survey_Sample_Data_Cleaning.do"
	
	
	do "$do_dir\03_Phone_Survey\03_Analysis\20221107_Phone-Survey_Sample_Primary_Analysis.do"
	
	
	do "$do_dir\04_In_Person_Survey\02_Cleaning\20230505_In_Person_Data_Cleaning.do"
	
	
	do "$do_dir\04_In_Person_Survey\03_Analysis\20230511_In_Person_Survey_Primary_Analysis.do"
		
	do "$do_dir\04_In_Person_Survey\03_Analysis\20230511_Balance_Tests.do"
	
	
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_references.do"
	
	texdoc do "$do_dir\04_In_Person_Survey\03_Analysis\latex_manuscript.do"
	