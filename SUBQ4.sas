/* Generated Code (IMPORT) */
/* Source File: THESIS COUNTRY DATA.xlsx */
/* Source Path: /home/u63737437/sasuser.v94 */
/* Code generated on: 4/23/25, 1:10 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63737437/sasuser.v94/THESIS COUNTRY DATA.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.COUNTRIES;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.COUNTRIES; RUN;


%web_open_table(WORK.IMPORT);

data countries_clean;
    set COUNTRIES;
    if cmiss(of _all_) = 0;
run;

Data COUNTRIES2;
 set countries_clean;
 
 if HPV_VACCINE='Not routinely administered' then do;
 	x1=1; x2=0;
 	end;
 else if HPV_VACCINE='Regions of the country' then do;
 	x1=0; x2=1;
 	end;
 else do;
 	x1=0; x2=0;;
 	end;
Data COUNTRIES3;
 set COUNTRIES2;
 
 if HEPATITISB_VACCINE='Specific risk groups' then do;
 	y1=1; y2=0;
 	end;
 else if HEPATITISB_VACCINE='Adolescents' then do;
 	y1=0; y2=1;
 	end;
 else do;
 	y1=0; y2=0;;
 	end;
 	
 	
 	
proc hpsplit data=COUNTRIES3;
    model MORTALITY = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2;
    grow variance;                  /* Use variance reduction for regression */
    prune costcomplexity;          /* Avoid overfitting */
    partition fraction(validate=0.3);
    output out=tree_out;
run;




/*create binary high vs low risk variable*/

proc univariate data=COUNTRIES3 noprint;
    var MORTALITY;
    output out=threshold pctlpts=50 pctlpre=P_;
run;

data _null_;
    set threshold;
    call symputx('med_thresh', P_50);
run;

data COUNTRIES_CLASSIFIED;
    set COUNTRIES3;
    if MORTALITY >= &med_thresh then HIGH_RISK = 1;
    else HIGH_RISK = 0;
run;	

/*run clasification tree*/

proc hpsplit data=COUNTRIES_CLASSIFIED;
    class HIGH_RISK;
    model HIGH_RISK = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT 
                       HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP 
                       "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION 
                       MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE 
                       x1 x2 y1 y2;
    grow entropy;
    prune costcomplexity;
    partition fraction(validate=0.3);
    output out=tree_class_out;
run;


proc contents data=tree_class_out;
run;

/*create predicted class*/

data predictions;
    set tree_class_out;
    if P_HIGH_RISK1 >= 0.5 then Predicted_High_Risk = 1;
    else Predicted_High_Risk = 0;
run;

/*create confusion matrix*/

proc freq data=predictions;
    tables HIGH_RISK*Predicted_High_Risk / norow nocol nopercent;
run;

/*calculate accuracy manually*/

data accuracy;
    set predictions;
    if HIGH_RISK = Predicted_High_Risk then correct = 1;
    else correct = 0;
run;

proc means data=accuracy mean;
    var correct;
run;










