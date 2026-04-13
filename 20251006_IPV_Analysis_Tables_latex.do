/************************************************************************************
*Title: 20251006_IPV_Analysis_Tables_latex
*Created by: Marzuk
*Created on: Oct 06, 2025
*Last Modified on:  Oct 06, 2025
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
	
	cd "$results_endline\Tables\IPV"
	
	reg overstatement treat_hybrid_acasi treat_word_sym treat_acasi_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, vce(robust)
	
	
	
	

	
	
**# IPV Incidences & attitude
	
	
	
	texdoc init Table_IPV_Analysis_AnyIPV.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinktabnote{tab:IPVany1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinktabnote{tab:IPVany2})"
	
	lab var treat_acasi_prompt "P $\times$ A"
	
	lab var hdhs_gen_ipv_pc "Index of Attitude on IPV"

	
	
	
	local v5 "hvaw_ever_ipv hvaw_lastyr_ipv hdhs_gen_ipv_pc"
	
	local v7 "treat_order_prompt treat_hybrid_acasi treat_acasi_prompt _cons"
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi _cons"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on IPV Reporting and Attitude Towards IPV} \label{tab:IPVany}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x', 2) == 0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation} and the impacts of different survey modes are shown in Table \ref{tab:IPVanycoeffs}. The variables on IPV experiences are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent over the specified time, and zero otherwise. The index on attitude towards IPV is created from five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVany1} P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVany2} A is equal to one if ACASI survey mode is used for the IPV questions; and zero if enumerator assisted self-interviewing survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response, then the tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to text at: \hyperlinktolabel{tab:IPVanycoeffs1t} and \hyperlinktolabel{tab:IPVanycoeffs2t}.	
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	
	texdoc close 
	

	
	
**# IPV Incidences & attitude coeffs
	
	
	
	texdoc init Table_IPV_Analysis_AnyIPVcoeffs.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinktabnote{tab:IPVanycoeffs1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinktabnote{tab:IPVanycoeffs2})"
	
	lab var treat_acasi_prompt "P $\times$ A"
	
	lab var hdhs_gen_ipv_pc "Index of Attitude on IPV"

	
	
	
	local v5 "hvaw_ever_ipv hvaw_lastyr_ipv hdhs_gen_ipv_pc"
	
	local v7 ""Impact of prompt (P\hyperlinktabnote{tab:IPVanycoeffs1}) given hybrid" "Impact of ACASI (A\hyperlinktabnote{tab:IPVanycoeffs2}) given reversed prompt" "Additional impact (P\(\times\)A)" "Impact of prompt given ACASI" "Impact of ACASI given prompt""
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_order_prompt+1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_hybrid_acasi+1.treat_order_prompt#1.treat_hybrid_acasi"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 2
		
	local k = `a' + 1
		
	foreach x of local v8 {
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
		
		local a = `a' + 2
		
		local k = `a' + 1
				
	}
	
	
	
	local col1w = 6.75
	
	local colnow = 2.55
	
	
	local ana`a' "\multirow[t]{2}{`col1w'cm}{Control mean (reversed prompt and hybrid)}"
	
	local ana`k' "Observations"
	
	local m = `a'
	
	
	local l = 0
	
	foreach x of local v7 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on IPV Reporting and Attitude Towards IPV} \label{tab:IPVanycoeffs}
 \footnotesize
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
		
		local ana`b' "\multirow[t]{2}{`col1w'cm}{`x'}"
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{`colnow'cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
		
		
		sum `y' if treat_order_prompt==0 & treat_hybrid_acasi==0 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		local mean : display %9.3fc `r(mean)'
		
		local ana`m' "`ana`m''&`mean'"
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x', 2) == 0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\scriptsize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation} and the regression results are shown in Table \ref{tab:IPVany}. The variables on IPV experiences are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent over the specified time, and zero otherwise. The index on attitude towards IPV is created from five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVanycoeffs1} P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVanycoeffs2} A is equal to one if ACASI survey mode is used for the IPV questions; and zero if enumerator assisted self-interviewing survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response, then the tab is returned to the enumerator - this process is repeated for all IPV questions in the this survey mode).
	\item Return to text at: \hyperlinktolabel{tab:IPVanycoeffs1t}, \hyperlinktolabel{tab:IPVanycoeffs3t}, \hyperlinktolabel{tab:IPVanycoeffs2t} and \hyperlinktolabel{tab:IPVanycoeffs31t}.	
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	
	texdoc close 
	

		
	

**# IPV Rob Incidences
	
	
	
	texdoc init Table_IPV_Analysis_AnyIPVRob.tex, replace
	
	
	
	lab var treat_order_prompt "Treatment P\hyperlinktabnote{tab:IPVanyrob1}"
	
	lab var treat_hybrid_acasi "Treatment A\hyperlinktabnote{tab:IPVanyrob2}"
	
	lab var treat_acasi_prompt "Treatment P $\times$ A"

	
	
	
	local v5 "hvaw_ever_ipv hvaw_lastyr_ipv"
	
	local v7 "treat_order_prompt treat_hybrid_acasi treat_acasi_prompt _cons"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Robustness of the Impact of Modes of Data Collection on IPV Reporting} \label{tab:IPVanyrob}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt treat_hybrid_acasi treat_acasi_prompt treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==0, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v7 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x' == 4 | `x' == 6 | `x' == 8 | `x'==9 {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	

	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation}. All the outcome variables are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent, and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVanyrob1} Treatment P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVanyrob2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \ref{sec:introduction}, \ref{sec:background}, \ref{sec:intervention}, \ref{sec:studydesign}, \ref{sec:data}, \ref{sec:empiricalstrategy}, \ref{sec:results} or \ref{sec:conclusion}.	
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	texdoc close 
	
	

	

	
**# IPV Het Incidences
	
	
	
	texdoc init Table_IPV_Analysis_AnyIPVHet.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinktabnote{tab:IPVanyhet1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinktabnote{tab:IPVanyhet2})"
	
	lab var treat_acasi_prompt "P $\times$ A"
	
	lab var ipvf_age "Age (years)"
	
	
	gen treat_prompt_age = ipvf_age * treat_order_prompt
	
	lab var treat_prompt_age "P $\times$ Age"
	
	gen treat_acasi_age = ipvf_age * treat_hybrid_acasi
	
	lab var treat_acasi_age "A $\times$ Age"
	
	gen treat_acasi_prompt_age = ipvf_age * treat_acasi_prompt
	
	lab var treat_acasi_prompt_age "P $\times$ A $\times$ Age"

	
	
	
	local v5 "hvaw_ever_ipv hvaw_lastyr_ipv hdhs_gen_ipv_pc"
	
	local v7 "treat_order_prompt treat_hybrid_acasi ipvf_age treat_acasi_prompt treat_prompt_age treat_acasi_age treat_acasi_prompt_age _cons"
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi ipvf_age 1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_order_prompt#c.ipvf_age 1.treat_hybrid_acasi#c.ipvf_age 1.treat_order_prompt#1.treat_hybrid_acasi#c.ipvf_age _cons"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection and Age on IPV Reporting} \label{tab:IPVanyhet}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi##c.ipvf_age treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation}. The variables on IPV experiences are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent over the specified time, and zero otherwise. The index on attitude towards IPV is created from five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVanyhet1} Prompted (P) is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVanyhet2} ACASI (A) is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section:  \hyperlinktolabel{tab:IPVanyhet1t}.
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	
	texdoc close 
		

		
		

	
**# IPV Hete Incidences
	
	
	
	texdoc init Table_IPV_Analysis_AnyIPVHete.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinktabnote{tab:IPVanyhete1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinktabnote{tab:IPVanyhete2})"
	
	lab var treat_acasi_prompt "P $\times$ A"
	
	lab var yrs_education_ipv "Education (years)"
	
	
	gen treat_prompt_edu = yrs_education_ipv * treat_order_prompt
	
	lab var treat_prompt_edu "P $\times$ Education"
	
	gen treat_acasi_edu = yrs_education_ipv * treat_hybrid_acasi
	
	lab var treat_acasi_edu "A $\times$ Education"
	
	gen treat_acasi_prompt_edu = yrs_education_ipv * treat_acasi_prompt
	
	lab var treat_acasi_prompt_edu "P $\times$ A $\times$ Education"

	
	
	
	local v5 "hvaw_ever_ipv hvaw_lastyr_ipv hdhs_gen_ipv_pc"
	
	local v7 "treat_order_prompt treat_hybrid_acasi yrs_education_ipv treat_acasi_prompt treat_prompt_edu treat_acasi_edu treat_acasi_prompt_edu _cons"
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi yrs_education_ipv 1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_order_prompt#c.yrs_education_ipv 1.treat_hybrid_acasi#c.yrs_education_ipv 1.treat_order_prompt#1.treat_hybrid_acasi#c.yrs_education_ipv _cons"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection and Education on IPV Reporting} \label{tab:IPVanyhete}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi##c.yrs_education_ipv treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation}. The variables on IPV experiences are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent over the specified time, and zero otherwise. The index on attitude towards IPV is created from five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVanyhete1} Treatment P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVanyhete2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVanyhete1t}.
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	
	texdoc close 
				
	
	
	
	
	
**# IPV Incidences Types	
	
	texdoc init Table_IPV_Analysis_AnyIPVtypes.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinkatabnote{tab:IPVtypes1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinkatabnote{tab:IPVtypes2})"
	
	lab var treat_acasi_prompt "P $\times$ A"

	
	
	
	
	local v4 "\multirow[t]{2}{5cm}{Panel A : Ever IPV experienced}"
	
	local v5 "hvaw1_ever_slap hvaw1_ever_push hvaw1_ever_kick hvaw1_ever_batonbash"
	
	local v7 "treat_order_prompt treat_hybrid_acasi treat_acasi_prompt _cons"
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi _cons"
	
	lab var hvaw1_ever_slap "Slapped"
	
	lab var hvaw1_ever_push "Pushed"
		
	lab var hvaw1_ever_kick "Kicked"
	
	lab var hvaw1_ever_batonbash "Baton Bashed"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 "`v4'"
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on IPV Reporting} \label{tab:IPVtypes}
 \footnotesize
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule
	
	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{`v'}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	
	tex*/
	
	
	
	local v4 "\multirow[t]{2}{5cm}{Panel B : Last year IPV experienced}"
	
	local v5 "hvaw2_lastyr_slap hvaw2_lastyr_push hvaw2_lastyr_kick hvaw2_lastyr_batonbash"
	
	lab var hvaw2_lastyr_slap "Slapped"
	
	lab var hvaw2_lastyr_push "Pushed"
		
	lab var hvaw2_lastyr_kick "Kicked"
	
	lab var hvaw2_lastyr_batonbash "Baton Bashed"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 "`v4'"
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	

