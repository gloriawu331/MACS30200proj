clear
import delimited "/Users/hsswyx/Desktop/files_macs30200proj/data.csv", encoding(ISO-8859-1)
drop v1


*****************
* DATA CLEANING *
*****************

* location
* working location
encode emrg, gen(emrg_n)
gen w_loc = round(emrg_n)
recode w_loc (11 = .)
replace is_move = . if w_loc==.
* high school location
gen h_loc = round(hsst)
* current location
gen c_loc = resploc
recode c_loc (20 30 31 33 37 40 50 55 = 10)
recode is_move (.=0) if h_loc == c_loc
recode is_move (.=1) if h_loc != c_loc
replace w_loc = c_loc if w_loc == .

/*
* distance
gen distance = 0
* for New England
replace distance = 1 if h_loc==1 & (w_loc==2)
replace distance = 2 if h_loc==1 & (w_loc==3 | w_loc==5)
replace distance = 3 if h_loc==1 & (w_loc==4 | w_loc==6)
replace distance = 4 if h_loc==1 & (w_loc==7 | w_loc==8)
replace distance = 5 if h_loc==1 & (w_loc==9)
* for Middle Atlantic
replace distance = 1 if h_loc==2 & (w_loc==1 | w_loc==3 | w_loc==5)
replace distance = 2 if h_loc==2 & (w_loc==4 | w_loc==6)
replace distance = 3 if h_loc==2 & (w_loc==7 | w_loc==8)
replace distance = 4 if h_loc==2 & (w_loc==9)
* for East North Central
replace distance = 1 if h_loc==3 & (w_loc==2 | w_loc==4 | w_loc==5 | w_loc==6)
replace distance = 2 if h_loc==3 & (w_loc==1 | w_loc==8)
replace distance = 3 if h_loc==3 & (w_loc==9)
* for West North Central
replace distance = 1 if h_loc==4 & (w_loc==3 | w_loc==6 | w_loc==7 | w_loc==8)
replace distance = 2 if h_loc==4 & (w_loc==2 | w_loc==5 | w_loc==9)
replace distance = 3 if h_loc==4 & (w_loc==1)
* for South Atlantic
replace distance = 1 if h_loc==5 & (w_loc==2 | w_loc==3 | w_loc==6)
replace distance = 2 if h_loc==5 & (w_loc==1 | w_loc==4 | w_loc==7)
replace distance = 3 if h_loc==5 & (w_loc==8)
replace distance = 4 if h_loc==5 & (w_loc==9)
* for East South Central
replace distance = 1 if h_loc==6 & (w_loc==3 | w_loc==4 | w_loc==5 | w_loc==7)
replace distance = 2 if h_loc==6 & (w_loc==2 | w_loc==8)
replace distance = 3 if h_loc==6 & (w_loc==1 | w_loc==9)
* for West South Central
replace distance = 1 if h_loc==7 & (w_loc==4 | w_loc==6 | w_loc==8)
replace distance = 2 if h_loc==7 & (w_loc==3 | w_loc==5 | w_loc==9)
replace distance = 3 if h_loc==7 & (w_loc==2)
replace distance = 4 if h_loc==7 & (w_loc==1)
* for Mountain
replace distance = 1 if h_loc==8 & (w_loc==4 | w_loc==7 | w_loc==9)
replace distance = 2 if h_loc==8 & (w_loc==3 | w_loc==6)
replace distance = 3 if h_loc==8 & (w_loc==2 | w_loc==5)
replace distance = 4 if h_loc==8 & (w_loc==1)
* for Pacific & US Territories
replace distance = 1 if h_loc==9 & (w_loc==8)
replace distance = 2 if h_loc==9 & (w_loc==4 | w_loc==7)
replace distance = 3 if h_loc==9 & (w_loc==3 | w_loc==6)
replace distance = 4 if h_loc==9 & (w_loc==2 | w_loc==5)
replace distance = 5 if h_loc==9 & (w_loc==1)
* move from domestic area to abroad area
replace distance = 8 if h_loc!=10 & w_loc==10
* observations without work
replace distanc = . if w_loc==.
*/

