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
 	
data cancer_dummy;
    set COUNTRIES3;

    /* Create dummy variables for each cancer type */
    lung_cancer   = (MOST_COMMON_TYPE = "lung");
    breast_cancer = (MOST_COMMON_TYPE = "breast");
    colorectum_cancer  = (MOST_COMMON_TYPE = "colorectum");
    prostate_cancer = (MOST_COMMON_TYPE = "prostate");
    oesophagus_cancer = (MOST_COMMON_TYPE = "oesophagus");
    liver_cancer = (MOST_COMMON_TYPE = "liver");
    cervix_cancer = (MOST_COMMON_TYPE = "cervix");
    stomach_cancer = (MOST_COMMON_TYPE = "stomach");
run;
 	
/*MODELS*/

/*LUNG*/
/*STEPWISE & FORWARD & BACKWARD*/
proc reg data=cancer_dummy;
model lung_cancer = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2/selection=stepwise slentry=.05 slstay=.05;
run;
proc reg data=cancer_dummy;
model lung_cancer = UNDERNOURISHMENT x1 y2;
run;
proc glmselect data=cancer_dummy;
model lung_cancer = UNDERNOURISHMENT x1 y2 / selection=none stats=all;
run;
/*CORR*/
proc corr data=cancer_dummy;
var lung_cancer y2;
run;

/*BREAST*/
/*STEPWISE & FORWARD & BACKWARD*/
proc reg data=cancer_dummy;
model breast_cancer = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2/selection=stepwise slentry=.05 slstay=.05;
run;
proc reg data=cancer_dummy;
model breast_cancer = GDP;
run;	
proc glmselect data=cancer_dummy;
model breast_cancer = GDP/ selection=none stats=all;
run;
/*CORR*/
proc corr data=cancer_dummy;
var breast_cancer y2;
run;

/*COLORECTUM*/
/*STEPWISE & FORWARD & BACKWARD*/
proc reg data=cancer_dummy;
model colorectum_cancer = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2/selection=stepwise slentry=.05 slstay=.05;
run;
proc reg data=cancer_dummy;
model colorectum_cancer = "MEDIAN AGE"n;
run;
proc glmselect data=cancer_dummy;
model colorectum_cancer = "MEDIAN AGE"n / selection=none stats=all;
run;
/*CORR*/
proc corr data=cancer_dummy;
var colorectum_cancer y2;
run;

/*PROSTATE*/
/*STEPWISE & FORWARD & BACKWARD*/
proc reg data=cancer_dummy;
model prostate_cancer = SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2/selection=stepwise slentry=.05 slstay=.05;
run;
proc reg data=cancer_dummy;
model prostate_cancer = GDP;
run;
proc glmselect data=cancer_dummy;
model prostate_cancer = GDP / selection=none stats=all;
run;
/*CORR*/
proc corr data=cancer_dummy;
var prostate_cancer y2;
run;


