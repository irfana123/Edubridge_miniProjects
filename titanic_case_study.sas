/*============Titanic Case Study===============*/
/*===============1.load data on sas*/


proc import datafile='/home/u59058972/Dataset/Titanic.csv' out=titanic dbms=csv 
		replace;
	getnames=yes;
run;

proc print data=titanic;
run;
/*==========2. print top 10 rows in */
proc print data=titanic(obs=10);
    
run;

/*========3.summary and information of dataset*/
PROC CONTENTS DATA=titanic;
RUN;

/*=============4count survived and show on pie chart*/

proc sql;
/*select * from titanic where Survived=1;*/
SELECT COUNT(survived)
FROM titanic
WHERE survived=1;
quit;


/*============5.survived on pie chart*/

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = survived /
            DATALABELLOCATION = OUTSIDE
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'count of survived ';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = titanic
            TEMPLATE = pie;
RUN;


/*====6.Find out how many female passengers had travelled in first class and show on pie
chart
*/

proc sql;
select count(sex)
FROM titanic
WHERE survived=1 and Sex='female' and pclass=1;
quit;


/*pie chart*/

PROC TEMPLATE;
   DEFINE STATGRAPH pie;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = Sex / group=pclass
            DATALABELLOCATION = OUTSIDE
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'female passenger survived ';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = titanic
            TEMPLATE = pie;
RUN;

/*===7. Find out how many female passengers had Survived and her age <30, show on pie
chart and bar graph
*/

PROC FREQ DATA = titanic;
  TABLES sex*survived /NOCOL nocum NOPERCENT plots=freqplot(type=barplot);
  where age<30;
RUN;

/*8. Find out how many male passengers had Survived and his age >40, show on pie chart
*/


proc freq data=titanic;
tables sex*survived*age /nocum nopercent plots=freqplot(twoway=stacked orient=horizontal);
where survived=1
and sex ="male"and age>40;
run;

ods graphics on;
proc freq data=titanic;
tables age /chisq plots=deviationplot(orient=vertical);
run;


/*9.==========Show age with 20 bins*/

proc univariate data=titanic;
	histogram Age / normal(mu=est color=bib sigma=est) barlabel=count midpoints=0 
		to 90 by 10 ;
run;


/*10.Show age frequency with survived and not survived (Histogram)*/

proc univariate data=titanic;
   histogram survived age /normal;
run;

/*11Show Bar graph for Survived with male, female, class*/
PROC FREQ DATA = titanic;
  TABLES sex*survived*pclass /NOCOL nocum NOPERCENT plots=freqplot(twoway=stacked type=barplot);
  
RUN;

/*12How many passengers are travelled in different classes show in Bar graph*/

PROC FREQ DATA = titanic;
  TABLES pclass /NOCOL nocum NOPERCENT plots=freqplot(type=barplot);
  
RUN;

/*13How many passengers are survived with class wise and show in Bar graph*/

PROC FREQ DATA = titanic;
  TABLES pclass*survived /NOCOL nocum NOPERCENT plots=freqplot(twoway=stacked type=barplot);
  
RUN;


/*14.Show Bar graph for Survived with 3rd class male, 1st class female*/
proc freq data=titanic;
tables sex*survived*pclass/nocum nopercent plots=freqplot(twoway=stacked orient=horizontal);
where survived=1
and sex ="male"and pclass=3;
run;
proc freq data=titanic;
tables sex*survived*pclass /nocum nopercent plots=freqplot(twoway=stacked orient=horizontal);
where survived=1
and sex ="female"and pclass=1;
run;