* college major
gen major = .
replace major = 0 if nbamed >= 116710 & nbamed <= 116770 // computer and information sciences
replace major = 1 if nbamed >= 128410 & nbamed <= 128450 // mathematics
replace major = 2 if nbamed >= 216050 & nbamed <= 216080 // agricultural sciences
replace major = 3 if nbamed >= 226310 & nbamed <= 226420 // biological sciences
replace major = 4 if nbamed >= 236800 & nbamed <= 348790 // pyhsical sciences
replace major = 5 if nbamed >= 416010 & nbamed <= 438970 // psychology
replace major = 6 if nbamed >= 449210 & nbamed <= 459300 // social sciences
replace major = 7 if nbamed >= 517210 & nbamed <= 577410 // engineering
replace major = 8 if nbamed >= 617810 & nbamed <= 617910 // health/medical sciences
replace major = 9 if nbamed >= 627020 & nbamed <= 637540 // engineering-related technologies
replace major = 10 if nbamed >= 646100 & nbamed <= 716020 // agricultural business and production
replace major = 11 if nbamed >= 716510 & nbamed <= 716590 // business management/administrative services
replace major = 12 if nbamed >= 727010 & nbamed <= 727130 // education
replace major = 13 if nbamed == 738620 // philosophy, religion, theology
replace major = 14 if nbamed >= 739100 & nbamed <= 757720 // foreign languages and literature
replace major = 15 if nbamed >= 758200 & nbamed <= 759440 // visual and performing arts
replace major = 16 if nbamed >= 766610 & nbamed <= 766630 // communications
replace major = 17 if nbamed == 766820 // natural resources and conservation
replace major = 18 if nbamed >= 766900 & nbamed <= 769030 // public affairs
replace major = 19 if nbamed == 769950 // others

/*
gen major
replace major = 0 if nbamed >= 116710 & nbamed <= 348790 // engeneering, cs, math, nat sciences
replace major = 1 if nbamed >= 416010 & nbamed <= 459300 // social sciences
replace major = 0 if nbamed >= 517210 & nbamed <= 577410 // engeneering, cs, math, nat sciences
replace major = 2 if nbamed >= 617810 & nbamed <= 617910 // others
replace major = 0 if nbamed >= 627020 & nbamed <= 637540 // engeneering, cs, math, nat sciences
replace major = 2 if nbamed >= 646100 // others
*/

* race
encode asian, gen(asian_1)
recode asian_1 (1 2 = 0)
recode asian_1 (3 = 1)
encode black, gen(black_1)
recode black_1 (1 2 = 0)
recode black_1 (3 = 1)
encode hispanic, gen(hispanic_1)
recode hispanic_1 (1 = 0)
recode hispanic_1 (2 = 1)
* combine these into a single variable
gen race = 0
replace race = 1 if asian_1 == 1
replace race = 2 if black_1 == 1
replace race = 3 if hispanic_1 == 1

* gender
encode gender, gen(female)
recode female (2=0)
drop gender

* marrital status
gen married = 0
replace married=1 if marsta==1 | marsta==2

* salary
gen inc = salary
replace inc=0.0001 if salary == 9999998
gen lninc = log(inc)

* work experience
gen expr = 0
replace expr=1 if emsmi=="1"
replace expr=2 if emsmi=="2"
replace expr=3 if emsmi=="3"
replace expr=4 if emsmi=="4"

* required skills of job
gen job_sci = .
replace job_sci = 0 if mgrnat=="N"
replace job_sci = 1 if mgrnat=="Y"
gen job_oth = .
replace job_oth = 0 if mgroth=="N"
replace job_oth = 1 if mgroth=="Y"
gen job_soc = .
replace job_soc = 0 if mgrsoc=="N"
replace job_soc = 1 if mgrsoc=="Y"

* whether matched
gen matched = .
replace matched = 0 if job_sci == 0 & job_oth == 0 & job_soc == 0
replace matched = 1 if job_sci == 1 & (major==0 | major==1 | major==3 | major==4 | major==7 | major==9)
replace matched = 1 if job_oth == 1 & (major==2 | major==8 | major==10 | major==11 | major==12 | major==13 | major==14 | major==15 | major==16 | major==17 | major==18 | major==19)
replace matched = 1 if job_soc == 1 & (major==5 | major==6)

* what kind of match
gen match_type = .
replace match_type = 0 if matched==0
replace match_type = 1 if job_sci==1 & job_oth==0 & job_soc==0 // only match sci
replace match_type = 2 if job_sci==0 & job_oth==1 & job_soc==0 // only match oth
replace match_type = 3 if job_sci==0 & job_oth==0 & job_soc==1 // only match soc
replace match_type = 4 if job_sci==1 & job_oth==1 & job_soc==0 // match sci & oth
replace match_type = 5 if job_sci==1 & job_oth==0 & job_soc==1 // match sci & soc
replace match_type = 6 if job_sci==0 & job_oth==1 & job_soc==1 // match oth & soc
replace match_type = 7 if job_sci==1 & job_oth==1 & job_soc==1 // match all

* match number
gen match_num = .
replace match_num = 0 if match_type==0
replace match_num = 1 if match_type==1 | match_type==2 | match_type==3
replace match_num = 2 if match_type==4 | match_type==5 | match_type==6
replace match_num = 3 if match_type==7

