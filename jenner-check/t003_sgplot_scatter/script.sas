/* Adapted from Working_code_cleaned.sas (amonkhouse11/SQL-Practice).
   Same PROC SGPLOT scatter-with-group technique as the source's
   "Scatter Plot With Modifications TBI & PHQ9" step, run against a
   small inline mock `nhanes` dataset instead of the thesis.* libname data. */

/* Mock NHANES-shaped analytic dataset, mirroring the columns Working_code_cleaned.sas
   builds via merge of thesis.crp/demo/phq9/ferritin/tfr/tbi/bmi datasets, keyed by seqn.
   Values are synthetic but realistic in range for the variables the script analyzes. */
data nhanes;
  input seqn riagendr ridageyr ridreth1 sddsrvyr wtmec2yr sdmvpsu
        phq9 tbi lbdfersi lbxtfr lbxcrp bmxbmi ridexprg;
  datalines;
1001 2 28 1 4 18500 1 4  1 85 12.5 2.1 23.4 2
1002 1 34 2 4 21200 2 12 -1 45 18.2 5.4 27.1 .
1003 2 41 3 5 19800 1 2  0 120 9.8 1.2 21.9 2
1004 2 22 4 5 20500 2 18 1 30 25.6 8.9 31.5 2
1005 1 55 5 6 22100 1 0  -1 65 14.1 0.8 24.8 .
1006 2 19 1 6 17600 2 22 1 15 30.4 12.1 19.7 2
1007 2 63 2 4 23400 1 3  -1 95 11.7 3.3 26.2 .
1008 1 45 3 4 19900 2 8  0 55 16.9 6.7 29.0 .
1009 2 31 4 5 20800 1 15 1 40 22.3 9.4 22.6 2
1010 2 48 5 6 21700 2 1  -1 105 10.2 1.9 25.3 2
1011 2 26 1 5 18900 1 20 1 25 27.8 11.2 20.4 2
1012 1 39 2 6 22600 2 6  0 70 13.4 4.5 28.3 .
1013 2 52 3 4 20100 1 11 -1 50 17.6 5.9 23.9 2
1014 2 24 4 5 19300 2 14 1 35 24.1 8.1 21.1 2
1015 2 60 5 6 22900 1 5  -1 80 12.9 2.7 26.9 .
;
run;

title "Scatter Plot With Modifications TBI & PHQ9";
proc sgplot data=nhanes noautolegend;
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=TBI y=phq9 / group=ridreth1;
   keylegend / location=inside position=NE across=1;
run;
