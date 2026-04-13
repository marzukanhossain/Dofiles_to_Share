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
	
	

	

	texdoc init references.bib, replace
	
	
	
	
	
	/*tex
	

@techreport{bbs2023labourforce,
  author      = {{Bangladesh Bureau of Statistics}},
  title       = {Report on Labour Force Survey 2022},
  institution = {Statistics and Informatics Division, Ministry of Planning},
  year        = {2023},
  url         = {https://bbs.portal.gov.bd/sites/default/files/files/bbs.portal.gov.bd/page/b343a8b4_956b_45ca_872f_4cf9b2f1a6e0/2023-07-09-09-26-e60a80d559ab625529faa94185d8f4e3.pdf},
  urldate     = {2025-04-21},
  note        = {Accessed April 21, 2025}
}


@misc{kemp_digital_2024,
	title = {Digital 2024: {Bangladesh}},
	url = {https://datareportal.com/reports/digital-2024-bangladesh},
	journal = {Datareportal},
	author = {Kemp, Simon},
	month = feb,
	year = {2024},
}

@article{ayisi_aquaculture_2016,
	title = {Aquaculture extension services: {A} case study of fish farms in the eastern region of {Ghana}},
	volume = {4},
	journal = {International Journal of Fisheries and Aquatic Studies},
	author = {Ayisi, Christian Larbi and Alhassan, Elliot Haruna and Addo, Dorcas and Agyei, Benjamin Osae and Apraku, Andrews},
	year = {2016},
	pages = {24--30},
}


@article{rahman_problems_2021,
	title = {Problems faced by the crop farmers related to extension services provided by department of agricultural extension in {Bangladesh}},
	volume = {9},
	copyright = {https://creativecommons.org/licenses/by-nc/4.0},
	issn = {2311-6110, 2311-8547},
	url = {https://esciencepress.net/journals/index.php/IJAE/article/view/3606},
	doi = {10.33687/ijae.009.03.3606},
	abstract = {The Department of Agricultural Extension (DAE) has a long history of providing extension services to Bangladesh's crop farmers. This study attempted to explore the extent of problems that crop farmers faced regarding acquiring the extension services provided by DAE. This study was conducted in three villages of Gauripur Upazila (sub-district) in Mymensingh district, Bangladesh. A face-to-face interview was conducted with 100 sampled farmers for the data collection on a pre-tested and structured interview schedule. The key variable, named as the extent of problems was measured using a 4-point rating scale. Both enter and step-wise regression models were employed on the data. Results indicated that half of the respondents faced a moderate level of problems while 40\% faced a high level of problems. The extension workers' poor communication skill was the most critical issue, followed by insufficient resources and maintaining contact with resource-rich farmers as perceived by the respondents. Crop farmers' education, perceived economic return, the experience of participating in extension activities, training, and fatalism were significantly associated with the problems faced by them. Education, perceived economic return, the experience of participating in extension activities, and training were discovered to be essential determinants of the degree of problems related to extension services. The study identified several chances for the policymakers to address influential factors for improving crop extension services of DAE. Furthermore, improved coordination and providing crop farmers with need-based training and resources may help mitigate the identified issues.},
	number = {3},
	urldate = {2025-04-21},
	journal = {International Journal of Agricultural Extension},
	author = {Rahman, Saifur and Hoque, Mohammad J. and Uddin, Mohammed N.},
	month = dec,
	year = {2021},
	pages = {373--388},
}

@misc{DoF2024,
  author       = {{Department of Fisheries}},
  title        = {Department of Fisheries Overview},
  year         = {2024},
  url          = {https://fisheries.gov.bd/site/page/43ce3767-3981-4248-99bd-d321b6e3a7e5/},
  note         = {Accessed: 2025-05-19}
}


@article{mamun-ur-rashid_service_2018,
	title = {Service quality of public and private agricultural extension service providers in {Bangladesh}},
	volume = {22},
	issn = {2408-6851, 1119-944X},
	url = {https://www.ajol.info/index.php/jae/article/view/173838},
	doi = {10.4314/jae.v22i2.13},
	number = {2},
	urldate = {2025-04-21},
	journal = {Journal of Agricultural Extension},
	author = {Mamun-ur-Rashid, Md and Gao, Qijie and Alam, Oliul},
	month = jun,
	year = {2018},
}

@inproceedings{faculty_of_fisheries_nong_lam_university_vietnam_overview_2022,
	title = {{AN} {OVERVIEW} {OF} {AQUACULTURE} {DEVELOPMENT} {IN} {VIET} {NAM}},
	url = {https://tiikmpublishing.com/data/conferences/doi/icfa/10.1750123861282.2021.7105.pdf},
	doi = {10.17501/23861282.2021.7105},
	urldate = {2025-04-21},
	booktitle = {Proceedings of {International} {Conference} on {Fisheries} and {Aquaculture}},
	publisher = {The International Institute of Knowledge Management},
	author = {Tri, N. N. and Tu, N. P. C. and Nhan, D. T. and Tu, N. V.},
    organization = {Faculty of Fisheries, Nong Lam University, Vietnam},
	month = jan,
	year = {2022},
	pages = {53--71},
}

@misc{fao2025bangladesh,
  author       = {FAO},
  title        = {Bangladesh. Text by Gias, U.A.},
  year         = {2025},
  howpublished = {\url{https://www.fao.org/fishery/en/countrysector/naso_bangladesh}},
  note         = {In: Fisheries and Aquaculture.},
  institution  = {Food and Agriculture Organization of the United Nations}
}


@article{fabregas_realizing_2019,
	title = {Realizing the potential of digital development: {The} case of agricultural advice},
	volume = {366},
	issn = {0036-8075, 1095-9203},
	shorttitle = {Realizing the potential of digital development},
	url = {https://www.science.org/doi/10.1126/science.aay3038},
	doi = {10.1126/science.aay3038},
	abstract = {Mobile farming advice
            
              Mobile phones are almost universally available, and the costs of information transmission are low. They are used by smallholder farmers in low-income countries, largely successfully, to optimize markets for their produce. Fabregas
              et al.
              review the potential for boosting mobile phone use with smartphones to deliver not only market information but also more sophisticated agricultural extension advice. GPS-linked smartphones could provide locally relevant weather and pest information and video-based farming advice. But how to support the financial requirements of such extension services is less obvious, given the unwieldiness of government agencies and the vested interests of commercial suppliers.
            
            
              Science
              , this issue p.
              eaay3038
            
          , 
            
              BACKGROUND
              Sustainably raising agricultural productivity for the 2 billion people living in smallholder farming households in the developing world is critical for reducing world poverty and meeting rising food demand in the face of climate change. Nevertheless, most smallholder farmers have no access to science-based agricultural advice. The widespread adoption of basic mobile phone technology presents opportunities to improve upon existing in-person agricultural extension efforts that are expensive and fraught with accountability problems.
            
            
              ADVANCES
              Meta-analyses suggest that the transmission of agricultural information through mobile technologies in sub-Saharan Africa and India increased yields by 4\% and the odds of adoption of recommended agrochemical inputs by 22\%. The delivery of market information can have additional system-wide impacts, reducing price dispersion and lowering transaction costs. Given the low and rapidly declining cost of information transmission, benefits likely exceed costs by an order of magnitude. Even basic phones and inexpensive text and voice messages can influence farmer behavior. Smartphones with GPS systems create the potential for larger gains through the transmission of more sophisticated media, such as videos, and for locally customized information on soil characteristics, weather, and pest outbreaks, delivered at the appropriate time during the agricultural season.
              Messages could be customized on the basis of farmer characteristics, such as education or financial circumstances. Experimentation, machine learning, and two-way communication with and between farmers could facilitate improvements of information and other services over time. Advances from behavioral science can improve information transmission and address behavioral barriers to the adoption of improved agricultural techniques. Mobile phone–based systems could increase the productivity and accountability of in-person extension agents and enhance supply chain functionality. Realizing the potential of digital agriculture will require an interdisciplinary effort to develop and rigorously test a variety of approaches, incorporating insights from behavioral science, agriculture, economics, and data science.
            
            
              OUTLOOK
              Multiple market failures associated with information markets limit the ability of mobile phone–based extension systems to reach socially efficient scale through purely commercial financing. Because the marginal costs of disseminating information are close to zero, the optimal scale of such systems is very large. However, fixed system development costs still must be covered. Multiple organizations have introduced digital agricultural extension systems with financial models based on selling subscriptions to individual farmers, but such systems have been able to reach only a small fraction of farmers in the developing world. Farmer payments may be insufficient to cover the fixed costs, because information is difficult to exclude from nonpurchasers and because it is challenging for farmers to verify the quality of the information. Existing evidence suggests substantial gaps between farmers' willingness to pay for information and its social value. Advertising or agrochemical input sales could be used to finance information provision, but this approach could incentivize providers to distort information content in the absence of strong reputational costs of misinformation or appropriate regulation.
              Public financing could cover fixed costs and enable scale-up. Although agriculture ministries often deliver messages in ways that farmers find difficult to understand and use, recent examples suggest that if feedback mechanisms are in place, governments can improve their services over time. Models that incentivize farmers to share their experiences create scope for customization and efficiency gains as systems grow, because this data may be used to improve recommendations for other farmers. If successful, digital agricultural advisory systems could supply a model for digital development more broadly.
              
                
                  Mobile phones can benefit farmers in low- and middle-income countries by improving access to agricultural advice and market price information.
                  Mobile technologies, particularly smartphones, have the potential to bring sophisticated science-based agricultural advice to smallholder farmers to improve productivity, especially under rapidly changing economic and environmental conditions. However, market failures likely preclude efficient scaling of valuable digital advice applications.
                
                
                PHOTO: JAKE LYELL/ALAMY STOCK PHOTO
              
            
          , 
            The rapid spread of mobile phones creates potential for sustainably raising agricultural productivity for the 2 billion people living in smallholder farming households. Meta-analyses suggest that providing agricultural information via digital technologies increased yields by 4\% and the odds of adopting recommended inputs by 22\%. Benefits likely exceed the cost of information transmission by an order of magnitude. The spread of GPS-enabled smartphones could increase these benefits by enabling customized information, thus incentivizing farmers to contribute information to the system. Well-known distortions in markets for information limit the ability of such systems to reach the socially efficient scale through purely commercial means. There is a clear role for public support for digital agricultural extension, but messages designed by agricultural ministries are often difficult for farmers to understand and use. Realizing the potential of mobile communication systems requires feedback mechanisms to enable rigorous testing and continuous improvement.},
	language = {en},
	number = {6471},
	urldate = {2023-05-16},
	journal = {Science},
	author = {Fabregas, Raissa and Kremer, Michael and Schilbach, Frank},
	month = dec,
	year = {2019},
	pages = {eaay3038},
}

@article{quizon_fiscal_2001,
	title = {Fiscal {Sustainability} of {Agricultural} {Extension}: {The} {Case} of the {Farmer} {Field} {School} {Approach}},
	volume = {8},
	issn = {10770755},
	shorttitle = {Fiscal {Sustainability} of {Agricultural} {Extension}},
	url = {https://www.aiaee.org/vol-81-spring-01/283-fiscal-sustainability-of-agricultural-extension-the-case-of-the-farmer-field-school-approach.html},
	doi = {10.5191/jiaee.2001.08102},
	number = {1},
	urldate = {2023-05-16},
	journal = {Journal of International Agricultural and Extension Education},
	author = {Quizon, Jaime and Feder, Gershon and Murgai, Rinku},
	year = {2001},
}

@article{noauthor_notitle_nodate,
}

@article{cole_mobileizing_2021,
	title = {`{Mobile}'izing {Agricultural} {Advice} {Technology} {Adoption} {Diffusion} and {Sustainability}},
	volume = {131},
	issn = {0013-0133, 1468-0297},
	url = {https://academic.oup.com/ej/article/131/633/192/5867759},
	doi = {10.1093/ej/ueaa084},
	abstract = {Abstract
            Mobile phones promise to bring the ICT revolution to previously unconnected populations. A two-year study evaluates an innovative voice-based ICT advisory service for smallholder cotton farmers in India, demonstrating significant demand for, and trust in, new information. Farmers substantially alter their sources of information and consistently adopt inputs for cotton farming recommended by the service. Willingness to pay is, on average, less than the per-farmer cost of operating the service for our study, but likely exceeds the cost at scale. We do not find systematic evidence of gains in yields or profitability, suggesting the need for further research.},
	language = {en},
	number = {633},
	urldate = {2023-05-16},
	journal = {The Economic Journal},
	author = {Cole, Shawn A and Fernando, A Nilesh},
	month = feb,
	year = {2021},
	pages = {192--219},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\7IXZ6BVN\\Cole and Fernando - 2021 - `Mobile'izing Agricultural Advice Technology Adopt.pdf:application/pdf},
}

@article{anderson_agricultural_2004,
	title = {Agricultural {Extension}: {Good} {Intentions} and {Hard} {Realities}},
	volume = {19},
	issn = {1564-6971},
	shorttitle = {Agricultural {Extension}},
	url = {https://academic.oup.com/wbro/article-lookup/doi/10.1093/wbro/lkh013},
	doi = {10.1093/wbro/lkh013},
	language = {en},
	number = {1},
	urldate = {2023-05-16},
	journal = {The World Bank Research Observer},
	author = {Anderson, J. R.},
	month = mar,
	year = {2004},
	pages = {41--60},
}

@article{nakasone_power_2014,
	title = {The {Power} of {Information}: {The} {ICT} {Revolution} in {Agricultural} {Development}},
	volume = {6},
	issn = {1941-1340, 1941-1359},
	shorttitle = {The {Power} of {Information}},
	url = {https://www.annualreviews.org/doi/10.1146/annurev-resource-100913-012714},
	doi = {10.1146/annurev-resource-100913-012714},
	abstract = {We review the state of information and communication technologies (ICTs) and their impact on agricultural development in developing countries, documenting the rapid changes that have taken place over the past decade. Although there remains a wide gap in access between rural and urban areas, the spread of mobile phones in rural areas has led to important changes in the agricultural sector. We find that access to mobile phones has generally improved agricultural market performance at the macro level; however, impacts at the micro level are mixed. Evidence regarding the impact of market information systems (MIS) delivered through mobile phones on farm prices and income is limited, but the evidence points to strong, heterogeneous impacts. Similarly, the rollout of extension programs though ICTs is still in an early stage, and little research is available regarding such programs' impacts.},
	language = {en},
	number = {1},
	urldate = {2023-05-16},
	journal = {Annual Review of Resource Economics},
	author = {Nakasone, Eduardo and Torero, Maximo and Minten, Bart},
	month = nov,
	year = {2014},
	pages = {533--550},
}

@inproceedings{chua_effective_2022,
	title = {Effective training through a mobile app: {Evidence} from a randomized field experiment.},
	url = {10.22004/ag.econ.312907},
	author = {Chua, Kenn and Li, Qingxiao and Rahman, Khandker Wahedur and Yang, Xiaoli},
	year = {2022},
}

@article{daigle_perceptions_2021,
	title = {Perceptions of {Social} {Media} {Use} {Among} {U}.{S}. {Women} {Farmers}},
	volume = {105},
	issn = {1051-0834},
	url = {https://newprairiepress.org/jac/vol105/iss1/6},
	doi = {10.4148/1051-0834.2346},
	language = {en},
	number = {1},
	urldate = {2023-05-14},
	journal = {Journal of Applied Communications},
	author = {Daigle, Kerry and Heiss, Sarah Noel},
	month = feb,
	year = {2021},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\PLX6LYBL\\Daigle and Heiss - 2021 - Perceptions of Social Media Use Among U.S. Women F.pdf:application/pdf},
}

@article{brown_fish_2013,
	title = {Fish farmer field school: towards healthier milkfish/shrimp polyculture and fish farmer empowerment in {South} {Sulawesi}},
	volume = {18},
	issn = {0859-600X},
	url = {https://enaca.org/?id=404},
	number = {2},
	journal = {Aquaculture Asia Magazine},
	author = {Brown, Ben and Fadillah, Ratna},
	year = {2013},
	pages = {12 --19},
}

@article{burbi_role_2016,
	title = {The role of {Internet} and social media in the diffusion of knowledge and innovation among farmers},
	url = {http://rgdoi.net/10.13140/RG.2.1.4290.4567},
	doi = {10.13140/RG.2.1.4290.4567},
	language = {en},
	urldate = {2023-05-14},
	author = {Burbi, Sara and Rose, Katie Hartless},
	year = {2016},
	note = {Publisher: Unpublished},
}

@incollection{stoetzer_diffusion_1995,
	address = {Berlin, Heidelberg},
	title = {Diffusion of {Innovations}: {Modifications} of a {Model} for {Telecommunications}},
	isbn = {978-3-540-60002-2 978-3-642-79868-9},
	shorttitle = {Diffusion of {Innovations}},
	url = {http://link.springer.com/10.1007/978-3-642-79868-9_2},
	urldate = {2023-05-14},
	booktitle = {Die {Diffusion} von {Innovationen} in der {Telekommunikation}},
	publisher = {Springer Berlin Heidelberg},
	author = {Rogers, Everett M.},
	editor = {Stoetzer, Matthias-W. and Mahler, Alwin},
	year = {1995},
	doi = {10.1007/978-3-642-79868-9_2},
	pages = {25--38},
}

@techreport{department_of_fisheries_bangladesh_yearbook_2021,
	title = {Yearbook of {Fisheries} {Statistics} of {Bangladesh} 2019-20},
	number = {37},
	institution = {Ministry of Fisheries and Livestock, Bangladesh},
	author = {{Department of Fisheries Bangladesh}},
	month = mar,
	year = {2021},
}

@article{khan_production_2021,
	title = {Production {Risk}, {Technical} {Efficiency}, and {Input} {Use} {Nexus}: {Lessons} from {Bangladesh} {Aquaculture}},
	volume = {52},
	issn = {1749-7345},
	shorttitle = {Production {Risk}, {Technical} {Efficiency}, and {Input} {Use} {Nexus}},
	url = {https://onlinelibrary.wiley.com/doi/abs/10.1111/jwas.12767},
	doi = {10.1111/jwas.12767},
	abstract = {The optimal use of resources in aquaculture is important, especially in developing countries, to obtain the highest possible outcome from the production process to support food security and poverty alleviation. Thus, within this study, the risk, efficiency, and input-use variation in aquaculture farms in Bangladesh is investigated using a flexible stochastic frontier model with a risk and an inefficiency function. The results reveal that feed, labor, and capital have positive and significant impacts on production. In addition, an increased fingerling density and a larger farm increase the risk, whereas the use of feed and the capital invested have the opposite effect. Access to extension services has a positive effect and increases farm efficiency. An investigation of the farm size–productivity inverse relationship reveals that this phenomenon is not applicable to Bangladesh aquaculture. In general, efficient farmers are large-scale farmers, who use a lower stocking density but a higher feeding intensity, resulting in a higher yield. On average, farmers use less labor and feed than what is optimal. To increase efficiency and reduce risk, it is recommended that more technical knowledge on optimal input use, extension service, and capital is made available to aquaculture farmers.},
	language = {en},
	number = {1},
	urldate = {2022-09-06},
	journal = {Journal of the World Aquaculture Society},
	author = {Khan, Md. Akhtaruzzaman and Begum, Ratna and Nielsen, Rasmus and Hoff, Ayoe},
	year = {2021},
	note = {\_eprint: https://onlinelibrary.wiley.com/doi/pdf/10.1111/jwas.12767},
	keywords = {aquaculture, flexible stochastic frontier function, optimal input use, production risk},
	pages = {57--72},
	file = {Full Text PDF:C\:\\Users\\user\\Zotero\\storage\\L3FAZ4GS\\Khan et al. - 2021 - Production risk, technical efficiency, and input u.pdf:application/pdf;Snapshot:C\:\\Users\\user\\Zotero\\storage\\624DW3DD\\jwas.html:text/html},
}

@article{dey_potential_2013,
	title = {Potential {Impact} of {Genetically} {Improved} {Carp} {Strains} in {Asia}},
	volume = {43},
	issn = {0306-9192},
	url = {https://www.sciencedirect.com/science/article/pii/S0306919213001516},
	doi = {10.1016/j.foodpol.2013.10.003},
	abstract = {During the past one decade, the WorldFish Center and its research partners have made a systematic attempt to improve the productivity of carps through selective breeding in the major carp-producing countries in Asia. This paper analyses the potential impact of culturing the improved carp strain in five Asian countries (Bangladesh, China, India, Thailand and Vietnam), using a three-step procedure. These steps are: (i) development of a fish sector model for each country, (ii) construction of ex ante impact indicators of improved carp strains, and (iii) analysis of the overall potential impact of culturing the genetically improved carp strains by incorporating the technology scenarios into the fish sector model. The results show that the genetic improvement programs of carp strains are highly beneficial to fish farmers, fish consumers and national economies in Asia.},
	language = {en},
	urldate = {2022-09-06},
	journal = {Food Policy},
	author = {Dey, Madan Mohan and Kumar, Praduman and Chen, Oai Li and Khan, Md. Akhtaruzzaman and Barik, Nagesh Kumar and Li, Luping and Nissapa, Ayut and Pham, Ngoc Sao},
	month = dec,
	year = {2013},
	keywords = {Fish sector model, Genetically improved carp, Impact assessment},
	pages = {306--320},
	file = {ScienceDirect Snapshot:C\:\\Users\\user\\Zotero\\storage\\PDBL3YNE\\S0306919213001516.html:text/html},
}

@article{belton_not_2017,
	title = {Not {Just} for the {Wealthy}: {Rethinking} {Farmed} {Fish} {Consumption} in the {Global} {South}},
	volume = {16},
	shorttitle = {Not {Just} for the {Wealthy}},
	doi = {10.1016/j.gfs.2017.10.005},
	abstract = {Aquaculture's contributions to food security in the Global South are widely misunderstood. Dominant narratives suggest that aquaculture contributes mainly to international trade benefiting richer Northern consumers, or provides for wealthy urban consumers in Southern markets. On the supply side, the literature promotes an idealized vision of `small-scale', low input, semi-subsistence farming as the primary means by which aquaculture can contribute to food security, or emphasizes the role of `industrial' export oriented aquaculture in undermining local food security. In fact, farmed fish is produced predominantly by a `missing middle' segment of commercial and increasingly intensive farms, and overwhelmingly remains in Southern domestic markets for consumption by poor and middle income consumers in both urban and rural areas, making an important but underappreciated contribution to global food security.},
	journal = {Global Food Security},
	author = {Belton, Ben and Bush, Simon and Little, David},
	month = nov,
	year = {2017},
	file = {Full Text PDF:C\:\\Users\\user\\Zotero\\storage\\BG48ZSB7\\Belton et al. - 2017 - Not just for the wealthy Rethinking farmed fish c.pdf:application/pdf},
}

@article{nakano_is_2018,
	title = {Is {Farmer}-to-{Farmer} {Extension} {Effective}? {The} {Impact} of {Training} on {Technology} {Adoption} and {Rice} {Farming} {Productivity} in {Tanzania}},
	volume = {105},
	issn = {0305-750X},
	shorttitle = {Is {Farmer}-to-{Farmer} {Extension} {Effective}?},
	url = {https://www.sciencedirect.com/science/article/pii/S0305750X17304060},
	doi = {10.1016/j.worlddev.2017.12.013},
	abstract = {Agricultural training is a potentially effective method to diffuse relevant new technologies to increase productivity and alleviate rural poverty in Sub-Saharan Africa (SSA). However, since it is prohibitively expensive to provide direct training to all the farmers in SSA, it is critically important to examine the extent to which technologies taught to a small number of farmers disseminate to non-trained farmers. This paper investigates the technology dissemination pathways among smallholder rice producers within a rural irrigation scheme in Tanzania. As an innovative feature, we compare the performance of three categories of farmers: key farmers, who receive intensive pre-season training at a local training center; intermediate farmers, who are trained by the key farmers; and other ordinary farmers. By collecting and analyzing a unique five-year household-level panel data set, we estimate difference-in-differences models to assess how the gap in performance evolve as the technologies spill over from the trained farmers to the ordinary farmers. To disentangle the technology spillover process, we also examine the extent to which social and geographical network with the key and intermediate farmers influences the adoption of technologies by the ordinary farmers, by incorporating social relationship variables into spatial econometric models. We found that the ordinary farmers who were a relative or residential neighbor of a key or intermediate farmer were more likely to adopt new technologies than those who were not. As a result, while the key farmers' technology adoption rates rose immediately after the training, those of the non-trained ordinary farmers caught up belatedly. As the technologies disseminated, the paddy yield of the key farmers increased from 3.1 to 5.3 tons per hectare, while the yield of the ordinary farmers increased from 2.6 to 3.7 tons per hectare. Our results suggest the effectiveness and practical potential of farmer-to-farmer extension programs for smallholders in SSA as a cost effective alternative to the conventional farmer training approach.},
	language = {en},
	urldate = {2022-05-10},
	journal = {World Development},
	author = {Nakano, Yuko and Tsusaka, Takuji W. and Aida, Takeshi and Pede, Valerien O.},
	month = may,
	year = {2018},
	keywords = {Agricultural training, Rice cultivation, Social learning, Sub-Saharan Africa, Tanzania, Technology adoption},
	pages = {336--351},
}

@article{obiero_predicting_2019,
	title = {Predicting {Uptake} of {Aquaculture} {Technologies} {Among} {Smallholder} {Fish} {Farmers} in {Kenya}},
	volume = {27},
	issn = {1573-143X},
	url = {https://doi.org/10.1007/s10499-019-00423-0},
	doi = {10.1007/s10499-019-00423-0},
	abstract = {In Africa, many governments and development agencies have promoted aquaculture as a panacea for household food security, rural development, and poverty reduction. However, aquaculture production in the continent remains low despite significant investments in research and technology development. While numerous initiatives have been directed at technological innovation and transfer, their present scale of uptake is very slow and therefore inadequate to achieve transformational change envisaged in the 2030 Agenda for sustainable development. In this paper, we aim to (1) critically analyze the factors that influence fish farmer's perceptions, attitudes, and behaviors toward technology adoption; and (2) to determine the impacts of technology adoption on farmer's livelihoods. Primary data were collected using a self-administered digitized questionnaire to 331 randomly selected farmers in Kenya. Multivariate logistic regression models were used to analyze data. Results revealed that variables including secondary education, diversified on-farm activities, farm size, production levels, attendance of extension training, ease of understanding, and ease of handling technologies were positive and significant predictors of aquaculture technology adoption. However, 30\% of fish farmers were categorized as high adopters of novel aquaculture technologies, implying that there are gaps in technical skills hindering adoption of innovative technologies and best management practices. To facilitate learning and uptake of technologies and good practices by farmers, a range of aquaculture-related extension and communication materials, including posters, hard copy information leaflets and brochures of recipes in appropriate languages, short video presentations, and radio features, should be commissioned to support the smallholder farmers.},
	language = {en},
	number = {6},
	urldate = {2022-05-10},
	journal = {Aquaculture International},
	author = {Obiero, Kevin Odhiambo and Waidbacher, Herwig and Nyawanda, Bryan Otieno and Munguti, Jonathan Mbonge and Manyala, Julius Otieno and Kaunda-Arara, Boaz},
	month = dec,
	year = {2019},
	keywords = {Technology adoption, Aquaculture, Kenya, Smallholder fish farmers, Sustainable livelihoods},
	pages = {1689--1707},
}

@article{elfitasari_importance_2018,
	title = {The {Importance} of {Aquaculture} {Community} {Group} (acg) in {Social} {Media} (facebook) {Towards} the {Aquaculture} {Knowledge} and {Financial} {Improvement} of {Small} {Scale} {Fish} {Farmers} (ssff) in {Rural} {Areas} of {Central} {Java}},
	volume = {137},
	issn = {1755-1315},
	url = {https://doi.org/10.1088/1755-1315/137/1/012097},
	doi = {10.1088/1755-1315/137/1/012097},
	abstract = {Internet is now widely used by people all over the world, including small scale fisheries communities such as fish farmers. Many applications are being created including social media Facebook which are used by small scale fish farmers (SSFF) for its ease and convenience. The objective of this research is to identify the impact of aquaculture community group (ACG) in social media Facebook towards the improvement of aquaculture knowledge and financial condition of small scale fish farmers in Central Java. This research used quantitative approach where questionnaires were distributed into two groups: SSFF who are member of ACG in social media Facebook and who are not. Sampling technique used random sampling, used 60 samples of SSFF in Central Java. Data obtained were tested using the test statistic Independent t-test using SPSS v.20. Result showed a significant effect of group who are member of ACG in social media Facebook and those who are not, towards the aquaculture knowledge (t count -7.424 and sig 0.000) and financial improvement (t -3.775 and sig 0.000). The results of the average value of the SSFF who are ACG member in Facebook are also higher than farmers who are not.},
	language = {en},
	urldate = {2022-05-10},
	journal = {IOP Conference Series: Earth and Environmental Science},
	author = {Elfitasari, T. and Nugroho, R. A. and Nugroho, A. P.},
	month = apr,
	year = {2018},
	note = {Publisher: IOP Publishing},
	pages = {012097},
}

@techreport{bbs_key_2023,
	title = {Key {Findings}: {Household} {Income} and {Expenditure} {Survey} ({HIES}) 2022},
	url = {https://bbs.portal.gov.bd/sites/default/files/files/bbs.portal.gov.bd/page/57def76a_aa3c_46e3_9f80_53732eb94a83/2023-04-13-09-35-ee41d2a35dcc47a94a595c88328458f4.pdf},
	institution = {Bangladesh Bureau of Statistics (BBS), Ministry of Planning, Government of Bangladesh},
	author = {{BBS}},
	month = apr,
	year = {2023},
}

@article{bahkir_impact_2020,
	title = {Impact of the {COVID}-19 lockdown on digital device-related ocular health},
	volume = {68},
	issn = {0301-4738},
	url = {https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7774196/},
	doi = {10.4103/ijo.IJO_2306_20},
	abstract = {Purpose:
Since the declaration of the lockdown due to COVID-19, the usage of digital devices has gone up across the globe, resulting in a challenge for the visual systems of all ages. The purpose of this study is to assess the impact of the lockdown on digital device usage, and consequently, the ocular surface health implications and circadian rhythm abnormalities related to digital eye strain.

Methods:
An open online survey was sent through various social media platforms and was open for a period of 2 weeks.

Results:
A total of 407 usable responses were obtained; the average age of respondents was 27.4 years. Typically, 93.6\% of respondents reported an increase in their screen time since the lockdown was declared. The average increase in digital device usage was calculated at about 4.8 ± 2.8 h per day. The total usage per day was found to be 8.65 ± 3.74 hours. Sleep disturbances have been reported by 62.4\% of people. Typically, 95.8\% of respondents had experienced at least one symptom related to digital device usage, and 56.5\% said that the frequency and intensity of these symptoms increased since the lockdown was declared.

Conclusion:
The study highlighted the drastic increase in use of digital devices after the initiation of the COVID-19 lockdown, and along with it, the slow deterioration of ocular health across all age groups. Awareness about prevention of digital eye strain should be stressed, and going forward, measures to bring these adverse effects to a minimum should be explored.},
	number = {11},
	urldate = {2023-05-04},
	journal = {Indian Journal of Ophthalmology},
	author = {Bahkir, Fayiqa Ahamed and Grandee, Srinivasan Subramanian},
	month = nov,
	year = {2020},
	pmid = {33120622},
	pmcid = {PMC7774196},
	pages = {2378--2383},
	file = {PubMed Central Full Text PDF:C\:\\Users\\user\\Zotero\\storage\\WQPVGJ5S\\Bahkir and Grandee - 2020 - Impact of the COVID-19 lockdown on digital device-.pdf:application/pdf},
}

@misc{noauthor_facebook_2023,
	title = {Facebook {Users} by {Country}},
	url = {https://worldpopulationreview.com/country-rankings/facebook-users-by-country},
	urldate = {2023-03-18},
	journal = {World Population Review},
	year = {2023},
	file = {Facebook Users by Country 2023:C\:\\Users\\user\\Zotero\\storage\\JQSDDW23\\facebook-users-by-country.html:text/html},
}

@misc{noauthor_facebook_nodate,
	title = {Facebook {Users} by {Country} 2023},
	url = {https://worldpopulationreview.com/country-rankings/facebook-users-by-country},
	urldate = {2023-03-17},
	file = {Facebook Users by Country 2023:C\:\\Users\\user\\Zotero\\storage\\QYEJGPQF\\facebook-users-by-country.html:text/html},
}



@misc{noauthor_world_nodate,
	title = {World {Bank} {Open} {Data}},
	url = {https://data.worldbank.org},
	abstract = {Free and open access to global development data},
	language = {en},
	urldate = {2025-06-01},
        author = {WDI},
        year = {2025},
	journal = {World Bank Open Data},
	file = {Snapshot:C\:\\Users\\marzu\\Zotero\\storage\\8U28GGMK\\PA.NUS.html:text/html},
}




@book{su_modeling_2016,
	address = {Cham},
	title = {Modeling and {Optimization} for {Mobile} {Social} {Networks}},
	isbn = {978-3-319-47921-7 978-3-319-47922-4},
	url = {http://link.springer.com/10.1007/978-3-319-47922-4},
	language = {en},
	urldate = {2023-03-17},
	publisher = {Springer International Publishing},
	author = {Su, Zhou and Xu, Qichao and Zhang, Kuan and Shen, Xuemin},
	year = {2016},
	doi = {10.1007/978-3-319-47922-4},
	keywords = {Analytical model, Content delivery, Epidemic information dissemination, Game theory, Heterogeneous network, Mobile networks, Mobile social network, Network architecture, Optimization, Resource allocation, Wireless communication},
	file = {Submitted Version:C\:\\Users\\user\\Zotero\\storage\\4GR5M4DW\\Su et al. - 2016 - Modeling and Optimization for Mobile Social Networ.pdf:application/pdf},
}

@techreport{chua_effective_2021,
	type = {2021 {Annual} {Meeting}, {August} 1-3, {Austin}, {Texas}},
	title = {Effective {Training} {Through} a {Mobile} {App}: {Evidence} from a {Randomized} {Field} {Experiment}},
	shorttitle = {Effective {Training} {Through} a {Mobile} {App}},
	url = {https://econpapers.repec.org/paper/agsaaea21/312907.htm},
	number = {312907},
	urldate = {2022-09-06},
	institution = {Agricultural and Applied Economics Association},
	author = {Chua, Kenn and Li, Qingxiao and Rahman, Khandker Wahedur and Yang, Xiaoli},
	month = aug,
	year = {2021},
	keywords = {International Development, Productivity Analysis, Research Methods/Statistical Methods},
	file = {RePEc Snapshot:C\:\\Users\\user\\Zotero\\storage\\EIBE7SCR\\312907.html:text/html},
}

@article{kumar_technological_2016,
	title = {Technological {Advances} that {Led} to {Growth} of {Shrimp}, {Salmon}, and {Tilapia} {Farming}},
	volume = {24},
	issn = {2330-8249},
	url = {https://doi.org/10.1080/23308249.2015.1112357},
	doi = {10.1080/23308249.2015.1112357},
	abstract = {Aquaculture has been the world's fastest growing food production sector with an annual growth rate of 8\%. Total aquaculture supply increased dramatically from 0.7 mMT in 1950 to 90 mMT in 2012. Growth of the global seafood supply was made possible through adoption of new technologies that brought more control over aquaculture production processes. This review presents evidence of supply-side technological progress that spurred growth in shrimp, salmon, and tilapia production from 1981 to 2012. Greater availability of hatchery-raised post-larvae, better feed formulations, and a shift in preferred shrimp species from Penaeus monodon to Specific Pathogen Free (SPF) Litopenaeus vannamei appear to have been critical technological advances that triggered rapid growth of shrimp farming. Nutritionally balanced feed, use of automated labor-saving equipment, genetic selection programs, and development of vaccines triggered growth of Atlantic salmon production. Diffusion of Genetically Improved Farm Tilapia (GIFT) was a key technological development that fueled rapid growth of tilapia farming. Understanding the technological advances that led to growth of shrimp, salmon, and tilapia farming may provide insights for future growth of other aquaculture species.},
	number = {2},
	urldate = {2022-09-06},
	journal = {Reviews in Fisheries Science \& Aquaculture},
	author = {Kumar, Ganesh and Engle, Carole R.},
	month = apr,
	year = {2016},
	note = {Publisher: Taylor \& Francis
\_eprint: https://doi.org/10.1080/23308249.2015.1112357},
	keywords = {automation, GIFT, SPF, spill over, technological advances, technology adoption, vaccination},
	pages = {136--152},
}

@article{kumar_factors_2018,
	title = {Factors {Driving} {Aquaculture} {Technology} {Adoption}},
	volume = {49},
	issn = {1749-7345},
	url = {https://onlinelibrary.wiley.com/doi/abs/10.1111/jwas.12514},
	doi = {10.1111/jwas.12514},
	abstract = {Technology adoption has played a key role in the global development and increase in agricultural productivity. However, the decision to adopt a new technology on farms is complex. While the factors that drive the adoption of new technologies have been well studied in agriculture, less attention has been paid to drivers of technology adoption in aquaculture. Aquacultural technologies have developed and advanced rapidly in recent decades, but not all technologies have been adopted readily by farmers. This review paper summarizes some of the critical factors that influence aquaculture technology adoption decisions such as: (1) method of information transfer, (2) characteristics of the technology, (3) farm characteristics, (4) economic factors, and (5) sociodemographic and institutional factors. Fish farmers have tended to adopt technologies that are perceived to be more advantageous than others in terms of productivity, cost efficiency, and ease of management. Price of aquaculture products and profit expectations from business ventures were key economic factors influencing adoption decisions. Given the wide array of species, production practices, and global nature of aquaculture, the intensity and the extent of adoption of technologies depend on the nature of the industry in which they are adopted and their economic, social, political, and regulatory environments.},
	language = {en},
	number = {3},
	urldate = {2022-09-06},
	journal = {Journal of the World Aquaculture Society},
	author = {Kumar, Ganesh and Engle, Carole and Tucker, Craig},
	year = {2018},
	note = {\_eprint: https://onlinelibrary.wiley.com/doi/pdf/10.1111/jwas.12514},
	keywords = {technology adoption, aquacultural productivity, Atlantic salmon, genetically improved farmed tilapia, hybrid catfish, relative advantage},
	pages = {447--476},
	file = {Full Text PDF:C\:\\Users\\user\\Zotero\\storage\\52EHXIWM\\Kumar et al. - 2018 - Factors Driving Aquaculture Technology Adoption.pdf:application/pdf;Snapshot:C\:\\Users\\user\\Zotero\\storage\\DESPEBMI\\jwas.html:text/html},
}

@book{fao_state_2020,
	address = {Rome, Italy},
	series = {The {State} of {World} {Fisheries} and {Aquaculture} ({SOFIA})},
	title = {The {State} of {World} {Fisheries} and {Aquaculture} 2020: {Sustainability} in action},
	isbn = {978-92-5-132692-3},
	shorttitle = {The {State} of {World} {Fisheries} and {Aquaculture} 2020},
	url = {https://www.fao.org/documents/card/en/c/ca9229en/},
	abstract = {The 2020 edition of The State of World Fisheries and Aquaculture has a particular focus on sustainability. This reflects a number of specific considerations. First, 2020 marks the twenty-fifth anniversary of the Code of Conduct for Responsible Fisheries (the Code). Second, several Sustainable Development Goal indicators mature in 2020. Third, FAO hosted the International Symposium on Fisheries Sustainability in late 2019, and fourth, 2020 sees the finalization of specific FAO guidelines on sustainable aquaculture growth, and on social sustainability along value chains. 

While Part 1 retains the format of previous editions, the structure of the rest of the publication has been revised. Part 2 opens with a special section marking the twenty fifth anniversary of the Code. It also focuses on issues coming to the fore, in particular, those related to Sustainable Development Goal 14 and its indicators for which FAO is the "custodian" agency. In addition, Part 2 covers various aspects of fisheries and aquaculture sustainability. The topics discussed range widely, from data and information systems to ocean pollution, product legality, user rights and climate change adaptation. Part 3 now forms the final part of the publication, covering projections and emerging issues such as new technologies and aquaculture biosecurity. It concludes by outlining steps towards a new vision for capture fisheries. The State of World Fisheries and Aquaculture aims to provide objective, reliable and up-to-date information to a wide audience – policymakers, managers, scientists, stakeholders and indeed everyone interested in the fisheries and aquaculture sector.

The following complementary information is available:

Read online the full digital reportSee the interactive storyRead the In BriefRead the Summary of the impacts of the COVID-19 pandemic on the fisheries and aquaculture sector},
	language = {other},
	number = {2020},
	urldate = {2022-09-04},
	publisher = {Food and Agriculture Organisation},
	author = {{FAO}},
	year = {2020},
	doi = {10.4060/ca9229en},
	keywords = {biosecurity, Code of Conduct for Responsible Fisheries, new technology, sustainable aquaculture, Sustainable Development Goals, sustainable fisheries},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\L8Y52Y9U\\FAO - 2020 - The State of World Fisheries and Aquaculture 2020.pdf:application/pdf},
}

@techreport{hassan_state_2020,
	address = {Bangladesh},
	type = {National {Survey} {Report}},
	title = {The {State} of {Bangladesh}'s {Political} {Governance}, {Development}, and {Society}: {According} to its {Citizens}},
	abstract = {The State of Bangladesh's Political Governance, Development, and Society: According to its Citizens is part of a national-level citizen perception survey conducted every year by The Asia Foundation, Bangladesh office. Principal themes of the survey include citizens' perception of Bangladesh's society, politics, and economy; perception of political governance and representation; citizenship; democracy; inclusive development; digitalized Bangladesh; social media's role in influencing policy-making; and social cohesion, trust, and Rohingya issues. The survey started by asking the respondents about the path the country is following—whether they feel that Bangladesh is heading in the right or wrong direction with respect to social, political, and development/economic domains. This year the Foundation is happy to collaborate on this survey with the BRAC Institute of Governance and Development (BIGD).},
	language = {en},
	institution = {The Asia Foundation},
	author = {Hassan, Mirza M. and Aziz, Syeda Salina and Mozumder, Tanvir Ahmed and Mahmud, Erina and Khan, Insiya and Razzaque, Farhana},
	month = jul,
	year = {2020},
	file = {The State of Bangladesh's Political Governance, De.pdf:C\:\\Users\\user\\Zotero\\storage\\MQDJB8U9\\The State of Bangladesh's Political Governance, De.pdf:application/pdf},
}

@article{issahaku_does_2018,
	title = {Does the {Use} of {Mobile} {Phones} by {Smallholder} {Maize} {Farmers} {Affect} {Productivity} in {Ghana}?},
	volume = {19},
	issn = {1522-8916},
	url = {https://doi.org/10.1080/15228916.2017.1416215},
	doi = {10.1080/15228916.2017.1416215},
	abstract = {This study evaluates the effects of mobile technology on productivity and the channels of transmission of these effects. Using propensity score matching procedures, the results show that mobile phone ownership and use significantly improves agricultural productivity. Specifically, the mobile phone improves the productivity of user-farmers by at least 261.20 kg/ha per production season. Further, we find that phone ownership and use impacts productivity more than phone use only. The identified channels of effect are extension services, adoption of modern technology and market participation. These results have key policy implications for Ghana and developing economies at large.},
	number = {3},
	urldate = {2022-05-10},
	journal = {Journal of African Business},
	author = {Issahaku, Haruna and Abu, Benjamin Musah and Nkegbe, Paul Kwame},
	month = jul,
	year = {2018},
	note = {Publisher: Routledge
\_eprint: https://doi.org/10.1080/15228916.2017.1416215},
	keywords = {Ghana, maize, Mobile phone, productivity, propensity score matching},
	pages = {302--322},
}

@article{de_aquaculture_2023,
	title = {Aquaculture {Extension} {During} the {Pandemic} : {Initiatives} of {ICAR}-{CIFA}},
	issn = {0972-009X},
	shorttitle = {Aquaculture {Extension} {During} the {Pandemic}},
	url = {https://www.journalofaquaculture.com/index.php/joa/article/view/186},
	doi = {10.61885/joa.v27.2019.186},
	abstract = {The importance of aquaculture is noteworthy in terms of nutritional, employment and livelihood security. Aquaculture extension has also undergone significant changes in order to keep pace with the development in the aquaculture sector. With the spread of the pandemic, extension and advisory services have embraced digital tools in a big way. ICAR-CIFA has also initiated digital extensions via the website, WhatsApp, You Tube, mobile applications, email, webinars, online training programmes etc. to ease the transfer of technology process and dissemination of information. These initiatives are expected to help fish farmers getting acquainted with the new normal.},
	urldate = {2024-11-11},
	journal = {JOURNAL OF AQUACULTURE},
	author = {De, H. K. and Sivaraman, I. and Mahapatra, A. S. and Rath, D. P. and G., Sreenivasulu and Saha, G. S. and Swain, S. K.},
	month = sep,
	year = {2023},
	pages = {26--31},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\6JIKMUDC\\De et al. - 2023 - Aquaculture Extension During the Pandemic  Initiatives of ICAR-CIFA.pdf:application/pdf},
}

@article{chowdary_role_2024,
	title = {Role of {Social} media in {Agricultural} {Extension} {Service} {Delivery}: {A} {Stakeholder} {Analysis}},
	volume = {30},
	issn = {0971765X},
	shorttitle = {Role of {Social} media in {Agricultural} {Extension} {Service} {Delivery}},
	url = {http://www.envirobiotechjournals.com/EEC/Vol30JanSupplIssue2024/EEC-21.pdf},
	doi = {10.53550/EEC.2024.v30i01s.021},
	number = {suppl},
	urldate = {2024-11-11},
	journal = {Ecology, Environment and Conservation},
	author = {Chowdary, K. Raghavendra and Kishore, M. Ravi and Ramu, Y. Reddi and Jayalakshmi Devi, R. Sarada},
	year = {2024},
	pages = {119--123},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\82MAKS6F\\Chowdary et al. - 2024 - Role of Social media in Agricultural Extension Service Delivery A Stakeholder Analysis.pdf:application/pdf},
}

@article{emmanuel_social_2024,
	title = {Social {Media} as {Tools} for {Agricultural} {Extension} in {Uganda}: {A} {Text} {Mining} {Approach}},
	issn = {2456-2165},
	shorttitle = {Social {Media} as {Tools} for {Agricultural} {Extension} in {Uganda}},
	url = {https://www.ijisrt.com/social-media-as-tools-for-agricultural-extension-in-uganda-a-text-mining-approach},
	doi = {10.38124/ijisrt/IJISRT24MAY1177},
	abstract = {The article discusses the potential of social media as a tool for agricultural extension in Uganda. The authors argue that social media platforms, such as Facebook, X formerly Twitter, WhatsApp, and YouTube, offer a range of opportunities for communication, information sharing, and collaboration among farmers. The study is guided by the Media Richness Theory, which asserts that channels of information based on technology are more effective for transmitting text than other media. The article highlights the challenges faced by traditional extension approaches in reaching remote areas and delivering timely and personalized advice, and suggests that social media can help overcome these challenges. Despite the potential benefits, the authors note that there is limited research on how social media can be effectively utilized for agricultural extension purposes in Uganda. The article concludes by emphasizing the need for agricultural extension workers to utilize social media to engage farmers and improve the effectiveness of agricultural extension services.},
	language = {en},
	urldate = {2024-11-11},
	journal = {International Journal of Innovative Science and Research Technology (IJISRT)},
	author = {Emmanuel, Mugejjera and Sengendo, Eddie and Zziwa, Francis and Mawejje, Ben Kerry and Gorett Nabwire, Maloba},
	month = jun,
	year = {2024},
	pages = {1594--1602},
}

@article{paudel_social_2018,
	title = {Social {Media} in {Agricultural} {Extension}},
	url = {https://ssrn.com/abstract=3662942},
	journal = {Agriculture Extension Journals (2018)},
	author = {Paudel, Rajesh},
	year = {2018},
}

@article{cornelisse_entrepreneurial_2011,
	title = {Entrepreneurial {Extension} {Conducted} via {Social} {Media}},
	volume = {49},
	issn = {1077-5315, 0022-0140},
	url = {https://tigerprints.clemson.edu/joe/vol49/iss6/26/},
	doi = {10.34068/joe.49.06.26},
	abstract = {The widespread availability of and access to the Internet have led to the development of new forms of communication. Collectively termed "social media," these new communication tools have created vast opportunities for Extension professionals in how they perform their work and how businesses interact with consumers. This article outlines currently popular social media tools and how they can be used by Extension professionals to carry out their educational and communication responsibilities and by agricultural business owners.},
	language = {en},
	number = {6},
	urldate = {2024-11-11},
	journal = {Journal of Extension},
	author = {Cornelisse, Sarah and Hyde, Jeffrey and Raines, Christopher and Kelley, Kathleen and Ollendyke, Dana and Remcheck, James},
	month = dec,
	year = {2011},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\LLQ2CGRP\\Cornelisse et al. - 2011 - Entrepreneurial Extension Conducted via Social Media.pdf:application/pdf},
}

@article{barau_overview_2017,
	title = {An overview of social media use in agricultural extension service delivery},
	volume = {8},
	issn = {2061-862X},
	url = {http://journal.magisz.org/index.php/jai/article/view/395},
	doi = {10.17700/jai.2017.8.3.395},
	abstract = {Social media are contemporary digital communication means comprising various tools that allow interaction among people and information exchange worldwide. Its active users have reached around 3 billion globally as at April, 2017. Since agricultural extension service delivery is primarily a communication process, proper integration of social media is necessary. However, owing to the conducted researches so far the present paper was centred on making an overview of the current perspective of social media and agricultural extension service delivery. Evidences obtained revealed that there are many social media platforms being used in agricultural extension service delivery worldwide with Facebook having highest popularity (64.7\%). Most of the agricultural stakeholders using social media are versatile users (33.5\%) who usually visit only to find information (75.7\%). Many challenges are currently faced in using social media for agricultural extension service delivery; viz. illiteracy, shortage of infrastructure, limited participation, non-institutionalisation, lack of quality control, lack of adequate yardstick for measuring impact and need for gender sensitive approach. In general, social media is gradually appreciated in agricultural extension service delivery, but faced with challenges. Thus, the necessity to put structures in place and required efforts by all stakeholders to ensure good use of its benefits.},
	number = {3},
	urldate = {2024-11-11},
	journal = {Journal of Agricultural Informatics},
	author = {Barau, Aliyu Akilu and Afrad, Md. Safiul Islam},
	month = nov,
	year = {2017},
}

@article{singh_use_2022,
	title = {Use of {Social} {Media} in {Enhancing} {Farmer}'s {Satisfaction} {Level} on {Agricultural} {Extension} {Services}: {A} {Case} {Study} of {Farmers} {Club} in {Thoubal} {District}, {Manipur}},
	volume = {4},
	issn = {25826743},
	shorttitle = {Use of {Social} {Media} in {Enhancing} {Farmer}'s {Satisfaction} {Level} on {Agricultural} {Extension} {Services}},
	url = {https://biospub.com/index.php/resbio/article/view/1632},
	doi = {10.54083/ResBio/4.3.2022/102-107},
	number = {3},
	urldate = {2024-11-11},
	journal = {Research Biotica},
	author = {Singh, Salam Prabin and Zeshmarani, S. and Singh, N. Tomba and Hijam, Chuwang and Lembisana, R.K.},
	month = jul,
	year = {2022},
	pages = {102--107},
}

@article{islam_role_2020,
	title = {Role of social media in advancement of aquaculture in {Bangladesh}: {Potentials} and challenges},
	volume = {32},
	issn = {2709-2720, 0257-4330},
	shorttitle = {Role of social media in advancement of aquaculture in {Bangladesh}},
	url = {https://fsb.bau.edu.bd/bjf/index.php/home/article/view/106},
	doi = {10.52168/bjf.2020.32.24},
	abstract = {Aquaculture production contributes 56.24 percent of the total fish production in Bangladesh. Thestudy was conducted to explore the role and feasibility of social media in advancement of aquaculture inBangladesh and its potentiality and challenges. Nowadays internet is used by 57.2\% of total population ofBangladesh. Social media has become ubiquitous and social capital allows a person to draw on resources fromother members of the networks to which he or she belongs. To collect empirical data a number of qualitativeand quantitative tools such as questionnaire interviews, focus group discussion and oral history from differentstakeholders were employed. The study identified 40 communities about aquaculture techniques, systems andinformation sharing on Facebook, the most popular social media in Bangladesh. Bangladesh is a countryconsisting of different remote areas such as Haor regions, hilly regions are not easily accessible for physicalextension work of fisheries and aquaculture. Establishing the social media as a bridge between extensionorganization and fish farmers can contribute to make more profitable and sustainable aquaculture sector. Onthe other way, social media can play important role in fisheries and aquaculture research field. Based onliterature review, interview from different stakeholders the research analysis has proposed a conceptual framework for potentiality of social media in advancement of aquaculture in Bangladesh. The study has alsoidentified the challenges of establishment of social media as a tool for aquaculture extension service andprepared some recommendations. The study has found, Social media can be used to spread new techniquesand culture practices to the field. Building community network, developing community infrastructure andcommunity based fisheries management will be also easy to implement through the utilization of social media.},
	number = {1},
	urldate = {2024-11-11},
	journal = {Bangladesh Journal of Fisheries},
	author = {Islam, Md Rajibul and Fagun, Iftekhar Ahmed and Rishan, Sakib Tahmid},
	month = jul,
	year = {2020},
	pages = {207--212},
}

@article{kamruzzaman_extension_2018,
	title = {Extension {Agents}' {Use} and {Acceptance} of {Social} {Media}: {The} {Case} of the {Department} of {Agricultural} {Extension} in {Bangladesh}},
	volume = {25},
	issn = {10770755, 10770755},
	shorttitle = {Extension {Agents}' {Use} and {Acceptance} of {Social} {Media}},
	url = {https://newprairiepress.org/jiaee/vol25/iss2/9},
	doi = {10.5191/jiaee.2018.25210},
	abstract = {Information and Communication Technologies (ICTs) have been considered as key driving forces for enabling agricultural development ‒ the sector which provides livelihoods for majority of the population in Bangladesh. The Department of Agricultural Extension (DAE), the largest public sector agricultural extension service provider in Bangladesh, has recently enacted a new organizational policy for its staffs to use ICTs such as social media to provide better services. However, there is little or merely anecdotal evidence about how extension agents of DAE have been accepting and using social media for their professional work. Drawing on the theoretical underpinnings of the Technology Acceptance Model (TAM), this study is a first attempt to investigate social media use and acceptance among extension agents in Bangladesh. Data was collected using semi-structured questionnaires from 140 extension agents of DAE who work in the eastern region of Bangladesh. Both descriptive and inferential statistics were used to analyze the data. The findings indicate that most extension agents (51.4\%) used social media for half an hour to one hour every day. Perceived ease of use (PEoU) and Perceived usefulness (PU) are the most influential elements that determine DAE staff acceptance of social media for performing professional functions. Social media was perceived by extension agents as a means for improving professional performance, such as disseminating agricultural information; garnering support for new agricultural policy; networking with clients and colleagues and enabling coordination of services provided by colleagues. Overall, the findings indicate potential uses of social media in an ICT-based agricultural development strategy in Bangladesh.},
	language = {en},
	number = {2},
	urldate = {2024-11-11},
	journal = {Journal of International Agricultural and Extension Education},
	author = {Kamruzzaman, Md. and Chowdhury, Ataharul and Van Paassen, Annemarie and Ganpat, Wayne},
	month = aug,
	year = {2018},
	pages = {132--149},
}

@article{uddin_perceptions_2023,
	title = {Perceptions of the {Role} of the {Social} {Media} in {Agricultural} {Information} among {Bangladeshi} {Farmers}},
	volume = {9},
	issn = {24549479},
	url = {https://www.arcjournals.org/pdfs/ijmjmc/v9-i1/5.pdf},
	doi = {10.20431/2454-9479.0901005},
	number = {1},
	urldate = {2024-11-11},
	journal = {International Journal of Media, Journalism and Mass Communications},
	author = {Uddin, Farhad and Karim, Md. Abdul},
	year = {2023},
	pages = {28--36},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\ZYEDNRJ8\\2023 - Perceptions of the Role of the Social Media in Agricultural Information among Bangladeshi Farmers.pdf:application/pdf},
}

@article{thornber_raising_2019,
	title = {Raising awareness of antimicrobial resistance in rural aquaculture practice in {Bangladesh} through digital communications: a pilot study},
	volume = {12},
	issn = {1654-9716, 1654-9880},
	shorttitle = {Raising awareness of antimicrobial resistance in rural aquaculture practice in {Bangladesh} through digital communications},
	url = {https://www.tandfonline.com/doi/full/10.1080/16549716.2020.1734735},
	doi = {10.1080/16549716.2020.1734735},
	language = {en},
	number = {sup1},
	urldate = {2024-11-11},
	journal = {Global Health Action},
	author = {Thornber, Kelly and Huso, Doina and Rahman, Muhammad Meezanur and Biswas, Himangsu and Rahman, Mohammad Habibur and Brum, Eric and Tyler, Charles R.},
	month = dec,
	year = {2019},
	pages = {1734735},
	file = {Full Text:C\:\\Users\\user\\Zotero\\storage\\9Q5MGJV2\\Thornber et al. - 2019 - Raising awareness of antimicrobial resistance in rural aquaculture practice in Bangladesh through di.pdf:application/pdf},
}
tex*/
	