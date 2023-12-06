/******************************************************************************************************************
*Title: Project_Folder
*Created by: Marzuk
*Created on: April 28, 2023
*Last Modified on:  April 28, 2023
*Last Modified by: 	Marzuk
*Purpose :  Project folder araangement
	
*****************************************************************************************************************/
	
	//*********** YOU NEED TO DO 2 THINGS: (details in green below)
	//**1) Set your own appropriate directory and username
	//**2) Write the name of your new project 
	
	clear all
	set more off
	capture log close
	set logtype text

	local date=c(current_date)
	local time=c(current_time)
	
	
	local mydate : display %tdCCYYNNDD date(c(current_date), "DMY")
	
	local mytime : display %tcCCYYNNDD-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMY hms")
	
	
	**Appropriate directory based on user
	
	if "`c(username)'"=="KWR"  {
	
			global base_dir "H:" 
			
	}	
	else if "`c(username)'"=="marzu" {
	
			global base_dir "C:\Users\marzu\OneDrive\BIGD\Work\01_BIGD_Projects"
			
	}
	else if "`c(username)'"=="User"{  
		
			global base_dir "C:" 
	}
	
	/// replace with your own directory and username
	
	// to check your own username on Stata run the command ***di c(username)**** and change the username above where it says "User"
	
	// to set your own directory please go to the folder you want to place these folder in and copy the directory from the address bar
	
	
	
	local p "G2LM" /// replace this with the name of your new project, the name will add an _ as a prefix. 
	
	
	mkdir $base_dir/`p'
	
	
	local f1 "Admin Intervention_Details"
	
	local f2 "Instruments Results Literature_Review Reports Others"
	
	local f3 "Baseline Midline Endline Others"
	
	local f4 "Proposal Agreements Budget IRB Others"
	
	local f5 "Sample Raw Clean Analysis Others"
	
	local f6 "Data Code"
	
	local a = 1
	
	local b = 5
	
	local c = 3
	
	foreach x of local f1 {
	    
		mkdir $base_dir/`p'\0`a'_`x'
		
		local a = `a' + 1
	}
	
	local a = 1
	
	foreach x of local f4 {
	    
		mkdir $base_dir/`p'\01_Admin\0`a'_`x'
		
		local a = `a' + 1
	}

	
	
	
	foreach x of local f6 {
	    
		mkdir $base_dir/`p'\0`c'_`x'
		
		local a = 1
		
		foreach y of local f3 {
			
			mkdir $base_dir/`p'\0`c'_`x'\0`a'_`y'
			
			local d = 1
			
			foreach z of local f5{
				
				mkdir $base_dir/`p'\0`c'_`x'\0`a'_`y'\0`d'_`z'
				
				local d = `d' + 1
				
			}
			
			local a = `a' + 1
			
		}
		
		local c = `c' + 1
		
	}
		
	
		
	foreach x of local f2 {
	    
		mkdir $base_dir/`p'\0`b'_`x'
		
		local a = 1
		
		foreach y of local f3 {
		    
			mkdir $base_dir/`p'\0`b'_`x'\0`a'_`y'
			
			local a = `a' + 1
			
		}
		
		local b = `b' + 1
		
	}
	
	

	