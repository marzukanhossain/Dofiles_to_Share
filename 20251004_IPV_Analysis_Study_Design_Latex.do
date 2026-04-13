/************************************************************************************
*Title: 20251004_IPV_Analysis_Study_Design_Latex
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
	
	global results_end_fig	"$proj_dir\06_Results\03_Endline\Figures"
	
	global results_end_tab	"$proj_dir\06_Results\03_Endline\Tables"
	
	global results_end_excel	"$proj_dir\06_Results\03_Endline\Excel"
	

	
	
	
	
	
	use "$data_e_analysis\20250912_IPV_Analysis", clear
	
	count if treat_order_prompt!=. & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
	
	local n1_1 : display %9.0fc `r(N)'
	
	count if treat_order_prompt==1 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
	local n2_1 : display %9.0fc `r(N)'
	
	count if treat_order_prompt==0 & consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1
		
	local n2_2 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==1
		
	local n3_1 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==0
		
	local n3_2 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==1
		
	local n3_3 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==0
		
	local n3_4 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==1 & treat_word_sym==1
		
	local n4_1 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==1 & treat_word_sym==0
		
	local n4_2 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==0 & treat_word_sym==1
		
	local n4_3 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==1 & treat_hybrid_acasi==0 & treat_word_sym==0
		
	local n4_4 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==1 & treat_word_sym==1
		
	local n4_5 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==1 & treat_word_sym==0
		
	local n4_6 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==0 & treat_word_sym==1
		
	local n4_7 : display %9.0fc `r(N)'
		
	count if consent==1 & just_wife_survey!=1 & treat_privacy_reiterated==1 & treat_order_prompt==0 & treat_hybrid_acasi==0 & treat_word_sym==0
		
	local n4_8 : display %9.0fc `r(N)'
	
	local nd "1.75cm"
	
	local yshift_1 "0.25cm"
	
	local xshift_1 "5.75cm"
	
	local xshift_2 "2.75cm"
	
	
	
	
	cd "$results_end_fig"
	
	texdoc init Fig_Study_Design.tex, replace
	
	
	
	
	/*tex
\begin{figure}[h!]
\begin{center}

\caption{Study Design} \label{fig:studydesign}
  
\footnotesize




\tikzstyle{process} = [rectangle, minimum width=3.5cm, minimum height=1cm, text centered, text width=3.5cm, color=black, draw=grey, fill=white!70]
\tikzstyle{processc} = [rectangle, minimum width=4cm, minimum height=1cm, text centered, text width=4cm, color=black, draw=grey, fill=white]
\tikzstyle{process2} = [rectangle, minimum width=2.5cm, minimum height=1cm, text centered, text width=2.5cm, color=white, draw=grey, fill=grey!50]
\tikzstyle{process2k} = [rectangle, minimum width=7cm, minimum height=1.5cm, text centered, text width=7cm, color=white, draw=grey, fill=grey!10]
\tikzstyle{process2.5} = [rectangle, minimum width=2.25cm, minimum height=1cm, text centered, text width=2.25cm, color=grey!50, draw=grey!50, very thick, dotted, fill=white!50]
\tikzstyle{process3} = [rectangle, minimum width=3.25cm, minimum height=1.5cm, text centered, text width=3.25cm, color=black, draw=grey, fill=white!30]
\tikzstyle{process3k} = [rectangle, minimum width=6.5cm, minimum height=0.5cm, text centered, text width=6.5cm, color=black, draw=grey, fill=white!30]
\tikzstyle{process3.5} = [rectangle, minimum width=2cm, minimum height=1.5cm, text centered, text width=2cm, color=grey!70, draw=grey!70, dashed, fill=white!30]
\tikzstyle{process3.5k} = [rectangle, minimum width=6.5cm, minimum height=0.5cm, text centered, text width=6.5cm, color=grey!70, draw=grey!70, dashed, fill=white!30]
\tikzstyle{process3c} = [rectangle, minimum width=3cm, minimum height=1cm, text centered, text width=3cm, color=black, draw=grey, fill=white!20]
\tikzstyle{blank} = [rectangle, minimum width=3cm, minimum height=1cm, text centered, text width=4cm, draw=white, fill=white!30]
\tikzstyle{blank2} = [rectangle, minimum width=0mm, minimum height=0cm, text centered, text width=0mm, draw=white, fill=white!30]
\tikzstyle{arrow} = [very thick,->,>=stealth]
\tikzstyle{arrow2} = [very thick, dashed, draw=grey!70, ->, >=stealth]
\tikzstyle{line} = [very thick,--]
\tikzstyle{line2} = [very thick, dashed, draw=grey!70, --]


\begin{tikzpicture}[node distance=1.75cm]


\node (sample) [process] {\textbf{Study sample}

n = 5,588};

\node (key1) [process2k, right of=sample, xshift=6cm] {};

\node (key2) [process3k, right of=sample, xshift=6cm, yshift=0.325cm] {\scriptsize Part of 2 $\times$ 2 factorial experiment};

\node (key3) [process3.5k, right of=sample, xshift=6cm, yshift=-0.325cm] {\scriptsize Non-experimental part, shown for completeness};

\node (r_pr) [process2, below of=sample, yshift=0.25cm] {Order

randomisation};


\node (p) [process3, below of=r_pr, xshift=-5.75cm] {\textbf{P.} \(1^{st}\) IPV attitude

\(2^{nd}\) IPV incidence
\vspace{0.1cm}

n = 2,843};
	

\node (rp_ah) [process2, below of=p] {Survey mode randomisation};


\node (pa) [process3, below of=rp_ah, xshift=-2.75cm] {\textbf{PA.} ACASI
\vspace{0.5cm}

n = 1,412};

\node (rpa_sw) [process2.5, below of=pa] {Options randomisation}

\node (pas) [process3.5, below of=rpa_sw, xshift=-1.35cm] {\textbf{S\(_{pa}\).} Symbol options
\vspace{0.1cm}

n = 685}; 

\node (paw) [process3.5, below of=rpa_sw, xshift=1.35cm] {\textbf{W\(_{pa}\).} Word options
\vspace{0.1cm}

n = 727}; 

\node (ph) [process3, below of=rp_ah, xshift=2.75cm] {\textbf{PH.} Hybrid 
\vspace{0.5cm}

n = 1,431};

\node (rph_sw) [process2.5, below of=ph] {Options randomisation}

\node (phs) [process3.5, below of=rph_sw, xshift=-1.35cm] {\textbf{S\(_{ph}\).} Symbol options
\vspace{0.1cm}

n = 669}; 

\node (phw) [process3.5, below of=rph_sw, xshift=1.35cm] {\textbf{W\(_{ph}\).} Word options
\vspace{0.1cm}

n = 762}; 



\node (r) [process3, below of=r_pr, xshift=5.75cm] {\textbf{R.} \(1^{st}\) IPV incidence

\(2^{nd}\) IPV attitude
\vspace{0.1cm} 

n = 2,745};


\node (rr_ah) [process2, below of=r] {Survey mode randomisation};

%\node (blank1wrd) [blank2, left of=treat1wr, xshift=2.87cm] {};

%\node (blank1wrl) [blank2, left of=treat1wr, xshift=3cm, yshift=0.13cm] {};


\node (ra) [process3, below of=rr_ah, xshift=-2.75cm] {\textbf{RA.} ACASI
\vspace{0.5cm}

n = 1,404};

\node (rra_sw) [process2.5, below of=ra] {Options randomisation}

\node (ras) [process3.5, below of=rra_sw, xshift=-1.35cm] {\textbf{S\(_{ra}\).} Symbol options
\vspace{0.1cm}

n = 697}; 

\node (raw) [process3.5, below of=rra_sw, xshift=1.35cm] {\textbf{W\(_{ra}\).} Word options
\vspace{0.1cm}

n = 707}; 



\node (rh) [process3, below of=rr_ah, xshift=2.75cm] {\textbf{RH.} Hybrid 
\vspace{0.5cm}

n = 1,341};

\node (rrh_sw) [process2.5, below of=rh] {Options randomisation}

\node (rhs) [process3.5, below of=rrh_sw, xshift=-1.35cm] {\textbf{S\(_{rh}\).} Symbol options
\vspace{0.1cm}

n = 666}; 

\node (rhw) [process3.5, below of=rrh_sw, xshift=1.35cm] {\textbf{W\(_{rh}\).} Word options
\vspace{0.1cm}

n = 675}; 






%\draw [->] (all) -| node[anchor=south] {random assignment} (treat1);
%\draw [->] (all) -- node[anchor=east] {random assignment} (treat2);
%\draw [->] (all) -| node[anchor=south] {random assignment} (control);
\draw [line] (sample) -- (r_pr);
\draw [arrow] (r_pr) -| (p);
\draw [arrow] (r_pr) -| (r);
\draw [line] (p) -- (rp_ah);
\draw [arrow] (rp_ah) -| (pa);
\draw [arrow] (rp_ah) -| (ph);
\draw [line] (r) -- (rr_ah);
\draw [arrow] (rr_ah) -| (ra);
\draw [arrow] (rr_ah) -| (rh);
\draw [line2] (pa) -- (rpa_sw);
\draw [arrow2] (rpa_sw) -| (pas);
\draw [arrow2] (rpa_sw) -| (paw);
\draw [line2] (ph) -- (rph_sw);
\draw [arrow2] (rph_sw) -| (phs);
\draw [arrow2] (rph_sw) -| (phw);
\draw [line2] (ra) -- (rra_sw);
\draw [arrow2] (rra_sw) -| (ras);
\draw [arrow2] (rra_sw) -| (raw);
\draw [line2] (rh) -- (rrh_sw);
\draw [arrow2] (rrh_sw) -| (rhs);
\draw [arrow2] (rrh_sw) -| (rhw);



\end{tikzpicture}



\end{center}

    \caption*{
    \footnotesize
    Notes: The enumerator reads out each of the questions to the respondents and hands the tablet device (with SurveyCTO application being used for data collection) to the respondents for tapping in their responses each time - we name this mode of survey as Hybrid.
    
	Return to text at: \hyperlinktolabel{fig:studydesign1}, \hyperlinktolabel{fig:studydesign7}, \hyperlinktolabel{fig:studydesign2}, \hyperlinktolabel{fig:studydesign3}, \hyperlinktolabel{fig:studydesign4}, \hyperlinktolabel{fig:studydesign5} and \hyperlinktolabel{fig:studydesign6}.}

\end{figure}

tex*/


	
	
	
	
	