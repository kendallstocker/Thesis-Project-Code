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
 	



proc corr data=COUNTRIES3;
var MALERATE x2;
run;