texdoc write \vspace{1cm} \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule
	
	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{`v'}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	

	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\scriptsize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation} and the impact of different survey modes are shown in Table \ref{tab:IPVtypescoeffs}. All the outcome variables are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent, and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargetatabnote{tab:IPVtypes1} Treatment P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargetatabnote{tab:IPVtypes2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVtypescoeffs1t}.	
    \end{tablenotes}
\end{table}
	tex*/
		
	
	
	
	
	texdoc close 
	

	
	
	
	
	
	
**# IPV Incidences Types Coeffs 
	
	texdoc init Table_IPV_Analysis_AnyIPVtypescoeffs.tex, replace
	
	
	
	lab var treat_order_prompt "Prompted (P\hyperlinkatabnote{tab:IPVtypes1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinkatabnote{tab:IPVtypes2})"
	
	lab var treat_acasi_prompt "P $\times$ A"

	
	
	
	local col1w = 6.75
	
	local colnow = 2.55
	
	
	local v5 "hvaw1_ever_slap hvaw1_ever_push hvaw1_ever_kick hvaw1_ever_batonbash"
	
	local v7 ""Impact of prompt (P\hyperlinktabnote{tab:IPVtypescoeffs1}) given hybrid" "Impact of ACASI (A\hyperlinktabnote{tab:IPVtypescoeffs2}) given reversed prompt" "Additional impact (P\(\times\)A)" "Impact of prompt given ACASI" "Impact of ACASI given prompt""
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_order_prompt+1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_hybrid_acasi+1.treat_order_prompt#1.treat_hybrid_acasi"
	
	lab var hvaw1_ever_slap "Slapped"
	
	lab var hvaw1_ever_push "Pushed"
		
	lab var hvaw1_ever_kick "Kicked"
	
	lab var hvaw1_ever_batonbash "Baton Bashed"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	
	local a = 2
		
	local k = `a' + 1
		
	foreach x of local v8 {
		
		local ana0 "\multirow[t]{2}{`col1w'cm}{Panel A : Ever IPV experienced}"
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
		
		local a = `a' + 2
		
		local k = `a' + 1
				
	}
	
	
	
	
	local ana`a' "\multirow[t]{2}{`col1w'cm}{Control mean (reversed prompt and hybrid)}"
	
	local ana`k' "Observations"
	
	local m = `a'
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on IPV Reporting} \label{tab:IPVtypescoeffs}
 \footnotesize
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule
	
	
		
	
	
	
	*di "`v0`b''"

	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
		
		local ana`b' "\multirow[t]{2}{`col1w'cm}{`x'}"
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{`v'}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
		
		
		
		sum `y' if treat_order_prompt==0 & treat_hybrid_acasi==0 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		local mean : display %9.3fc `r(mean)'
		
		local ana`m' "`ana`m''&`mean'"
		
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	
	tex*/
	
	
	
	local v5 "hvaw2_lastyr_slap hvaw2_lastyr_push hvaw2_lastyr_kick hvaw2_lastyr_batonbash"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	
	local a = 2
		
	local k = `a' + 1
		
	foreach x of local v8 {
		
		local ana0 "\multirow[t]{2}{`col1w'cm}{Panel B : Last year IPV experienced}"
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
		
		local a = `a' + 2
		
		local k = `a' + 1
				
	}
	
	
	
	
	local ana`a' "\multirow[t]{2}{`col1w'cm}{Control mean (reversed prompt and hybrid)}"
	
	local ana`k' "Observations"
	
	local m = `a'
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	

