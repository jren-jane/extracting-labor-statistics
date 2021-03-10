 cd "Z:\Topics in Advanced Macroeconomics\PS4"
 do "Z:\Topics in Advanced Macroeconomics\PS4\data-preparation.do"

 *only consider individuals between 25 and 54
drop if age<25
drop if age >54

*generalize employment status: 1= employed, 2=unemployed, 3=non participant
gen empstat1=2
replace empstat1=1 if empstat<20 
replace empstat1=3 if empstat>30

*create variable of time period: duration one month
gen time=(year-2012)*12+month
sort cpsidp time

 *Create dummy variables for transition in employment status: e.g. ue implies that from last period to this period the person has moved from unemployment to employmend
 *by cpsidp: 
by cpsidp: gen ee=1 if empstat1==1 & empstat1[_n-1]==1
by cpsidp:gen eu=1 if empstat1==2 & empstat1[_n-1]==1
by cpsidp:gen en=1 if empstat1==3 & empstat1[_n-1]==1
by cpsidp:gen ue=1 if empstat1==1 & empstat1[_n-1]==2
by cpsidp:gen uu=1 if empstat1==2 & empstat1[_n-1]==2
by cpsidp:gen un=1 if empstat1==3 & empstat1[_n-1]==2
by cpsidp:gen ne=1 if empstat1==1 & empstat1[_n-1]==3
by cpsidp:gen nu=1 if empstat1==2 & empstat1[_n-1]==3
by cpsidp:gen nn=1 if empstat1==3 & empstat1[_n-1]==3

*eliminate cases where the distance between the observations is more than one month
replace ee=0 if time[_n-1]~=time-1
replace eu=0 if time[_n-1]~=time-1
replace en=0 if time[_n-1]~=time-1
replace ue=0 if time[_n-1]~=time-1
replace uu=0 if time[_n-1]~=time-1
replace un=0 if time[_n-1]~=time-1
replace ne=0 if time[_n-1]~=time-1
replace nu=0 if time[_n-1]~=time-1
replace nn=0 if time[_n-1]~=time-1

*Force participation rate and unemployment rate:

*compute transition rates between u,e,n: find the percentage of weigehted people who moved from x to y/ weighted sum of sample
sort time

by time: gen tr_ee=sum(ee)/(sum(ee)+sum(eu)+sum(en))
by time: replace tr_ee=tr_ee[_N]


*compute force participation rate and unemployment rate
sort time empstat1
by time empstat1: gen E=_N if empstat1==1
by time empstat1: gen U=_N if empstat1==2
by time empstat1: gen N=_N if empstat1==3

******FILE ENDS HERE********
*WASTE:

*Pop: mass of sample in period t
 *by time:
*by time: egen pop=total(wtfinl)

**HIER WEITERMACHEN** im zähler muss summe ee summe eu summe en stehen!

by time: egen tr_eu=total(eu*wtfinl)

by time: replace tr_eu=tr_eu/pop
by time:egen tr_en=total(en)
by time: replace tr_en=tr_en/pop
by time:egen tr_ue=total(ue)
by time: replace tr_ue=tr_ue/pop
by time:egen tr_un=total(un)
by time: replace tr_un=tr_un/pop
by time:egen tr_ne=total(ne)
by time: replace tr_ne=tr_ne/pop
by time:egen tr_nu=total(nu)
by time: replace tr_nu=tr_nu/pop

 egen fpr=(total(empstat1==1)+total(empstat1==2))/_N,by(time)
egen ur=total(empstat1==2)/(total(empstat1==1)+total(empstat1==2)),by(time)
*replace trans_eu=sum(eu)/_N
*replace trans_en=sum(en)/_N
*replace trans_ue=sum(ue)/_N
*replace trans_un=sum(un)/_N
*replace trans_ne=sum(ne)/_N
*replace trans_nu=sum(nu)/_N

