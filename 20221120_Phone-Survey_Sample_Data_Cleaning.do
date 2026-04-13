/******************************************************************************************************************
*Title: 20221120_Phone-Survey_Sample_Data_Cleaning
*Created by: Marzuk
*Created on: November 7, 2022
*Last Modified on:  November 7, 2022
*Last Modified by: 	Marzuk
*Purpose :  Cleaning Phone survey sample and checking treatment mismatch
	
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
			
	global proj_dir 	"$base_dir\1.3.3 World Fish"
	
	global data_dir   		"$proj_dir\04_Data"
	
	global listing_data  "$data_dir\01_TRK_Initial_Listing_Survey"
	
	global Phone_Survey_data 	"$data_dir\03_Phone_Survey"

	global In_Person_Survey		"$data_dir\04_In_Person_Survey"
	
	global Phone_Survey_sample	"$Phone_Survey_data\01_Selected-Sample"
	
	global Phone_Survey_raw		"$Phone_Survey_data\02_Raw_Data"
	
	global Phone_Survey_clean		"$Phone_Survey_data\03_Cleaned_Data"
	
	global do_dir  			"$proj_dir\05_Code"
			
			
			
	use "$Phone_Survey_raw\20221116_Aquaculture evaluation_Nov2022_clean", clear
	
	/*"G:\.shortcut-targets-by-id\1dKVO6M-LkDHFKiqTfM34w1ETnY_ZShrW\1.3.3 World Fish\04_Data\03_Phone_Survey\Aquaculture_training_evaluation_2022_checked.dta" 
*/

	***Figuring out the difference in treatment and control 
	
	encode treatment, gen(treatold)
	
	recode treatold (1=0 "No") (2=1 "Yes"), gen(treat_old) lab(treatold)
	
	drop treatold
	
	clonevar treat_pq5 = pq5
	
	label variable treat_pq5 "pq5. Did you receive the training?"
	
	label define treat_pq5 0 "No" 1 "Yes"

	label values treat_pq5 treat_pq5
	
	tab treat_pq5 treat_old
	
	
	tab2xl treat_pq5 treat_old using Anamoly1.xlsx, col(1) row(1) replace
	
	
	
	
	*****Preparing data for analysis
	
	encode upaz_name, gen(upazilla)
	
	replace union_name = "Zss Not found" if union_name == "Not found"
	
	encode union_name, gen (union_cd)
	
	replace union_cd = 99 if union_cd == 9
	
	label define union_cd 1 "Deluya bari" 2 "Kisomgankoair" 3 "Nowapara" 4 "Pananagar" 5 "Saluya" 6 "Sardaho" 7 "Yusufpur" 8 "Zaluka" 9 "Nimpara" 10 "Charghat" 11 "Bhayalakshmipur" 12 "Bajubagha" 13 "Gorgori" 14 "Pakuria" 15 "Monigram" 16 "Bausa" 17 "Orani" 18 "Chokrajapur" 19 "Mariya" 20 "Joynagar" 21 "Durgapur" 22 "Bagha" 23 "Poranpur" 24 "Talbaria" 555 "Others", replace
	*
	
	replace union_cd = union if union_cd == 99
	
	local un ""urg" "Bagha" "Poran" "Talbaria""
	
	local unc = 21
	
	foreach t of local un {
	
	replace union_cd = `unc' if strpos(union_ot, "`t'")
	
	local unc = `unc' + 1
	
	}
	
	replace union_cd = 8 if strpos(union_ot, "luka") | strpos(union_ot, "5no")
	
	replace union_cd = 15 if union_ot== "Monigori"
	
	*/
	
	local a = 16
		
	foreach x of numlist 18 19 {
	
		recode pq1 (`x'=`a')
		
		local a = `a'+1
	
	}
	
	recode pq1 (14=12)
	
	label define pq1 0 "No class passes" 1 "Class 01" 2 "Class 2" 3 "Class 3" 4 " Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" 10 "SSC/Dakhil" 12 "HSC/Alim" 15 "Diploma/Technological" 16 " BA/Degree /B.Com/Honours/BSc/Fazil" 17 "MA/MSc/ Masters/Kamil" 20 "PhD" 21 "Religious education / Hafez" 555 "Others", replace

	
	
	
	drop if consent != 1
	
	drop if pq2 == 0
	
	lab var pq4 "pq4.Smartphone owner's relationship with farmer"
	
	lab var pq23 "pq23.Is it necessary to cut down the aquatic weed from the pond's bottom?"
	
	lab var pq24a_6 "Using tea-seed cake or rotenone"
	
	lab var pq27 "pq27.Is there a recommended maximum number of fish fry based on pond size"
	
	keep idno key dist_name consent upazilla union_cd treat_old treat_pq5 gender_cd res_age pq* enum_comment   //res_name vill_name penu_name_pull gender_cd mobile_pull mobile_pull2 hh_name landmark //needed for in-person survey sample generation
	
	sort idno
	
	merge idno using "$Phone_Survey_sample\20220810_Phone-Survey_Sample_4_Merge"
	
	sort idno
	
	save "$Phone_Survey_clean\20221120_Aquaculture_Training_Evaluation_Cleaned_For_Analysis.dta", replace
	
	
	loneway q17_1 q4
	
	