texdoc write \vspace{1cm} \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule
	
	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
		
		local ana`b' "\multirow[t]{2}{`col1w'cm}{`x'}"
		
		local a = `a' + 1
	
	}
	
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{`v'}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
		
		
		
		sum `y' if treat_order_prompt==0 & treat_hybrid_acasi==0 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		local mean : display %9.3fc `r(mean)'
		
		local ana`m' "`ana`m''&`mean'"
		
		
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	

	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\scriptsize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:mainequation} and the regression results are shown in Table \ref{tab:IPVtypes}. All the outcome variables are equal to one if any of the four acts (being slapped, pushed, kicked or baton bashed) are experienced by the respondent, and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVtypescoeffs1} P is equal to one if IPV experience questions are prompted with attitude towards IPV questions; and zero if IPV experience questions appear before those on attitude towards IPV.
	\item \hypertargettabnote{tab:IPVtypescoeffs2} A is equal to one if ACASI survey mode is used for the IPV questions; and zero if enumerator assisted self-interviewing survey mode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response, then the tab is returned to the enumerator - this process is repeated for all IPV questions in the this survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVtypescoeffs1t}.	
    \end{tablenotes}
\end{table}
	tex*/
		
	
	
	
	
	texdoc close 
	

	
	
	
	

	
	
	
	
