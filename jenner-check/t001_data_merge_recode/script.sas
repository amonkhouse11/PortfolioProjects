/* Adapted from Working_code_cleaned.sas (amonkhouse11/SQL-Practice).
   The original reads seven cohort-year SAS datasets via
   `libname thesis "D:\Thesis";` (crp_d/e/f, demo_d/e/f, phq9_d/e/f,
   ferritin_d/e/f, tfr_d/e/f, tbi5/7/9, BMI_d/e/f) and merges them by seqn.
   Here each domain is a small inline mock dataset with the same shape/keys,
   and the merge + recode logic below is otherwise unchanged from the source. */

data crp;
  input seqn lbxcrp; datalines;
1001 2.1
1002 5.4
1003 1.2
1004 8.9
1005 0.8
;
run;

data demo;
  input seqn riagendr ridageyr ridreth1 sddsrvyr wtmec2yr ridexprg; datalines;
1001 2 28 1 4 18500 2
1002 1 34 2 4 21200 .
1003 2 41 3 5 19800 2
1004 2 22 4 5 20500 2
1005 1 55 5 6 22100 .
;
run;

data phq9;
  input seqn phq9; datalines;
1001 4
1002 12
1003 2
1004 18
1005 0
;
run;

data ferritin;
  input seqn lbdfersi; datalines;
1001 12.5
1002 18.2
1003 9.8
1004 25.6
1005 14.1
;
run;

data tfr;
  input seqn lbxtfr; datalines;
1001 85
1002 45
1003 120
1004 30
1005 65
;
run;

data tbi;
  input seqn tbi; datalines;
1001 1
1002 -1
1003 0
1004 1
1005 -1
;
run;

data BMI;
  input seqn BMXBMI; datalines;
1001 23.4
1002 27.1
1003 21.9
1004 31.5
1005 24.8
;
run;

proc sort data = BMI;
by seqn;
run;

proc sort data = crp;
by seqn;
run;

proc sort data = phq9;
by seqn;
run;

proc sort data = ferritin;
by seqn;
run;

proc sort data = tfr;
by seqn;
run;
proc sort data= tbi;
by seqn;
run;

data total;
merge demo crp phq9 ferritin tfr tbi bmi;
by seqn;
run; /*adding the variables to the data*/


data nhanes;
set total;

/*4-year sampe weights for 2003-2006, variable MEC6YR; adjust for more/fewer survey years*/
if sddsrvyr in (4,5,6) then MEC6YR = 1/2 * WTMEC2YR;

/*DUMMY & RECODED VARIABLES*/
hispanic=.;
if ridreth1=1 then hispanic=1;
if ridreth1=2 then hispanic =1;
if ridreth1=3 then hispanic =0;
if ridreth1=4 then hispanic =0;
if ridreth1=5 then hispanic =0;

black=.;
if ridreth1=1 then black =0;
if ridreth1=2 then black =0;
if ridreth1=3 then black =0;
if ridreth1=4 then black =1;
if ridreth1=5 then black =0;

other=.;
if ridreth1=1 then other =0;
if ridreth1=2 then other =0;
if ridreth1=3 then other =0;
if ridreth1=4 then other =0;
if ridreth1=5 then other =1;

ethncat=.;
if ridreth1=1 then ethncat=1;
if ridreth1=2 then ethncat=1;
if ridreth1=3 then ethncat=3;
if ridreth1=4 then ethncat=4;
if ridreth1=5 then ethncat=5;

/*SUBPOPULATION - define domain as needed for analysis*/
subpop=.;
  if riagendr=2 and ridageyr > 17 and ridageyr < 50 and RIDEXPRG=2 then subpop=1;
  else subpop=0;
PHQ2= .;
if PHQ9>10 then PHQ2=1;
if PHQ9<10 then PHQ2=0; /* make PHQ9 Dichotomous variable for analysis**/
run;
data nhanes;
set nhanes;
TBI2= .;
if TBI>0 then TBI2=0;
if TBI<0 then TBI2=1;
run;

proc print data=nhanes;
run;
