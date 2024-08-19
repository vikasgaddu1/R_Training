* Written by R;
*  write.foreign(mtcars, df, cf, package = c("SAS")) ;

DATA  rdata ;
INFILE  "mtcars_sas.txt" 
     DSD 
     LRECL= 43 ;
INPUT
 mpg
 cyl
 disp
 hp
 drat
 wt
 qsec
 vs
 am
 gear
 carb
;
RUN;