**# IPV Attitude	
	
	texdoc init Table_IPV_Analysis_IPVAttitude.tex, replace
	
	
	
	
	lab var treat_order_reverse "Treatment R\hyperlinktabnote{tab:IPVatt1}"
	
	lab var treat_hybrid_acasi "Treatment A\hyperlinktabnote{tab:IPVatt2}"
	
	lab var treat_acasi_reverse "Treatment R $\times$ A"


	
	
	
	
	
	local v5 "hdhs_gen_ipv_pc"
	
	local v7 "treat_order_reverse treat_hybrid_acasi treat_acasi_reverse _cons"
	
	lab var hdhs_gen_ipv_pc "Attitude on IPV Index"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on Attitude Towards IPV} \label{tab:IPVatt}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_reverse treat_hybrid_acasi treat_acasi_reverse treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v7 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x' == 4 | `x' == 6 | `x' == 8 | `x'==9 {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:extequation}. The outcome variable is an index created from the five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVatt1} Treatment R is equal to one if attitude towards IPV questions are prompted with IPV experience questions; and zero if attitude towards IPV questions appear before those on IPV experience.
	\item \hypertargettabnote{tab:IPVatt2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid surveymode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVatt1t} and \hyperlinktolabel{tab:IPVatt2t}.	
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	texdoc close 
	
	
		
	
**# IPV Rob Attitude	
	
	texdoc init Table_IPV_Analysis_IPVAttitudeRob.tex, replace
	
	
	
	
	lab var treat_order_reverse "Treatment R\hyperlinktabnote{tab:IPVattrob1}"
	
	lab var treat_hybrid_acasi "Treatment A\hyperlinktabnote{tab:IPVattrob2}"
	
	lab var treat_acasi_reverse "Treatment R $\times$ A"


	
	
	local v5 "hdhs_gen_ipv_pc"
	
	local v7 "treat_order_reverse treat_hybrid_acasi treat_acasi_reverse _cons"
	
	lab var hdhs_gen_ipv_pc "Attitude on IPV Index"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Robustness of the Impact of Modes of Data Collection on Attitude Towards IPV} \label{tab:IPVattrob}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{3cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_reverse treat_hybrid_acasi treat_acasi_reverse treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==0, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v7 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x' == 4 | `x' == 6 | `x' == 8 | `x'==9 {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:extequation}. The outcome variable is an index created from the five variables. Each of these five variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargettabnote{tab:IPVattrob1} Treatment R is equal to one if attitude towards IPV questions are prompted with IPV experience questions; and zero if attitude towards IPV questions appear before those on IPV experience.
	\item \hypertargettabnote{tab:IPVattrob2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid surveymode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \ref{sec:introduction}, \ref{sec:background}, \ref{sec:intervention}, \ref{sec:studydesign}, \ref{sec:data}, \ref{sec:empiricalstrategy}, \ref{sec:results} or \ref{sec:conclusion}.	
    \end{tablenotes}
\end{table}
	tex*/
	
	
	
	
	
	texdoc close 
	

	
	
**# IPV Attitude Types	
	
	texdoc init Table_IPV_Analysis_IPVAttitudetyp.tex, replace
	
	
	

	lab var treat_order_prompt "Prompted (P\hyperlinkatabnote{tab:IPVatttyp1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinkatabnote{tab:IPVatttyp2})"
	
	lab var treat_acasi_prompt "P $\times$ A"


	
	
	local v5 "hdhs_goes_out hdhs_neglects_child hdhs_argues hdhs_refuses_intimacy hdhs_burns_food"
	
	local v7 "treat_order_prompt treat_hybrid_acasi treat_acasi_prompt _cons"
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi _cons"
	
	lab var hdhs_goes_out "Goes out unannounced"
	
	lab var hdhs_neglects_child "Neglects child"
	
	lab var hdhs_argues "Argues" 
	
	lab var hdhs_refuses_intimacy "Refuses intimacy" 
	
	lab var hdhs_burns_food "Burns food"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	local a = 0
	
	foreach x of local v7 {
		
		local a = `a' + 2
		
		local k = `a' + 1
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
				
	}
	
	local ana`a' "Constant"
	
	local ana`k' "Observations"
	
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	local l1 = `l' + 1
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on Attitude Towards IPV} \label{tab:IPVatttyp}
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

texdoc write &\multicolumn{`l'}{c}{Husband can beat wife if wife:} \\\cmidrule(lr){2-`l1'}

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
						
		if `b'<`k'-2 {
			
			local v : var lab `x'
			
			local ana`b' "\multirow[t]{2}{5cm}{`v'}"
			
		}
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{2.25cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
			
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
		
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\footnotesize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:extequation} and the impact of different survey modes are shown in Table \ref{tab:IPVatttypcoeffs}. Each of the five outcome variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargetatabnote{tab:IPVatttyp1} Treatment R is equal to one if attitude towards IPV questions are prompted with IPV experience questions; and zero if attitude towards IPV questions appear before those on IPV experience.
	\item \hypertargetatabnote{tab:IPVatttyp2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid surveymode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVatttypcoeffs1t}.	
    \end{tablenotes}
\end{table}
	tex*/
	

	
	
	
	
	texdoc close 

	
	
	
	
	
**# IPV Attitude Types Coefficient
	
	texdoc init Table_IPV_Analysis_IPVAttitudetypcoeffs.tex, replace
	
	
	

	lab var treat_order_prompt "Prompted (P\hyperlinkatabnote{tab:IPVatttyp1})"
	
	lab var treat_hybrid_acasi "ACASI (A\hyperlinkatabnote{tab:IPVatttyp2})"
	
	lab var treat_acasi_prompt "P $\times$ A"

	
	
	
	local col1w = 6.75
	
	local colnow = 2.25
	
	
	
	local v5 "hdhs_goes_out hdhs_neglects_child hdhs_argues hdhs_refuses_intimacy hdhs_burns_food"
	
	local v7 ""Impact of prompt (P\hyperlinktabnote{tab:IPVtypescoeffs1}) given hybrid" "Impact of ACASI (A\hyperlinktabnote{tab:IPVtypescoeffs2}) given reversed prompt" "Additional impact (P\(\times\)A)" "Impact of prompt given ACASI" "Impact of ACASI given prompt""
	
	local v8 "1.treat_order_prompt 1.treat_hybrid_acasi 1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_order_prompt+1.treat_order_prompt#1.treat_hybrid_acasi 1.treat_hybrid_acasi+1.treat_order_prompt#1.treat_hybrid_acasi"
	
	lab var hdhs_goes_out "Goes out unannounced"
	
	lab var hdhs_neglects_child "Neglects child"
	
	lab var hdhs_argues "Argues" 
	
	lab var hdhs_refuses_intimacy "Refuses intimacy" 
	
	lab var hdhs_burns_food "Burns food"
	
	*lab var treat_order_prompt "Treatment P: 1 = attitude prompted, 0 = order reversed"
	
	local a = 2
		
	local k = `a' + 1
		
	foreach x of local v8 {
		
		local ana0 ""
		
		local ana1 ""
		
		local ana`a' ""
		
		local ana`k' ""
		
		local a = `a' + 2
		
		local k = `a' + 1
				
	}
	
	
	local ana`a' "\multirow[t]{2}{`col1w'cm}{Control mean (reversed prompt and hybrid)}"
	
	local ana`k' "Observations"
	
	local m = `a'
	
	
	local l = 0
	
	foreach x of local v5 {
		
		local l = `l' + 1
	
		local v0`l' "`x'"
		
	}
	
	local l1 = `l' + 1
	
	/*tex
%\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
%the upper line is only used to show the sig stars using \sym{} command
\begin{table}[h]
\begin{center}
 \caption{Impact of Modes of Data Collection on Attitude Towards IPV} \label{tab:IPVatttypcoeffs}
 \footnotesize
 tex*/
texdoc write \begin{tabular}{l*{`l'}{D{.}{.}{-1}}} \toprule