* export the data for visualization
* export delimited using "/Users/hsswyx/Desktop/files_macs30200proj/data1.csv", nolabel quote replace

* major_classified
gen major_ctgy = .
replace major_ctgy = 1 if major==0 | major==1 | major==2 | major==3 | major==4 | major==7 | major==9 | major==10 | major==17
replace major_ctgy = 2 if major==8 | (major>=11 & major!=17)
replace major_ctgy = 3 if major==5 | major==6
recode major_ctgy (3=0)
gen major_sci = . // major fit jobs require natural sciences
replace major_sci = 0 if major_ctgy==2 | major_ctgy==0
replace major_sci = 1 if major_ctgy==1
gen major_oth = . // major fit jobs require other majors
replace major_oth = 0 if major_ctgy==1 | major_ctgy==0
replace major_oth = 1 if major_ctgy==2
gen major_soc = . // major fit jobs require social sciences
replace major_soc = 0 if major_ctgy==1 | major_ctgy==2
replace major_soc = 1 if major_ctgy==0

* create dummy variable of major
gen major0 = .
recode major0 (.=0) if major!=. & major!=0
recode major0 (.=1) if major==0
gen major1 = .
recode major1 (.=0) if major!=. & major!=1
recode major1 (.=1) if major==1
gen major2 = .
recode major2 (.=0) if major!=. & major!=2
recode major2 (.=1) if major==2
gen major3 = .
recode major3 (.=0) if major!=. & major!=3
recode major3 (.=1) if major==3
gen major4 = .
recode major4 (.=0) if major!=. & major!=4
recode major4 (.=1) if major==4
gen major5 = .
recode major5 (.=0) if major!=. & major!=5
recode major5 (.=1) if major==5
gen major6 = .
recode major6 (.=0) if major!=. & major!=6
recode major6 (.=1) if major==6
gen major7 = .
recode major7 (.=0) if major!=. & major!=7
recode major7 (.=1) if major==7
gen major8 = .
recode major8 (.=0) if major!=. & major!=8
recode major8 (.=1) if major==8
gen major9 = .
recode major9 (.=0) if major!=. & major!=9
recode major9 (.=1) if major==9
gen major10 = .
recode major10 (.=0) if major!=. & major!=10
recode major10 (.=1) if major==10
gen major11 = .
recode major11 (.=0) if major!=. & major!=11
recode major11 (.=1) if major==11
gen major12 = .
recode major12 (.=0) if major!=. & major!=12
recode major12 (.=1) if major==12
gen major13 = .
recode major13 (.=0) if major!=. & major!=13
recode major13 (.=1) if major==13
gen major14 = .
recode major14 (.=0) if major!=. & major!=14
recode major14 (.=1) if major==14
gen major15 = .
recode major15 (.=0) if major!=. & major!=15
recode major15 (.=1) if major==15
gen major16 = .
recode major16 (.=0) if major!=. & major!=16
recode major16 (.=1) if major==16
gen major17 = .
recode major17 (.=0) if major!=. & major!=17
recode major17 (.=1) if major==17
gen major18 = .
recode major18 (.=0) if major!=. & major!=18
recode major18 (.=1) if major==18
gen major19 = .
recode major19 (.=0) if major!=. & major!=19
recode major19 (.=1) if major==19

* parents' education
gen fedu=.
recode fedu (.=9) if eddad==1
recode fedu (.=12) if eddad==2
recode fedu (.=14) if eddad==3
recode fedu (.=16) if eddad==4
recode fedu (.=18) if eddad==5
recode fedu (.=19) if eddad==6
recode fedu (.=23) if eddad==7
gen medu=.
recode medu (.=9) if edmom==1
recode medu (.=12) if edmom==2
recode medu (.=14) if edmom==3
recode medu (.=16) if edmom==4
recode medu (.=18) if edmom==5
recode medu (.=19) if edmom==6
recode medu (.=23) if edmom==7

* export the data for visualization
export delimited using "/Users/hsswyx/Desktop/files_macs30200proj/data2.csv", nolabel quote replace

*sum age salary
*tab female
*tab married
*tab race
*tab major


**********
* MODELS *
**********
*ivregress gmm is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married (lninc = i.expr)
logit is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married fedu medu
outreg2 using mine1.xls, replace
*ivregress gmm is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married (lninc = i.expr) i.h_loc
logit is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married fedu medu i.h_loc
outreg2 using mine1.xls
recode major_ctgy(0=3)
recode major_ctgy(2=0)
recode major_ctgy(3=2)
*ivregress gmm is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married (lninc = i.expr) i.h_loc i.major_ctgy
logit is_move age i.female i.black_1 i.asian_1 i.hispanic_1 i.married fedu medu i.h_loc i.major_ctgy
outreg2 using mine1.xls


