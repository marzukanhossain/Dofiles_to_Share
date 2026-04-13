/******************************************************************************************************************
*Title: latex_attr_analysis
*Created by: Marzuk
*Created on: Nov 14, 2024
*Last Modified on:  Nov 14, 2024
*Last Modified by: 	Marzuk
*Purpose :  Attrition Analysis after in-person survey
	
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
	
	

	

	texdoc init manuscript.tex, replace
	
	
	
	
	
	/*tex
	\documentclass[letterpaper,12pt]{article}

\usepackage{amssymb,amsmath,amsfonts,eurosym,geometry,ulem,graphicx,caption,color,setspace,sectsty,comment,caption,pdflscape,subfigure,array,nth,ragged2e,hyperref}
 
\normalem

\usepackage{geometry}
\geometry{left=1.0in,right=1.0in,top=1.0in,bottom=1.0in}
\usepackage[multiple]{footmisc}

\usepackage{bibentry}
\usepackage{adjustbox}
\usepackage{booktabs}
\usepackage{multirow}
\usepackage[flushleft]{threeparttable}
\usepackage{pdflscape}
\usepackage{rotating}
\usepackage{dcolumn}
\usepackage{color,soul}
\usepackage{float}
\usepackage{placeins}
\usepackage{longtable}
%\nobibliography*
\usepackage{import, siunitx }
%\usepackage{indentfirst}

\usepackage{makecell}


\usepackage{graphicx}
\usepackage{subcaption}
\usepackage[authoryear,sort,longnamesfirst]{natbib}
\bibliographystyle{econ}
%%alternatives apalike, ecta (econometrica)

\usepackage{xcolor}
\hypersetup{
	colorlinks,
	allcolors={blue!50!black}
}


%\onehalfspacing

\linespread{1.5}
\newtheorem{theorem}{Theorem}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}{Proposition}
\newenvironment{proof}[1][Proof]{\noindent\textbf{#1.} }{\ \rule{0.5em}{0.5em}}

\newtheorem{hyp}{Hypothesis}
\newtheorem{subhyp}{Hypothesis}[hyp]
\renewcommand{\thesubhyp}{\thehyp\alph{subhyp}}

\newcommand{\red}[1]{{\color{red} #1}}
\newcommand{\blue}[1]{{\color{blue} #1}}

\newcolumntype{L}[1]{>{\raggedright\let\newline\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\arraybackslash\hspace{0pt}}m{#1}}

 

\begin{document}
	
	\begin{titlepage}
		\title{ \textbf{Using Social Media to Train Aquaculture Farmers: Experimental
Evidence from Bangladesh}}
		\author{Marzuk A. N. Hossain,  Tahmid Bin Mahmud,  \\ Khandker Wahedur Rahman, and Munshi Sulaiman\footnote{Hossain: BRAC Institute of Governance and Development, BRAC University. Email: \href{https://bigd.bracu.ac.bd/staffprofile/marzuk-a-n-hossain/}{marzuk.hossain@bracu.ac.bd}. Mahmud: BRAC Institute of Governance and Development, BRAC University. Email: \href{https://bigd.bracu.ac.bd/staffprofile/tahmid-bin-mahmud/}{tahmid.mahmud@bracu.ac.bd}. Rahman: University of Oxford and BRAC Institute of Governance and Development, BRAC University. Email: \href{https://bigd.bracu.ac.bd/staffprofile/khandker-wahedur-rahman/}{khandkerwahedur.rahman@oxfordmartin.ox.ac.uk}. Sulaiman: BRAC Institute of Governance and Development, BRAC University. Email: \href{https://bigd.bracu.ac.bd/staffprofile/munshi-sulaiman/}{munshi.sulaiman@bracu.ac.bd}.}}
  %Authors are listed in alphabetical order. We thank people and own our mistakes.}}
		%\and John Smith\thanks{abc}%}
		\date{\today} 
    
		
		%\href{}{Click here for the latest version of this paper} 
		
		\maketitle
        \vspace{-.4in}
		\begin{abstract}
			\singlespacing{}
   			\noindent We conducted a randomized controlled trial (RCT) to evaluate the effectiveness of training aquaculture farmers in Bangladesh on how to use social networks through social media to access information. The training introduced participants to a Facebook group specifically designed to share information on fish farming, facilitate peer exchange, and serve as a digital marketplace. A telephone survey conducted two months after the intervention found that the training increased both social media use and knowledge acquisition among farmers. The effect on social media usage persisted six months after the intervention, but the impact on farming knowledge had faded. While treatment farmers were four percentage points more likely to use social media to interact with other aquaculture farmers and access trade-relevant information, representing a 25\% impact compared to the control mean,  there was no significant change in their farming practices. These findings suggest that while social media can enhance short-term knowledge sharing, translating digital learning into behavioral change may require more sustained and interactive engagement. \\
   
		%	\vspace{0in}
			\noindent\textbf{Keywords:} aquaculture, farmer training, technology, social media. \\
			% \vspace{0in}\\
			% \noindent\textbf{JEL Codes:} key1, key2, key3\\
			
			% \bigskip
		\end{abstract}
		\setcounter{page}{0}
		\thispagestyle{empty}
	\end{titlepage}
	\pagebreak \newpage
	
	
	
	
	%\doublespacing
	
	%\begin{flushleft}
    
	\section{Introduction} \label{sec:introduction}

       There are more than 4.5 million fish farmers in Bangladesh, but their productivity is much lower than that of most countries such as Vietnam, which has seen significant growth due to its government support, technological advancements, and export-oriented production \citep{faculty_of_fisheries_nong_lam_university_vietnam_overview_2022}. Most of the Bangladesh fish farmers rely primarily on personal experience or traditional family practices as their main source of knowledge about fish farming \citep{fao2025bangladesh, burbi_role_2016}. As a result, their knowledge is often limited to what is available within their immediate environment, leaving them without access to more comprehensive and up-to-date information from outside of their communities.
       
       Extension services can be effective in increasing productivity when knowledge, information, and skills related to the new technology are successfully communicated to the farmers \citep{brown_fish_2013, stoetzer_diffusion_1995}. Hence, to improve productivity, government and non-government initiatives aim to expand extension services to transfer knowledge about better farming practices and ultimately improve farmers' quality of life by increasing fish production and income \citep{anderson_agricultural_2004, nakasone_power_2014}.\footnote{Such initiatives typically include advisory services on pond preparation, feed management, water quality control, disease management, and market linkages.} However, these extension services in Bangladesh have low outreach \citep{ayisi_aquaculture_2016} as the face insufficient funding and logistical support to reach even less than 40 percent of fish farmers in the country \citep{DoF2024, mamun-ur-rashid_service_2018}. There is also a lack of training and motivation of extension service workers \citep{rahman_problems_2021}.
       
       %Therefore, social media can potentially be used as a vehicle to effectively deliver the training to farmers.

        Social media platforms such as Facebook, WhatsApp, and YouTube have been increasingly used worldwide for agricultural and aquaculture extension services \citep{de_aquaculture_2023, chowdary_role_2024}. These platforms offer better communication, access to and exchange of information on new technology and better farming practices between farmers, extension agents, and other stakeholders \citep{emmanuel_social_2024, paudel_social_2018}. Research has shown that the use of social media can improve farmers' knowledge and financial conditions \citep{elfitasari_importance_2018}. Extension agents also view social media platform as an effective medium for education, communication, and program implementation \citep{cornelisse_entrepreneurial_2011, paudel_social_2018}. Social networks have also been found to have the potential to increase farmer satisfaction with extension services \citep{singh_use_2022} and to reach remote areas, often at a cheaper cost than traditional extension services \citep{emmanuel_social_2024}. Although the use of social networks is limited by factors such as digital illiteracy, inadequate infrastructure, and limited access to devices \citep{barau_overview_2017}, its potential in Bangladesh is growing as the number of people with access to social networks continues to increase. By 2024, the use of social media in Bangladesh had increased to 30.4 percent of the total population \citep{kemp_digital_2024}.
        
         In this study, we use a randomized controlled trial (RCT) to evaluate the impact of promoting the use of a Facebook group created for Bangladeshi aquaculture farmers to access farming-related training content and connect with peers for experience-sharing and trade-related information. The evaluation was implemented in partnership with The Right Kind (TRK), a social enterprise engaged in developing and delivering the social media training and moderating the Facebook group. The RCT is conducted in three sub-districts of Rajshahi, a northern district in Bangladesh. The training provided to the farmers is a one-to-one session lasting 20-30 minutes, teaching them how to join a Facebook group (named The Right Fish, TRF hereafter) and access relevant information about fish farming on it. Facebook has become a viable platform for disseminating information about fish farming in Bangladesh as many people own mobile phones and have access to the internet, with many of them already using it as a communication medium.  

        We find that the intervention increases the use of social networks for fish-farming-related issues and farmers' knowledge in the short run (two months after the intervention ended). Despite this increase in knowledge, the treatment does not impact long-term farming practices. The treatment and control farmers behave almost similarly across different dimensions of farming practices after eight months of the intervention.

        We contribute to the literature that studies how to create access to information for farmers. Conventional extension services can be inefficient and difficult to scale due to requiring significant fixed and recurring costs for the large human resources \citep{quizon_fiscal_2001}. In-person training through multiple yearly visits can be problematic due to time and distance \citep{cole_mobileizing_2021}. Information and communication technologies (ICTs), in the face of obstacles of the traditional services, can be more useful for delivering valuable knowledge to farmers in rural areas of developing countries \citep{fabregas_realizing_2019}. \cite{issahaku_does_2018} found mobile phone ownership increasing productivity among maize farmers in Ghana. In China, mobile application-based training modules have improved the knowledge and output quality of grape farmers \citep{chua_effective_2021}. In Central Java, aquaculture farmers who were part of an online Facebook community significantly improved their knowledge and problem-solving skills \citep{elfitasari_importance_2018}. There are three primary benefits for farmers who own and use mobile phones: obtaining market information and extension services, receiving payments and inputs remotely, and saving time by avoiding travel to obtain extension services. Social media supports farmers' resilience by providing farming-related knowledge, serving as a platform for connecting with customers and marketing product \citep{daigle_perceptions_2021}. However, the evidence on the downstream impact of access to information through social media on farming practices, overall productivity and income is still inconclusive. 
      
        The rest of the paper is organized as follows: in Section \ref{sec:context}, we discuss the background of aquaculture in Bangladesh and the use of mobile/internet technology in the country, and we provide details of the intervention. Section \ref{sec:data} discusses how we collected data and describes the empirical strategy. In Section \ref{sec:findings}, we present the results of our analysis and findings and also check their robustness. Section \ref{sec:conclusion} concludes the paper.

 
	% \subsection{Literature Review} \label{sec:literature}
 %        This is here as a placeholder. The actual draft should not have a separate literature review section. 

        \section{Context} \label{sec:context}

        \subsection{Aquaculture and Extension Services}
   Aquaculture plays a significant role in the Asia-Pacific region by supporting food security, generating income and employment, and contributing to poverty reduction, thereby enhancing rural socioeconomic conditions \citep{belton_not_2017}. Asia alone accounts for 89\% of the total global fish production in terms of volume in the last 20 years \citep{fao_state_2020}. Bangladesh has positioned itself right after China and India as the third largest producer of fish captured from inland waters - producing 10\% of global production \citep{fao_state_2020}. The inland fish production stands at 57\% of the total fish production in Bangladesh, with 79\% of this inland production coming from ponds \citep{department_of_fisheries_bangladesh_yearbook_2021}.
        
        However, there is plenty of room for improvement for the fish farmers in Bangladesh, as there exists sub-optimal use of input among them \citep{khan_production_2021}. Study also find that technical know-how acquired through access to training and extension services significantly reduces this inefficiency. The adoption of new aquaculture technologies - such as improved feed and feeding methods, enhanced pond and disease management, and genetically improved fish strains - has the potential to significantly boost productivity, particularly in shrimp and tilapia farming \citep{kumar_technological_2016}. Such technology adoption also enhances efficiency in aquaculture farming, particularly in the farming of carp in several countries of Asia, including Bangladesh \citep{dey_potential_2013}. Nevertheless, the adoption of these technologies depends on whether farmers are made aware of them through channels they trust and prefer \citep{kumar_factors_2018}.
        
        \subsection{Using Social media for Extension Services}
        Social media has emerged as one such effective instrument for disseminating aquaculture extension services in Bangladesh. The most widely used online platform is Facebook, where many communities exchange information and techniques related to aquaculture \citep{islam_role_2020}. Extension agents use social media to learn about professional tasks, promote innovative practices, and disseminate agricultural knowledge \citep{kamruzzaman_extension_2018}. Farmers perceive social media as useful for gathering and generating ideas, marketing products, and engaging with customers \citep{uddin_perceptions_2023}. Digital animations on social media have demonstrated potential for quickly communicating antimicrobial resistance awareness to rural aquaculture farmers \citep{thornber_raising_2019}.
        
        Thus, social media has a significant potential for improving aquaculture information dissemination in Bangladesh - with 97.4\% of households having access to at least one mobile phone and 52.1\% of households owning a smartphone, and about one-third households having access to the internet (38.1\% of overall households; with urban households at 63.4\% and rural households at 29.7\%)\footnote{Proportion of individuals having access to the internet is at 38.9\%, where the internet usage was higher among males (45.3\%) than females (32.7\%)} \citep{bbs2023labourforce}. Among the people of Rajshahi Division of Bangladesh, the locale where this study takes place, the most popular platform for communication is Facebook, according to Table \ref{tab:baltab2}. Hence, Facebook can be an excellent medium for the dissemination of information relative to fish farming among farmers there.


        % Placing it here as we may want to provide some background of aquaculture farming in Bangladesh.
        
        %\section{Intervention} \label{sec:intervention}

        \subsection{\textit{The Right Fish} Facebook Group}
        The Right Kind (TRK) implements various projects aimed at training farmers to use social media platforms for accessing aquaculture-related information. As part of this effort, TRK has created an online community of fish farmers to facilitate knowledge sharing and peer learning. Their broader goal is to promote the diffusion of aquaculture technologies through social media. The training is delivered through brief one-on-one sessions; typically lasting less than 30 minutes, during which farmers are shown how to join the Facebook group "The Right Fish" and navigate its fish farming content. The intervention evaluated in this study centers on introducing farmers to this digital platform.

        The TRF Facebook group serves as an online community for aquaculture farmers in Bangladesh. TRK regularly shares posts on best aquaculture practices, the availability of new high-yield fish fingerling varieties, and updated price lists for various inland fish species from hatcheries. The group also hosts informational webinars. Farmers use the platform to share challenges they encounter in aquaculture, with TRK and fellow farmers offering suggestions and solutions—fostering an interactive and supportive environment. Some farmers have even used the group to trade fish fingerlings among themselves.

        TRK emphasizes that digital platforms offer a key advantage in training dissemination by overcoming geographical barriers and enabling individuals with basic digital skills to access content through their Facebook profiles at their convenience. By connecting farmers online, social media facilitates the widespread sharing of updated farming knowledge and technological innovations. Farmers can access aquaculture-specific information, exchange knowledge, and seek advice from peers and experts on the same platform. These platforms also support the sharing of critical information, such as the costs and locations of farming equipment, feeds, medicines, and available government loans. Collectively, these features enhance the agency of aquaculture farmers, enabling more informed decision-making.
 
	\section{Data and Empirical Strategy} \label{sec:data}

        \subsection{Experiment Design}
         TRK conducted an enrolment survey to recruit aquaculture farmers for the intervention during their project work; funded by USAID and WorldFish, from three sub-districts of Rajshahi (a Northern district of Bangladesh).\footnote{Durgapur, Charghat, and Bagha are the three sub-districts.} Representatives from TRK reached out to farmers in the villages with the help of local contacts. They visited farmers' homes and collected information on household smartphone availability, social media usage, aquaculture earnings and farm size. Based on this information, only aquaculture farmers with smartphones in their households were included in the final sample. Data were collected using computer-aided personal interviewing (CAPI) survey forms administered through SurveyCTO. Each form included an embedded randomization code that assigned farmers to either the treatment or control group, ensuring each farmer had a 50\% chance of being placed in either group. At the beginning of the survey, representatives informed respondents that TRK works with fish farmers and was listing farmers in the area. At the end of the selection survey, which served as our baseline, the survey form notified the representative of the farmer's group assignment. If the farmer was assigned to the treatment group, the representative proceeded with the intervention; if assigned to the control group, the survey was simply concluded.
         
         To meet the target numbers of farmers in the treatment group, we used an oversampling approach. Sample size calculation also accounted for potential attrition.\footnote{We expected to identify at least 600 treatment and 600 control farmers. We assumed a 5\% attrition rate from the enrolment survey to the follow-up surveys. This would cause the sample to have 90\% power to capture an effect larger than 9.5 percentage points for binary outcomes.} From TRK, we received data on 1,237 aquaculture farmers (628 in the treatment group and 609 in the control group) who had smartphones in their households, either owned by themselves or another household member. Only the treatment group was introduced to the restricted Facebook group, TRF, which is accessible exclusively to individuals with Facebook accounts who are added to the group. A referral is required to request access, with TRK representatives serving as references. During the baseline survey, TRK staff added treatment farmers to the group and provided instructions on how to use it. In contrast, control farmers were simply informed that the data collectors represented TRK, without receiving any information about the Facebook group. Access to TRF remains restricted to the treatment group, with field officers making referrals during the enrollment process, thereby creating an inherent barrier to spillover effects. The selection survey and intervention were rolled out together over four months, from April 6 to August 8, 2022.  
        
        \subsection{Data Collection} \label{sec:datacollection}
        We conducted two rounds of follow-up surveys to assess the impact of the intervention over time. A midline phone survey in October 2022, two months after the intervention ended and an endline in-person survey in April 2023, six months after the midline. In the midline survey, we interviewed 562 treatment and 524 control farmers via a 30-minute phone call. The midline survey was conducted after a two-month buffer to ensure that treatment farmers had sufficient time to engage with and learn from "The Right Fish" Facebook page. This survey aimed to explore how farmers used social media to acquire knowledge on various aspects of aquaculture. The overall attrition rate at this stage was 12\% compared to the baseline. Six months later, we conducted the endline survey by visiting the respondents in person. We were able to survey 515 treatment and 480 control farmers this time. This longer interval of six months was intended for us to examine sustained knowledge retention, its translation into practice, and its eventual impact on income. At the endline survey, the overall attrition rate increased to 19.5\%.

       We have three main outcomes of interest: 1) farmers' social media usage for aquaculture related purpose, 2) farmers' knowledge about good fish farming practices, 3) farmers' farming practices. We measure the first two outcomes in both survey rounds, while the last one is only measured during the in-person survey. Our analytical sample consists of respondents who were successfully interviewed in both rounds of the follow-up survey. 

        
        \subsection{Identification Strategy} 
        \label{subsec:identificationstrategy}

        %TRK, our implementation partner in this study, carries out the initial listing of the aquaculture farmers. During this process, they collect basic information about the farmers using a form generated by Computer Aided Personal Interview codes. At the end of this form, a code is added that randomly assigns the farmer being listed to treatment or control groups. The code generates a random number between 0 and 1 for each farmer. If this random number is greater than or equal to 0.5 then the farmer is assigned to the treatment group, otherwise, the person being listed is assigned to the control group.
        
            We use data from the midline and the endline survey to estimate the following regression to estimate intention-to-treat (ITT):
        \begin{equation} \label{eq:1}
           Y_{iu} = \alpha_u + \beta T_{iu} + e_{iu} 
        \end{equation}
        Here \(Y_{iu}\) is the outcome variable for individual \textit{i} as explained in the previous section and union \textit{u}; \(\alpha_u\) are the union fixed effects; \(T_{iu}\) is the indicator for being assigned to the treatment group; and \(e_{iu}\) is the error term. \(\beta\) in Equation \ref{eq:1} is the ITT effect of the social media training. We use robust standard errors to account for heteroskedasticity. 


        We use a linear two-stage least squares (2SLS) approach to estimate the Local Average Treatment Effect (LATE) of the social media training. During the endline survey, we ask if the farmers are registered in TRK Facebook group or not. To the registered farmers, we request that they demonstrate a visit to the TRF Facebook group\footnote{Among 507 registered farmers, 49.3\% have complied to demonstrate a visit to the TRF facebook group.}. We instrument the farmers' compliance to demonstrate (\(D_{iu}\)) using the assignment to the treatment group (\(T_{iu}\)) as an instrument. The estimation involves the following two equations:
        
        First Stage:
        \begin{equation} \label{eq:2}
        D_{iu} = \pi_u + \gamma T_{iu} + v_{iu}
        \end{equation}
        
        Here, \(D_{iu}\) is the indicator for farmers' compliance to demonstrate visiting TRF Facebook group for individual \(i\) in union \(u\), \(\pi_u\) are the union fixed effects, \(T_{iu}\) is the indicator for being assigned to the treatment group, and \(v_{iu}\) is the error term. The parameter \(\gamma\) captures the effect of the treatment assignment on actual participation. 
        
        Second Stage:
        \begin{equation} \label{eq:3}
        Y_{iu} = \alpha_u + \lambda \hat{D}_{iu} + \epsilon_{iu}
        \end{equation}
        
        In this equation, \(Y_{iu}\) is the outcome variable for individual \(i\) in union \(u\), \(\alpha_u\) are the union fixed effects, \(\hat{D}_{iu}\) is the predicted value of farmers' compliance to demonstrate from the first stage, and \(\epsilon_{iu}\) is the error term. The parameter \(\lambda\) represents the LATE effect of the social media training on the outcome variable. Since only a fraction of the farmers accessed the TRF group, LATE enables us to measure the impact of accessing the group influenced by the demonstration treatment. 
        

        \subsection{Sample Characteristics} \label{sec:sample}
        
      Table \ref{tab:baltab2} shows that there are no significant differences between treatment and control aquaculture farmers based on the baseline sample, as expected given the random assignment of treatment. Almost all the respondents in our sample are male farmers. They have an average age of 39 years.

        %\footnote{Here pre-school is not considered as years of education - anything below class 1 is considered to be 0 years of education. The sample consists of 0 to 12 years of education representing no education at all up to a Higher Secondary School Certificate; another 4 years of Bachelor's degree and an additional 2 years of Master's degree being the highest.}.

        Table \ref{tab:baltab2} also shows that the farmers have similar levels of assets and yearly production. On average, their ponds cover an area of about 4.8 acres. Over the year 2021-2022, these ponds produced 10 tonnes of fish, on average, earning a consequent revenue of BDT 2.03 million over the same period. 

        The farmers are similar regarding their internet usage and smartphone ownership. They spend on average BDT 384\footnote{The Purchasing Power Parity (PPP) exchange rate for Bangladeshi Taka (BDT) was BDT 91.75 and BDT 106.31 per United States Dollar (USD) in 2022 and 2023, respectively \citep{noauthor_world_nodate}.} on internet connectivity. Around 57\% of them own a smartphone by themselves and about 46\% look up fish-farming related information online. The Panel B in Table \ref{tab:baltab2} shows that the farmers or their household members are similar across treatment and control groups in using different social media platforms. Almost all of them, on average, use Facebook and YouTube at 95\% and 97\%, respectively. Quite a few of them use IMO, WhatsApp and Tiktok (at 71\%, 47\% and 37\%, respectively). However, on average, 5\%, 4\%, and 3\% of them use Instagram, Viber, and Telegram, respectively.

        

        \FloatBarrier
        \input{table2.tex}
        \FloatBarrier

            
        %Figure \ref{fig:coefplot} further illustrates the farmers' usage of different social media applications at the baseline. The coefficient plots show that, apart from YouTube, there are no statistically significant differences in social media usage among the different platforms, as all their confidence intervals overlap with the null effect (zero).

        %\FloatBarrier
        %\begin{figure} [ht]
        %\centering
        %\includegraphics[width=1.0\textwidth]{coefplot.png} 
        %\caption{Social Media Platform Usage in Baseline} \label{fig:coefplot}
        %\end{figure}
        %\FloatBarrier


        \subsection{Attrition}

        Since we have 12\% and 19.5\% attrition at midline phone survey and endline in-person survey, respectively, it is important to discuss attrition in the context of treatment, and whether attrition is systematic in this study. First, we checked if the likelihood of dropping out has any correlation with being assigned to treatment. Table \ref{tab:attr} shows that the impact on attrition due to being assigned as treatment is statistically insignificant. Then, we controlled for various covariates (namely the baseline characteristics) and still found no significant impact. The same was the case when controlled for an interaction term of treatment and the covariates. Therefore, attrition is not systematic in this research. Consequently, the baseline characteristics across treatment and control groups remain the same even after the attrition, as shown in Table \ref{tab:baltab3}.
        
        \FloatBarrier
        \input{table_attr.tex} 
        \FloatBarrier
     
        \section{Findings and Discussion} \label{sec:findings}
        
        %We find that the training has prompted the treatment group to use social media (TRF Facebook group) to interact with other fish farmers, gather information regarding aquaculture, and improve knowledge on some farming practices. Table \ref{tab:R1.1} shows that the training increased the likelihood of using social media about aquaculture farming by six percentage points.\footnote{Table \ref{tab:AR1.1} shows the results for all the phone-survey sample.} 
        
        %In addition, the intervention affects the trade of information through social media more than that of goods relevant to fish farming. We find that the impact of the training on the likelihood of reading posts (an increase of more than ten percentage points) is larger than that on making such posts (an increase of 5 percentage points) which in turn is larger than trading fish fingerlings online (a three percentage points increase) shown in Figure \ref{fig:R1.1}. The impact of the intervention on receiving information through social media suggests that such intervention may complement the traditional extension/outreach activities for aquaculture farmers, by providing a more accessible medium for such activities. 

        %While the intervention increased the likelihood of acquiring knowledge about fish farming from online posts in both static (including written posts, infographics, pictures or any combination of them) and video form by one percentage point, it had a much larger impact for static posts alone --- increasing the likelihood to 10 percentage points as shown in Table \ref{tab:R1.1}. This suggests that disseminating knowledge through social media posts is more effective when presented in static form. 
        
        %Additionally, we test for heterogeneity in impact among the farmers who own smartphones themselves. We find such heterogeneity only in social media usage. These findings indicate the form in which information is readily accepted and retained among the farmers.

        %The analysis from the in-person survey complements the phone survey findings. Table \ref{tab:R2.1} shows  that even in the long run (over a period of at least six months), the impact of the intervention on social media usage and knowledge acquisition from static posts is sustained. The social media training recipients are significantly more likely (by four percentage points) to use social media to interact with other aquaculture farmers and gather knowledge relevant to their trade. They are also significantly more likely (by six percentage points) to acquire such knowledge from static posts. However, there is no significant impact on the practices of the farmers shown in Table \ref{tab:R2.2}, indicating that the knowledge is not being translated into practice.  

        This section discusses the impact of our intervention on aquaculture farmers' social media usage, aquaculture knowledge acquisition and farming practices. We present our findings from both our midline phone survey and the endline in-person survey, which are further disaggregated into ITT and LATE estimates. 
        
        %ITT measures the average treatment effect based on the initial random assignment to the treatment group, regardless of whether participants fully complied with the intervention. This gives a more reserved estimate of the intervention's impact, reflecting real-world scenarios in which not all participants comply with the treatment. Local Average Treatment Effect (LATE) captures the treatment effect among compliers only, those participants who followed the intervention as planned. It provides a more focused estimate for those who received the treatment as intended.

        \subsection{Impact on Social Media Usage}

        The intervention significantly increased the likelihood of farmers using social media for aquaculture-related activities. From Table \ref{tab:pp_uptake}, ITT estimate at midline reveals that aquaculture farmers in the treatment group were 6.1 percentage points more likely to use social media compared to the control group. Although this effect reduced slightly to 4.1 percentage points at endline, it remains statistically significant and translates to 25\% increase compared to the control group mean. The effect on compliers was much larger, as the LATE results show social media usage increasing by 27.4 and 18.8 percentage points at midline and endline, respectively. This implies that the impact is four times more pronounced on the farmers who comply.

        These findings indicate that the training successfully encouraged farmers to use social media for aquaculture-related purposes, especially those who fully complied with the intervention. However, the slight decrease in effect size over time suggests that there are challenges in sustaining this engagement. This emphasizes the need to develop trainings that offer continued incentives or support for long-term use.

        \FloatBarrier
        \input{table_pp_uptake} 
        \FloatBarrier        


        \subsection{Impact on Knowledge}

        The intervention also positively impacted farmers' knowledge of best aquaculture practices in the short run, although quite modestly. In Table \ref{tab:pp_knowledge}, ITT estimates reveal a 1 percentage point increase in knowledge at midline for treatment farmers compared to the control group. Among those who complied with the intervention, this effect was higher as LATE estimates showed a 4.4 percentage point increase. However, this knowledge acquisition was not sustained, as no significant impact was detected at endline.

        The initial improvements indicate that social media platforms can be effective for short-term knowledge dissemination. The dissipation of these effects by the endline might be revealing of some wider challenges such as difficulties in accessing the contents online or retaining the knowledge over time. Future training mediated through social media will need to address this concern either through periodic nudges or by developing more engaging content.

        \FloatBarrier
        \input{table_pp_knowledge}
        \FloatBarrier
        
        \subsection{Impact on Aquaculture Practices}

        Although there have been significant impacts on social media usage and short-term knowledge gains, the intervention did not lead to notable changes in aquaculture farming practices. As illustrated in Table \ref{tab:practice}, neither ITT nor LATE estimates have shown any meaningful impacts on overall farming practices. The indexes PI\(_1\) - PI\(_4\) in Table \ref{tab:practice} are constructed by asking specific questions related to good farming practices at different stages of fish farming, with their values being either 0 (if the practice is not adhered to) or 1 (if the practice is followed) and then dividing the summation of these values with the number of questions in each index. Looking into these specific indices of farming practices in Table \ref{tab:practice}, we see no significant impacts on practices such as pond preparation, fry management, or the application of lime and fertilizers. This reveals a disconnect between knowledge acquired and behavioural change.

        There are many possible factors which may explain this divide. Limited financial resources, lack of good quality inputs, or traditional aquaculture practices and habits might have prevented farmers from implementing the new practices. Moreover, the intervention's low-touch model and short duration may have been insufficient for farmers to garner enough interest to adopt and internalize the new practices.

        %\FloatBarrier
        %\input{table_practice_ippr} 
        %\FloatBarrier


        \FloatBarrier
        \input{table_practice} 
        \FloatBarrier

        
        %\FloatBarrier
        %\begin{table}[]
        %\begin{center}
        %\caption{Impact on Farming Practices}
        %\label{tab:R2.2}
        %\begin{tabular}{@{}lccccc@{}}
        %\toprule
        %             & (1)     & (2)     & (3)     & (4)     & (5)     \\ 
         %            & PI\(_1\)     & PI\(_2\)     & PI\(_3\)     & PI\(_4\)     & PI\(_5\)     \\ \midrule
      %  Treatment    & -0.018  & -0.013  & 0.003   & -0.003  & -0.002  \\
       %              & (0.011) & (0.013) & (0.009) & (0.010) & (0.007) \\
        %             &         &         &         &         &         \\
        %Control Mean & 0.747   & 0.872   & 0.423   & 0.839   & 0.575   \\
        %Observations & 992     & 992     & 992     & 992     & 992     \\ \bottomrule
        %\end{tabular}
        %\end{center}
        %\begin{tablenotes} 
         %     \item Notes: Robust standard errors in parentheses and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_{iu} = \alpha_u + \beta T_{iu} + e_{iu}\) where \(Y_{iu}\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_{iu}\) is the indicator for being assigned to the treatment group; and \(e_{iu}\) is the error term.
          %    \newline PI\(_1\) is the practice index for pond preparation.
           %   \newline PI\(_2\) is the practice index for management while releasing fish fry.
           %   \newline PI\(_3\) is the practice index for management after releasing the fish fry.
            %  \newline PI\(_4\) is the practice index for the application of lime and fertilizers.
             % \newline PI\(_5\) is the practice index for all combined farming practices.
            %\end{tablenotes}
        %\end{table}
        %\FloatBarrier

       
        \subsection{Robustness of Results}

        We explored further to unearth some understanding as to why the intervention did not result in any significant impact on aquaculture practices. We looked into the correlation between social media usage, knowledge, and farming practices among aquaculture farmers. A strong positive correlation (with coefficient 0.58) was found between farming practice and knowledge as shown in Figure \ref{fig:pracknow}, however, Figure \ref{fig:knowsmu} shows that there exists a very weak correlation (with coefficient 0.32) between social media usage and knowledge. This explains our findings, as it was found in the in-person survey that recipients of social media training are significantly more likely (by four percentage points) to use social media for fish farming-related purposes, but its impact on knowledge of best aquaculture practices diminishes in the long-run since they are weakly correlated. Had the intervention resulted in a significant impact on knowledge in the long run, it could have led to a significant impact on practice, for those share a strong correlation.

        Next, We investigated potential influence of spillover effects of the intervention on the control group as that would create a downward bias to our impact estimates. We calculated distance between each control respondent and their closest treatment (using GPS coordinates with a straight-line distance) and ran the regression of the knowledge and social media usage variables on this proximity variable for the control group, shown in Table \ref{tab:spillover}. The assumption is - in case of significant spillover effects, control group farmer who live closer to treatment group are more likely to be affected. However, we do not find any significant correlation between proximity to treatment group farmers and the outcome variables. As an alternative measure of proximity to treatment, We also examined if the social media usage and the knowledge gained in the control sample varied significantly if there were more treatment respondents within a 100m distance from the control farmers (Table \ref{tab:spillover}). We find that this was not the case either. 

        Overall, since only 4\% of the farmers (Table \ref{tab:pp_uptake}) sustained the habit of looking up aquaculture-related information online, this was too low of a long-term behavioural change from our intervention to cause any significant impact on farming practices. 
        
        
        \begin{figure} [ht]
        \centering
        \includegraphics[width=0.9\textwidth]{practice_know_corr.png} 
        \caption{Correlation between farming practice and knowledge} \label{fig:pracknow}
        \end{figure}


        \begin{figure} [H]
        \centering
        \includegraphics[width=0.9\textwidth]{know_smu_corr.png} 
        \caption{Correlation between knowledge and social media usage} \label{fig:knowsmu}
        \end{figure}
	%\section{Discussions} \label{sec:discussion}
	
	\section{Conclusion} \label{sec:conclusion} 

        % While providing farmers with up-to-date information and training them is important, they come with many challenges. Extension services provide this support, but they incur high costs. ICT provides an alternative, but there is much yet to unpack about how ICT can be leveraged in this regard. 

        % We conduct an RCT among fish farmers in Bangladesh to assess the impact of providing access to a social media network on the farmers' usage, knowledge, and practices. Farmers are more likely to use social media because of the training and their knowledge increases - both impacts sustaining for at least eight months. We do not find an increase in farming practices. 

        % While the lack of uptake in farming practices is disappointing, it is encouraging to see that such intervention can increase knowledge --- that is, ICT can reduce the knowledge gap. For future research, we need to focus on why ICT-transmitted knowledge is not being translated into practice and under what conditions that will happen in Table \ref{tab:0}. 
        It is crucial to provide farmers with up-to-date information, and one such way to achieve that is through extension services. In-person extension services are usually expensive and ICT can provide a viable alternative. We conduct an RCT among fish farmers in Bangladesh to assess the impact of providing access to a social media network on the farmers' usage, knowledge, and practices. Our findings highlight that social media platforms can be potentially used as complementary tools for agricultural extension services, especially in cases where conventional approaches face logistical or financial constraints. The success of the intervention in increasing social media usage for aquaculture-related purposes and initial knowledge acquisition indicates that digital platforms can effectively disseminate information to rural farmers.

        However, we have not found any significant increase in farming practices from our digitally mediated training. This highlights the need for a comprehensive approach to aquaculture training where digital interventions should be combined with tools that facilitate its application - such as providing access to necessary resources, offering personalised recommendations, or incorporating interactive and problem-solving elements in the content. It is also crucial to offer periodic nudges to farmers to ensure sustained engagement with the content online. Given the significant association that we observe between knowledge and practices, it might be worth exploring alternative way to use digital means to influence improving farming practices in other mechanisms that are more related to behavioural constraints.  


    \section*{Acknowledgement}    
	We thank Zunaid Rabbani and his team at The Right Kind for their invaluable efforts in implementing the intervention. We also thank Md. Abdul Awal and his team at BIGD for their dedicated assistance in data collection. We are grateful to our anonymous funder for funding this research study. We own any errors. We received the Institutional Review Board approval (IRB-12 September'22-034) from BRAC James P Grant School of Public Health, BRAC University.
	
	\singlespacing
	\setlength\bibsep{0pt}
	
	
	\bibliography{references}

        %\end{flushleft}


	\clearpage
	

        \singlespacing
        \setcounter{section}{0}
        \renewcommand{\thesection}{\Alph{section}} 



        \section{Appendix}\label{sec:Appendix}

        
        \setcounter{page}{1}
        \renewcommand{\thepage}{A\arabic{page}} 

       

        \setcounter{table}{0}
	\renewcommand{\thetable}{A\arabic{table}}

        \FloatBarrier
        \input{table3.tex}
        \FloatBarrier

        \FloatBarrier
        \input{table_robust.tex}
        \FloatBarrier





        \clearpage

    
	\onehalfspacing
	
	%\section*{Tables} \label{sec:tab}
	%\addcontentsline{toc}{section}{Tables}
%\input{table2.tex} \label{tab:baltab}
%\input{analysis_tab.tex} \label{tab:02}
%\input{table_pp_uptake} \label{tab:tabsmu}
%\input{table_pp_knowledge} \label{tab:tabkn}
%\input{table_practice_ippr} \label{tab:tabprac}

% Please add the following required packages to your document preamble:
% \usepackage{booktabs}

% Please add the following required packages to your document preamble:
% \usepackage{booktabs}
%\begin{table}[]
%\caption{Impact from Phone Survey}
%\label{tab:R1.1}
%\begin{tabular}{@{}lcccc@{}}
%\toprule
 %              & (1)          & (2)            & (3)            & (4)       \\ 
  %             & Social media & Knowledge from & Knowledge from & Knowledge \\
   %            & usage        & video posts    & static posts   &           \\ \midrule
%Treatment      &\hspace{5mm} 0.060***     & 0.006          & \hspace{5mm} 0.103***       &\hspace{2.5mm} 0.010**   \\
 %              & (0.013)      & (0.004)        & (0.020)        & (0.005)   \\
  %             &              &                &                &           \\
%Control   Mean & 0.130        & 0.491          & 0.247          & 0.481     \\
%Observations   & 992          & 992            & 992            & 992       \\ \bottomrule
%\end{tabular}
%\begin{tablenotes} 
 %     \item Notes: Robust standard errors in parentheses and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_i_u = \alpha_u + \beta T_i_u + e_i_u\) where \(Y_i_u\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_i_u\) is the indicator for being assigned to the treatment group; and \(e_i_u\) is the error term. The study sample is used.
  %  \end{tablenotes}
%\end{table}

% Please add the following required packages to your document preamble:
% \usepackage{booktabs}
%\begin{table}[]
%\centering
%\caption{Impact from In-person Survey}
%\label{tab:R2.1}
%\begin{tabular}{@{}lcccc@{}}
%\toprule
%             & (1)          & (2)            & (3)            & (4)       \\ 
%             & Social media & Knowledge from & Knowledge from & Knowledge \\
%             & usage        & video posts    & static posts   &           \\ \midrule
%Treatment    & \hspace{5mm} 0.041***     & 0.000          & \hspace{2.5mm} 0.055**        & 0.000     \\
%             & (0.014)      & (0.004)        & (0.022)        & (0.004)   \\
%             &              &                &                &           \\
%Control Mean & 0.165        & 0.410          & 0.349          & 0.410     \\
%Observations & 992          & 992            & 992            & 992       \\ \bottomrule
%\end{tabular}
%\begin{tablenotes} 
 %     \item Notes: Robust standard errors in parentheses and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_i_u = \alpha_u + \beta T_i_u + e_i_u\) where \(Y_i_u\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_i_u\) is the indicator for being assigned to the treatment group; and \(e_i_u\) is the error term.
 %   \end{tablenotes}
%\end{table}

% Please add the following required packages to your document preamble:
% \usepackage{booktabs}
% \begin{table}[]
% \begin{center}
% \caption{Impact on Farming Practices}
% \label{tab:R2.2}
% \begin{tabular}{@{}lccccc@{}}
% \toprule
%              & (1)     & (2)     & (3)     & (4)     & (5)     \\ 
%              & PI\(_1\)     & PI\(_2\)     & PI\(_3\)     & PI\(_4\)     & PI\(_5\)     \\ \midrule
% Treatment    & -0.018  & -0.013  & 0.003   & -0.003  & -0.002  \\
%              & (0.011) & (0.013) & (0.009) & (0.010) & (0.007) \\
%              &         &         &         &         &         \\
% Control Mean & 0.747   & 0.872   & 0.423   & 0.839   & 0.575   \\
% Observations & 992     & 992     & 992     & 992     & 992     \\ \bottomrule
% \end{tabular}
% \end{center}
% \begin{tablenotes} 
%       \item Notes: Robust standard errors in parentheses and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_i_u = \alpha_u + \beta T_i_u + e_i_u\) where \(Y_i_u\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_i_u\) is the indicator for being assigned to the treatment group; and \(e_i_u\) is the error term.
%       \newline PI\(_1\) is the practice index for pond preparation.
%       \newline PI\(_2\) is the practice index for management while releasing fish fry.
%       \newline PI\(_3\) is the practice index for management after releasing the fish fry.
%       \newline PI\(_4\) is the practice index for the application of lime and fertilisers.
%       \newline PI\(_5\) is the practice index for all combined farming practices.
%     \end{tablenotes}
% \end{table}

	%\clearpage
	
	%\section*{Figures} \label{sec:fig}
	%\addcontentsline{toc}{section}{Figures}
	
	%\begin{figure}[hp]
	 % \centering
	 % \includegraphics[width=1.1\textwidth]{Impact1.png}
	 % \caption{Likeliness of social media usage and knowledge aquisition}
	 % \label{fig:R1.1}
	%\end{figure}
	
	
	
\begin{comment}	
	%\clearpage
        
        \setcounter{section}{0}
        \renewcommand{\thesection}{\Alph{section}} 
	
	
	\section{Appendix Tables}\label{sec:AppendixTables} %%Appendix A
	\setcounter{table}{0}
	\renewcommand{\thetable}{A\arabic{table}}
\begin{table}[h!]
\caption{Impact from Phone Survey : Entire Phone-Survey Sample}
\label{tab:AR1.1}
\begin{tabular}{@{}lcccc@{}}
\toprule
               & (1)          & (2)            & (3)            & (4)       \\ 
               & Social media & Knowledge from & Knowledge from & Knowledge \\
               & usage        & video posts    & static posts   &           \\ \midrule
Treatment      & \hspace{5mm} 0.057***     & 0.006          & \hspace{5mm} 0.100***       & \hspace{2.5mm} 0.010**   \\
               & (0.012)      & (0.004)        & (0.019)        & (0.004)   \\
               &              &                &                &           \\
Control   Mean & 0.129        & 0.490          & 0.249          & 0.479     \\
Observations   & 1083         & 1083           & 1083           & 1083      \\ \bottomrule
\end{tabular}
\begin{tablenotes} 
      \item Notes: Robust standard errors in parentheses and *, **, and *** represent significance levels of 10\%, 5\%, and 1\% respectively. The regression equation is \(Y_{iu} = \alpha_u + \beta T_{iu} + e_{iu}\) where \(Y_{iu}\) is the outcome variable for individual \textit{i} and union \textit{u}; \(\alpha_u\) is the union fixed effects; \(T_{iu}\) is the indicator for being assigned to the treatment group; and \(e_{iu}\) is the error term. Sample of phone survey is used.
    \end{tablenotes}
\end{table}



\input{table_attr.tex} \label{tab:attr}

\end{comment}


 %\clearpage
%	
	%\section{Appendix Figures}\label{sec:AppendixFigures} %%Appendix B
%	\setcounter{figure}{0}
%	\renewcommand{\thefigure}{A\arabic{figure}}

 \clearpage
	
%	\section{Placeholder} 
	 
	
	
	
\end{document}
tex*/