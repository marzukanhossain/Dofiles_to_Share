/************************************************************************************
*Title: balancetest_latextable
*Created by: Marzuk
*Created on: FEB 25, 2026
*Last Modified on:  FEB 26, 2026
*Last Modified by: 	Marzuk
*Purpose :  Programme that creates latex tables 
	
************************************************************************************/

	
/*
        *
      /-/
     /-/
  . /-/ 
 /|\   
 / \
 
 */
 
 
	
	
	program define balancetest_latextable
	
	version 19.5
	
	
	
	local v1 ""
	
	local gpno = $totalnumberofgroups
	
	foreach x of numlist 1/`gpno' {
	
		local v1_`x' "${balancetestvariablesgroup`x'}"
		
		local gpnam`x' "${group`x'name}"
		
		local v1 "`v1' `v1_`x''" 
		
	}
			
	local v2 "$controltreatmentdummies"
	
	local v4 "\textit{p}-value from testing equality (1)"
	
	
	local a = 0
	
	local treat ""
	
	foreach x of local v2 {
		
		local a = `a' + 1
		
		if `a'>1 {
			
			local v4 "`v4'=(`a')"
			
			local treat "`treat' `x'"
			
		}
		
	}
	
	local treatarmsnum = `a'
		
	local v5 "$treatmentcontrolvariable"
	
	
	local cl = $columnlengthfirst
	
	local cn = $columnlengthmeanvalues
	
	local cr = $columnlengthlast
	
	local ncolnum = `a' + 1
	
	local tcolnum = `a' + 2
	
	local cln = `cl' + (`treatarmsnum'*`cn')
	
	local tabtextsize "\\$tabletextsize"
	
	local colheadrowdashes ""
		
	local foottextsize "\\$footnotetextsize"
	
	local fevars "$fixedeffectvariables"
	
	local op "$otheroptions"
	
	local options "a(`fevars') `op'"
	
	local omnibustest "$addomnibusorthgontest"
	
	
	foreach x of numlist 1/$columnheaderrownumber {
		
		local colheadrowdashes "`colheadrowdashes'\\"
		
	}
	
		
	
	texdoc init ${tabletexfilename}_20260225.tex, replace

	
	
	
	
	texdoc write \begin{table}[h]
	texdoc write \begin{center}
	
	texdoc write \caption{$tablecaption} \label{$tablerefname}
	
	
	texdoc write `tabtextsize'
	
	
	texdoc write \begin{tabular}{l*{`ncolnum'}{D{.}{.}{-1}}} \toprule
	
	local ana0 ""
	
	local ana1 ""
	
	
	
	local a = 0
	
	foreach y of local v2 {
		
		local a = `a' + 1
	
		local v: var lab `y'
			
		local ana0 "`ana0'&\multicolumn{1}{c}{\multirow[t]{$columnheaderrownumber}{`cn'cm}{\centering `v'}}"
				
		local ana1 "`ana1'&\multicolumn{1}{c}{(`a')}"
						
	}
	
	texdoc write `ana0'&\multicolumn{1}{c}{\multirow[t]{$columnheaderrownumber}{`cr'cm}{\centering `v4'}}`colheadrowdashes'\cmidrule(lr){`tcolnum'-`tcolnum'}
	texdoc write `ana1'&\multicolumn{1}{c}{(`ncolnum')}\\\midrule
	
	if `gpno'>1 {
		
		texdoc write \multirow[t]{1}{`cl'cm}{`gpnam1'}\\
	
	}
	
	else {
		
		di "`gpnam1'"
		
	}
	
	
	foreach z of numlist 1/`gpno' {
		
	local b = 0
	
	foreach x of local v1_`z' {
		
		local b = `b' + 1
		
		local v: var lab `x'
		
		local row "\multirow[t]{1}{`cl'cm}{`v'}"
		
		local rowlast "\multirow[t]{1}{`cl'cm}{Observations}"
		
		
		foreach y of local v2 {
			
			sum `x' if `y'==1
			
			local m :  display %9.${meandecimalplace}fc `r(mean)'
			
			local row "`row'&`m'"
						
				local ob : display %9.0fc `r(N)'
			
				local rowlast "`rowlast'&\multicolumn{1}{c}{`ob'}" 
		
		}
			di "`treat'"
		
	if "$fixedeffectvariables" == "" {
		
		reghdfe `x' `treat', noa $otheroptions
		
		test `treat'
			
	}
		
	else {	
		
		reghdfe `x' `treat', a($fixedeffectvariables) $otheroptions
		
		test `treat'
	
	}
	
	local pv : display cond(`r(p)'<.01, string(`r(p)', "%9.${pvaluedecimalplace}fc") + "^{***}", cond(`r(p)'<.05, string(`r(p)', "%9.${pvaluedecimalplace}fc") + "^{**}", cond(`r(p)'<.1, string(`r(p)', "%9.${pvaluedecimalplace}fc") + "^*", string(`r(p)', "%9.${pvaluedecimalplace}fc") )))
	
	local row "`row'&`pv'"
	
	
	texdoc write `row'\\
		
	
	}
	
	
	local s = `z' + 1
		
	if `z'<`gpno' {
		
		texdoc write \addlinespace \multirow[t]{1}{`cl'cm}{`gpnam`s''}\\
	
	}
	
	else {
		
		di `gpno'
		
	}
	
		
	}
	
	
	if $addomnibusorthgontest==0 {
		
		texdoc write \addlinespace `rowlast'\\
		
	}
	
	else {
	
	texdoc write \addlinespace `rowlast'\\\midrule
	
	
	local rowojos	"\multicolumn{`ncolnum'}{l}{\textit{p}-value of omnibus test of joint orthogonality with sample inference}"
	
	local rowojo	"\multicolumn{`ncolnum'}{l}{\textit{p}-value of omnibus test of joint orthogonality with randomised inference}"
	
	set seed $omnibustestseed
				
		local a = 0
			
			local a = `a' + 1 
			
				
				mlogit `v5' `v1'
				
				local pvals: display cond(`e(p)'<.01, string(`e(p)', "%9.3fc") + "^{***}", cond(`e(p)'<.05, string(`e(p)', "%9.3fc") + "^{**}", cond(`e(p)'<.1, string(`e(p)', "%9.3fc") + "^*", string(`e(p)', "%9.3fc") )))
				
				local rowojos "`rowojos'&`pvals'"
				
				
				
			
					ritest `v5' e(chi2),  reps(1000): mlogit `v5' `v1'
				
				
				
				local pval: display cond(r(p)[1,1]<.01, string(r(p)[1,1], "%9.3fc") + "^{***}", cond(r(p)[1,1]<.05, string(r(p)[1,1], "%9.3fc") + "^{**}", cond(r(p)[1,1]<.1, string(r(p)[1,1], "%9.3fc") + "^*", string(r(p)[1,1], "%9.3fc") )))
				
				local rowojo "`rowojo'&`pval'"
		
		
		
	
	texdoc write `rowojos'\\
	
	texdoc write `rowojo'\\
	
	}
	
	local c`k' = `a`k'' - 1
	
	               
	texdoc write \bottomrule 
	texdoc write \end{tabular}
	texdoc write \end{center}
    texdoc write \vspace{-0.25cm}
	texdoc write \begin{tablenotes}
    
	
	texdoc write `foottextsize'
	
    texdoc write $footnotetext
	
	
	
    texdoc write \end{tablenotes}
	texdoc write \end{table}
	
	
	
	texdoc close 
	
	end
	
	