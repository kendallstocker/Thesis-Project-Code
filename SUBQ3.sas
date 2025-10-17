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
 	
/*STANDARDIZE DATA*/

proc standard data=COUNTRIES3 mean=0 std=1 out=std_data;
   var INCIDENCE SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2;
run;


/*K-MEANS CLUSTERING*/

proc fastclus data=std_data maxclusters=4 out=clustered;
   var SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2;
run;

 	
/*ANALYZE AND VISUALIZE CLUSTERS*/

proc sgplot data=clustered;
   scatter x=GDP y=INCIDENCE / group=cluster;
run;	

/*COMPARE CLUSTERS*/

proc means data=clustered mean stddev maxdec=2;
   class cluster;
   var SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2;
run;

/*WHICH REGIONS IN EACH CLUSTER?*/

proc print data=clustered;
   var 'BOTH SEXES'N cluster;
run;


/*CLUSTER QUALITY STATS*/
proc print data=clust_stats;
run;


/* ELBOW PLOTS */


%macro elbow(data=std_data, maxk=10);

   /* delete old results if they exist */
   proc datasets lib=work nolist;
      delete fit_stats;
   quit;

   data fit_stats; length k 8 rsq rmsstd 8; stop; run;

   %do k=2 %to &maxk;   /* skip k=1 because WITHIN_STD is undefined */
      proc fastclus data=&data maxclusters=&k out=clusout outstat=stat noprint;
         var SMOKING ALC_CONSUMPTION HDI OBESITY UNDERNOURISHMENT HIGHSCHOOL_DIPLOMA SUGAR_CONSUMPTION_PER_CAPITA GDP "MEDIAN AGE"n WO_HEALTH_INSURANCE AIR_POLLUTION MEAN_HOUSEHOLD_INCOME "WATER QUALITY"n UNEMPLOYMENT_RATE x1 x2 y1 y2;
      run;

      proc sql noprint;
         create table temp as
         select &k as k,
                max(case when upcase(_TYPE_)='RSQ'        then OVER_ALL end) as rsq,
                max(case when upcase(_TYPE_)='WITHIN_STD' then OVER_ALL end) as rmsstd
         from stat;
      quit;

      proc append base=fit_stats data=temp force; run;
   %end;

%mend elbow;

/* Run the elbow analysis */
%elbow(data=std_data, maxk=10);

/* RSQ elbow plot */
proc sgplot data=fit_stats;
   series x=k y=rsq / markers;
   xaxis label="Number of Clusters (k)";
   yaxis label="RSQ (Proportion of Variance Explained)";
   title "Elbow Plot - RSQ";
run;

/* RMSSTD elbow plot */
proc sgplot data=fit_stats;
   series x=k y=rmsstd / markers;
   xaxis label="Number of Clusters (k)";
   yaxis label="RMSSTD (Within-Cluster Std Dev)";
   title "Elbow Plot - RMSSTD";
run;
 	
 	
 	
 	
 	
 	
 	