texdoc write &\multicolumn{`l'}{c}{Husband can beat wife if wife:} \\\cmidrule(lr){2-`l1'}

	
		
	
	
	
	*di "`v0`b''"
	
	local a = 1
	
	local b = 0
	
	foreach x of local v7 {
		
		local b = `b' + 2
		
		local v00`a' "`x'"
		
		local ana`b' "\multirow[t]{2}{`col1w'cm}{`x'}"
		
		local a = `a' + 1
	
	}
	
	*di "`v2'"
	
	
	local a = 1
	
	foreach y of local v5 {
		
		
			local v: var lab `y'
			
			local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{2}{`colnow'cm}{\centering `v'}}"
			
			local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
		
			
			reghdfe `y' treat_order_prompt##treat_hybrid_acasi treat_word_sym if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1, a(enu_code pull_dist_code) vce(robust)
			
		
		local c = 2
		
		foreach x of local v8 {
			
			local d = `c' + 1
			
			lincom `x'
			
		local be`c' : display cond(`r(p)'<.01, string(`r(estimate)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(estimate)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(estimate)', "%9.3fc") + "^*", string(`r(estimate)', "%9.3fc") ))) 
	
		local se`d' : display %9.3fc `r(se)'
	
		display "`be`c''"
		
		local ana`c' "`ana`c''&`be`c''"
		
		if `d'!=`k' {
		
		local ana`d' "`ana`d''&(`se`d'')"
		
		}
		
		local c = `c' + 2
		
		}
	
	
		local no : display %9.0fc `e(N_full)'
		
			
		
		local ana`k' "`ana`k''&\multicolumn{1}{c}{`no'}"	
		
		
		
		sum `y' if treat_order_prompt==0 & treat_hybrid_acasi==0 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
		local mean : display %9.3fc `r(mean)'
		
		local ana`m' "`ana`m''&`mean'"
		
		
		
			
		local a = `a' + 1	
			
		
		
		
		}
		
		
	
	
	
	
	foreach x of numlist 0/`k' {
		
		if `x' == 0 {
			
			texdoc write `ana`x''\\\\
			
		}
		
		else if `x' == 1 {
		
			texdoc write `ana`x''\\ \midrule
		
		}
		
		else if `x'>2 & (mod(`x',2)==0 | `x'==`k') {
		
			texdoc write \addlinespace `ana`x''\\
			
		}
		
		else {
						
			texdoc write `ana`x''\\
		
		}
	}
	
	
		
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
	\scriptsize
	\begin{tablenotes}
    \item \textit{Notes}: Robust standard errors are in parentheses with district and enumerator fixed effects. \(^*\), \(^{**}\), and \(^{***}\) represent 10\%, 5\%, and 1\% significance levels, respectively. The model is specified in Equation \ref{eq:extequation} and the regression results are shown in Table \ref{tab:IPVatttyp}.. Each of the five outcome variables are equal to one if the respondent deems a husband justified in hitting his wife for that specific situation (if the wife goes out unannounced, neglects children, argues, refuses intimacy or burns food), and zero otherwise. The respondents who select ``Don't know" as a response are considered to be missing observations in our analysis.
	\item \hypertargetatabnote{tab:IPVatttyp1} Treatment R is equal to one if attitude towards IPV questions are prompted with IPV experience questions; and zero if attitude towards IPV questions appear before those on IPV experience.
	\item \hypertargetatabnote{tab:IPVatttyp2} Treatment A is equal to one if ACASI survey mode is used for the IPV questions; and zero if Hybrid surveymode is used (question, options and instructions are read out loud by the enumerator to the respodent, tab is handed to the respondent to tap in the response and tab is returned to the enumerator - this hybrid process is repeated for all IPV questions in the hybrid survey mode).
	\item Return to any section: \hyperlinktolabel{tab:IPVatttypcoeffs1t}.	
    \end{tablenotes}
\end{table}
	tex*/
	

	
	
	
	
	texdoc close 
	
	
	
	
	
	
	
	
	//# IPV Balance Table
	
	

		
	
	local v0 "remittance_received hh_income_pcap yr_cons_pcap hh_saving land_value livestock_value other_asset_value"
	
	
	local hhvno = 1
	
	foreach x of local v0 {
		
		local hhvno = `hhvno' + 1
		
	}
	
	
	local v1 "remittance_received hh_income_pcap yr_cons_pcap hh_saving land_value livestock_value other_asset_value ipvf_age num_children_ipv yrs_education_ipv iga_involved_ipv animal_rearing_ipv daylabour_ipv"
			
	local v2_1 "treat_pa treat_ph treat_ra treat_rh"
	
	local v2_2 "treat_hybrid_acasi treat_hybrid"
	
	local v2_3 "treat_order_prompt treat_order_reverse"
	
	
	local v3_1 ""Prompted\hyperlinktabnote{baltab1n1} and ACASI\hyperlinktabnote{baltab1n2}" "Prompted and Hybrid\hyperlinktabnote{baltab1n3}" "Prompt reversed\hyperlinktabnote{baltab1n4} and ACASI" "Prompt reversed and Hybrid""
		
	local v3_2 ""ACASI\hyperlinkatabnote{baltab2n1}" "Hybrid\hyperlinkatabnote{baltab2n2}""
		
	local v3_3 ""Prompted\hyperlinkatabnote{baltab3n1}" "Prompt reversed\hyperlinkatabnote{baltab3n2}""
	
	
	local v4_1 "\textit{p}-value from testing equality (1)=(2)=(3)=(4)" 
	
	local v4_2 "\textit{p}-value from testing (1)=(2)"
	
	local v4_3 "\textit{p}-value from testing (1)=(2)"
	
	local v5_1 "treat_arms"
	
	local v5_2 "treat_hybrid_acasi" 
	
	local v5_3 "treat_order_prompt"
	
	
	local cl1 = 5.75
	
	local cl2 = 6.5
	
	local cl3 = 6.5
	
	
	local cn1 = 1.5
	
	local cn2 = 2
	
	local cn3 = 2
	
	
	local cr1 = 2.5
	
	local cr2 = 2
	
	local cr3 = 2
	
	
	local cln1 = `cl1' + `cn1'
	
	local cln2 = `cl2' + `cn2'
	
	local cln3 = `cl3' + `cn3'
	
	
	local size1 "\scriptsize"
	
	local size2 "\footnotesize"
	
	local size3 "\footnotesize"
	
	
	local vno = 0
	
	foreach x of local v1 {
		
		local vno = `vno' + 1
		
	}
	
	local vno1 = `vno' - 1
	
	foreach x of numlist 1/3 {
		
		local a`x' = 1
		
		foreach y of local v2_`x' {
			
			local v2_`x'_`a`x'' "`y'"
			
			local a`x' = `a`x'' + 1
			
		}
		
		local a`x' = 1
		
		foreach y of local v3_`x' {
			
			lab var `v2_`x'_`a`x''' "`y'"
						
			local a`x' = `a`x'' + 1
			
			local b`x' = `a`x'' + 1
						
		}		
		
 		
	}
	
	
	
	
	
	
	/*
	
	foreach k of numlist 1/3 {
		
		
	
	texdoc init IPV_BalTab`k'_20251106.tex, replace

	
	
	
	
	/*tex
	\begin{table}[h]
	\begin{center}
	tex*/
	texdoc write \caption{Characteristics of Respondents Reporting Intimate Partner Violence (IPV)} \label{tab:baltab`k'}
	
	
	texdoc write `size`k''
	
	
	texdoc write \begin{tabular}{l*{`a`k''}{D{.}{.}{-1}}} \toprule
	
	local ana0 ""
	
	local ana1 ""
	
	
	
	local a = 0
	
	foreach y of local v2_`k' {
		
		local a = `a' + 1
	
		local v: var lab `y'
			
		local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{3}{`cn`k''cm}{\centering `v'}}"
				
		local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
						
	}
	
	texdoc write `ana0'&\multicolumn{1}{c}{\multirow[t]{3}{`cr`k''cm}{\centering `v4_`k''}}\\\\\\\cmidrule(lr){`b`k''-`b`k''}
	texdoc write `ana1'&\multicolumn{1}{c}{(`a`k'')}\\\midrule
	
	texdoc write \multirow[t]{1}{`cl`k''cm}{\underline{Household-Level Variables} (in 1,000 BDT)}\\
	
	local b = 0
	
	foreach x of local v1 {
		
		local b = `b' + 1
		
		local v: var lab `x'
		
		local row "\multirow[t]{1}{`cl`k''cm}{`v'}"
		
		if `b' == `vno1' {
		
			local row`vno1' "\multirow[t]{1}{`cl`k''cm}{Observations}"
		
		}
		
		
		foreach y of local v2_`k' {
			
			sum `x' if `y'==1
			
			local m :  display %9.2fc `r(mean)'
			
			local row "`row'&`m'"
			
			if `b' == `vno1' {
			
			sum `x' if `y'==1
						
				local ob : display %9.0fc `r(N)'
			
				local row`vno1' "`row`vno1''&\multicolumn{1}{c}{`ob'}" 
			
			}
		
		}
			
		
	
	if `k' == 1 {
		
		reghdfe `x' treat_ph treat_ra treat_rh, a(enu_code pull_dist_code) vce(robust)
		
		test treat_ph treat_ra treat_rh
		
	}
	
	else if `k'==2 {
		
		reghdfe `x' treat_hybrid, a(enu_code pull_dist_code) vce(robust)
		
		test treat_hybrid
		
	}
	
	else {
		
		reghdfe `x' treat_order_reverse, a(enu_code pull_dist_code) vce(robust)
		
		test treat_order_reverse
	}
	
	local pv : display cond(`r(p)'<.01, string(`r(p)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(p)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(p)', "%9.3fc") + "^*", string(`r(p)', "%9.3fc") )))
	
	local row "`row'&`pv'"
		
	if `b'==`hhvno' {
		
		texdoc write \addlinespace \multirow[t]{1}{`cl`k''cm}{\underline{Individual-Level Variables}}\\ `row'\\
	
	}
	
	else {
		
		texdoc write `row'\\
		
	}
		
	}
	
	texdoc write \addlinespace `row`vno1''\\\midrule
	
	
	local rowojos	"\multicolumn{`a`k''}{l}{\textit{p}-value of omnibus test of joint orthogonality with sample inference}"
	
	local rowojo	"\multicolumn{`a`k''}{l}{\textit{p}-value of omnibus test of joint orthogonality with randomised inference}"
	
	set seed 19921224
				
		local a = 0
		
		if `k'==1 {
			
			local a = `a' + 1 
			
				
				mlogit `v5_`k'' `v1'
				
				local pvals: display cond(`e(p)'<.01, string(`e(p)', "%9.3fc") + "^{***}", cond(`e(p)'<.05, string(`e(p)', "%9.3fc") + "^{**}", cond(`e(p)'<.1, string(`e(p)', "%9.3fc") + "^*", string(`e(p)', "%9.3fc") )))
				
				local rowojos "`rowojos'&`pvals'"
				
				
				
			
					ritest `v5_`k'' e(chi2),  reps(1000): mlogit `v5_`k'' `v1'
				
				
				
				local pval: display cond(r(p)[1,1]<.01, string(r(p)[1,1], "%9.3fc") + "^{***}", cond(r(p)[1,1]<.05, string(r(p)[1,1], "%9.3fc") + "^{**}", cond(r(p)[1,1]<.1, string(r(p)[1,1], "%9.3fc") + "^*", string(r(p)[1,1], "%9.3fc") )))
				
				local rowojo "`rowojo'&`pval'"
						
		}
		
		else {
			
			reghdfe `v5_`k'' `v1', a(enu_code pull_dist_code) vce(robust)
			
			test `v1'
						
				local pvals: display cond(`r(p)'<.01, string(`r(p)', "%9.3fc") + "^{***}", cond(`r(p)'<.05, string(`r(p)', "%9.3fc") + "^{**}", cond(`r(p)'<.1, string(`r(p)', "%9.3fc") + "^*", string(`r(p)', "%9.3fc") )))
				
				local rowojos "`rowojos'&`pvals'"
			
			ritest `v5_`k'' e(F), reps(1000): reghdfe `v5_`k'' `v1', a(enu_code pull_dist_code) vce(robust) 
			
			
				local pval: display cond(r(p)[1,1]<.01, string(r(p)[1,1], "%9.3fc") + "^{***}", cond(r(p)[1,1]<.05, string(r(p)[1,1], "%9.3fc") + "^{**}", cond(r(p)[1,1]<.1, string(r(p)[1,1], "%9.3fc") + "^*", string(r(p)[1,1], "%9.3fc") )))
				
				local rowojo "`rowojo'&`pval'"
				
			
		}
		
		
		
	
	texdoc write `rowojos'\\
	
	texdoc write `rowojo'\\
	
	local c`k' = `a`k'' - 1
	
	/*tex               
	\bottomrule 
	\end{tabular}
	\end{center}
    \vspace{-0.25cm}
	\begin{tablenotes}
    \scriptsize
	tex*/
    texdoc write \item \textit{Notes}: The columns (1) to (`c`k'') report the mean values of the respondents' characteristics. The column (`a`k'') reports the \(p\)-values of testing that the mean values reported in columns (1) to (`c`k'') are all equal for each characteristic. The bottom row reports the \(p\)-values of the omnibus test of joint orthogonality with randomised inference for each treatment arm \citep{kerwin_striking_2025}. \(^*\), \(^{**}\), and \(^{***}\) represent significance levels of 10\%, 5\%, and 1\% respectively.
	
	if `k'==1 {
		
		texdoc write \item \hypertargettabnote{baltab1n1} The questions on attitude towards IPV are asked before those on experiences of IPV.
		
		texdoc write \item \hypertargettabnote{baltab1n2} Audio Computer-Assisted Self-Interviewing survey mode used.
		
		texdoc write \item \hypertargettabnote{baltab1n3} Survey mode used where the enumerator reads aloud the questions, options and the instructions and hands the tablet device to the respondent to tap in her response.
		
		texdoc write \item \hypertargettabnote{baltab1n4} The questions on attitude towards IPV are asked after those on experiences of IPV.
		
		texdoc write \item Return to text at: \hyperlinktolabel{tab:baltab11}, \hyperlinktolabel{tab:baltab12}, \hyperlinktolabel{tab:baltab13}. 
		
	}
	
	if `k'==2 {
		
		texdoc write \item \hypertargetatabnote{baltab2n1} Audio Computer-Assisted Self-Interviewing survey mode used.
		
		texdoc write \item \hypertargetatabnote{baltab2n2} Survey mode used where the enumerator reads aloud the questions, options and the instructions and hands the tablet device to the respondent to tap in her response.
		
		texdoc write \item Return to Section: \ref{sec:introduction}, \ref{sec:background}, \ref{sec:intervention}, \ref{sec:studydesign}, \ref{sec:data}, \ref{sec:datacollection}, \ref{sec:sample}, \ref{sec:empiricalstrategy}, \ref{sec:results} or \ref{sec:conclusion}.
	}
	
	if `k'==3 {
		
		texdoc write \item \hypertargetatabnote{baltab3n1} The questions on attitude towards IPV are asked before those on experiences of IPV.
		
		texdoc write \item \hypertargetatabnote{baltab3n2} The questions on attitude towards IPV are asked after those on experiences of IPV.
		
		texdoc write \item Return to Section: \ref{sec:introduction}, \ref{sec:background}, \ref{sec:intervention}, \ref{sec:studydesign}, \ref{sec:data}, \ref{sec:datacollection}, \ref{sec:sample}, \ref{sec:empiricalstrategy}, \ref{sec:results} or \ref{sec:conclusion}.
		
	}
	
	/*tex
    \end{tablenotes}
\end{table}
	tex*/
	
	
	texdoc close 
	
	
	
	}
	
	*/
	
	
	
	
	//# New IPV Balance Table
	
		
	
	*copy "D:\Dropbox\BIGD\UPGP intergeneration\04_Code\03_Endline\04_Analysis\IPV\balancetest_latextable.ado" "`c(sysdir_personal)'", replace
	
	local v0 "remittance_received hh_income_pcap yr_cons_pcap hh_saving land_value livestock_value other_asset_value"
	
	
	local hhvno = 1
	
	foreach x of local v0 {
		
		local hhvno = `hhvno' + 1
		
	}
	
	
	local mcolnum = 0
	
	local treatdummies "treat_pa treat_ph treat_ra treat_rh"
	
	foreach x of local treatdummies {
		
		local mcolnum = `mcolnum' + 1 
		
	}
	
	
	local ncolnum = `mcolnum' + 1
	
	
	
	lab var treat_pa "Prompted\hyperlinktabnote{baltab1n1} and ACASI\hyperlinktabnote{baltab1n2}"
	lab var treat_ph "Prompted and Hybrid\hyperlinktabnote{baltab1n3}"
	
	lab var treat_ra  "Prompt reversed\hyperlinktabnote{baltab1n4} and ACASI"
	
	lab var treat_rh "Prompt reversed and Hybrid"
	
	
	
	
	
	global balancetestvariablesgroup1 "ipvf_age num_children_ipv yrs_education_ipv iga_involved_ipv animal_rearing_ipv daylabour_ipv"
	//add the names of the varibles you want to carry out balance tests for in the order you want them to appear (top to bottom) on your Balance Table.
	//if you want to group your variables on your balance table, write the names of the variables in each group - add more globals if necessary maintaining the same naming pattern for the globals.
	//group1 will apprear at the top of the balance table then group2 and so on.
		
	global balancetestvariablesgroup2 "land_value livestock_value other_asset_value hh_income_pcap yr_cons_pcap hh_saving remittance_received"
	
	global balancetestvariablesgroup3 ""
	
	global balancetestvariablesgroup4 ""
	
	global totalnumberofgroups = 2
	//write the total number of groups of variables you want to appear on your balance table.
	
	global group1name "\underline{Individual-Level Variables}"
	// Do not add a group names if there is only 1 group
	//Group names can only be added if there are multiple groups (more than 1 group).
	
	global group2name "\underline{Household-Level Variables} (in 1,000 BDT)"
	
	global group3name ""
	
	global group4name ""
	
	global controltreatmentdummies "treat_pa treat_ph treat_ra treat_rh"
	//create dummies for each arms so 1 for control, 1 for treatment1, 1 for treatment 2 and so on. 
	//Include the control dummy first followed by the others in your global
	
	global treatmentcontrolvariable "treat_arms"
	//create 1 variable with all the treatment arms and control, e.g. treatvar = 1 for treatment arm1, 2 for treatment arm2, 3 for arm3, 4 for control and so on.
	//if there is only 1 treatment arm then the 1 dummy from the global controltreatmentdummies is enough
	//this is necessary for the omnibus test for joint orthogonality.
	
	
	global columnlengthfirst = 6.5
	
	global columnlengthmeanvalues = 2
	
	global columnlengthlast = 2.5
	
	global columnheaderrownumber = 3
	//place an integer value of the number of rows you want for the column headers.
	
	global tabletextsize "footnotesize"
	//choose from any of these tiny	scriptsize	footnotesize	small	normalsize	large	Large	LARGE	huge	Huge (case sensitive)
	//please DO NOT add "\" before the size you chose
	
	global footnotetextsize "scriptsize"
	//same instructions as above
	
	global tabletexfilename "IPV_BalanceTable1"
	
	global tablecaption "Characteristics of Respondents Reporting Intimate Partner Violence (IPV)"
	
	global tablerefname "tab:baltab1"
	
	//regression specification (reghdfe is run to extract p-values from subsequent test)
	*global addfixedeffect = 1
	//write 0 if you do not want it, otherwise it will add fixed effects, 
	
	global fixedeffectvariables "enu_code pull_dist_code"
	//just write the names of the variables you want fixed effects for
	//if you do not want any fixed effects, leave it blank inside the quotation marks with no space between them.
	
	global otheroptions "vce(robust)"
	//choose from the various reghdfe options: e.g. vce(robust) or vce(cluster clustervarnames) and so on.  
	
	global meandecimalplace = 2
	//write the number of decimal places you want your mean values for each variable to show.
	
	global pvaluedecimalplace = 3
	//write the number of decimal places you want your p-values to show for each variable.	
	
	global addomnibusorthgontest = 1
	//write 0 if you do not want it, otherwise it will do the test
	
	global omnibustestseed = 19921224
	
	global footnotetext "\item \textit{Notes}: The columns (1) to (`mcolnum') report the mean values of the respondents' characteristics. The column (`ncolnum') reports the \(p\)-values of testing that the mean values reported in columns (1) to (`mcolnum') are all equal for each characteristic. The bottom row reports the \(p\)-values of the omnibus test of joint orthogonality with randomised inference for each treatment arm, while the row above it shows the \(p\)-value of the same test with sample inference \citep{kerwin_striking_2025}. \(^*\), \(^{**}\), and \(^{***}\) represent significance levels of 10\%, 5\%, and 1\% respectively. \item \hypertargettabnote{baltab1n1} The questions on attitude towards IPV are asked before those on experiences of IPV. \item \hypertargettabnote{baltab1n2} Audio Computer-Assisted Self-Interviewing survey mode used. \item \hypertargettabnote{baltab1n3} Survey mode used where the enumerator reads aloud the questions, options and the instructions and hands the tablet device to the respondent to tap in her response. \item \hypertargettabnote{baltab1n4} The questions on attitude towards IPV are asked after those on experiences of IPV. \item Return to text at: \hyperlinktolabel{tab:baltab11}, \hyperlinktolabel{tab:baltab12} and \hyperlinktolabel{tab:baltab13}."
	
	balancetest_latextable
	
	
	//# The End
	
	
	
	
	
	