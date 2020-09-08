Dummification for model building based on column variable;                                                                           
                                                                                                                                     
          Three Solutions                                                                                                            
                                                                                                                                     
              a. R data table (one kiner - should be fast)                                                                           
              b. Transpose data step                                                                                                 
                 by Reeza                                                                                                            
                 https://communities.sas.com/t5/user/viewprofilepage/user-id/13879                                                   
              c. SQL datastep                                                                                                        
                 by Reeza                                                                                                            
                 Slight change (used 'proc stdize' instead of datastep array)                                                        
                                                                                                                                     
github                                                                                                                               
https://tinyurl.com/y3fe7evs                                                                                                         
https://github.com/rogerjdeangelis/utl-dummification-for-model-building-based-on-column-variable                                     
                                                                                                                                     
SAS Forum                                                                                                                            
https://tinyurl.com/yxsvb4kz                                                                                                         
https://communities.sas.com/t5/SAS-Programming/Adding-a-new-variable-for-each-value-of-variable/m-p/682267                           
                                                                                                                                     
Source for R                                                                                                                         
https://stackoverflow.com/questions/48630405/dummyfication-of-a-column-variable                                                      
                                                                                                                                     
We will use the types in variable type_code to create a dummy                                                                        
record for each input obsevation.                                                                                                    
                                                                                                                                     
This is best done in a matrix language?                                                                                              
                                                                                                                                     
/*                   _                                                                                                               
(_)_ __  _ __  _   _| |_                                                                                                             
| | `_ \| `_ \| | | | __|                                                                                                            
| | | | | |_) | |_| | |_                                                                                                             
|_|_| |_| .__/ \__,_|\__|                                                                                                            
        |_|                                                                                                                          
*/                                                                                                                                   
                                                                                                                                     
options validvarname=upcase;                                                                                                         
libname sd1 "d:/sd1";                                                                                                                
data sd1.have;                                                                                                                       
input type_cd$ area name$;                                                                                                           
cards4;                                                                                                                              
AZ 3 Lucy                                                                                                                            
BH 5 Frank                                                                                                                           
CR 1 John                                                                                                                            
IM 8 Susan                                                                                                                           
KS 10 Mary                                                                                                                           
LL 9 Jill                                                                                                                            
;;;;                                                                                                                                 
run;quit;                                                                                                                            
                                                                                                                                     
                                                                                                                                     
SD1.HAVE total obs=6                                                                                                                 
                                                                                                                                     
 TYPE_CD    AREA    NAME                                                                                                             
                                                                                                                                     
   AZ         3     Lucy                                                                                                             
   BH         5     Frank                                                                                                            
   CR         1     John                                                                                                             
   IM         8     Susan                                                                                                            
   KS        10     Mary                                                                                                             
   LL         9     Jill                                                                                                             
                                                                                                                                     
/*           _               _                                                                                                       
  ___  _   _| |_ _ __  _   _| |_                                                                                                     
 / _ \| | | | __| `_ \| | | | __|                                                                                                    
| (_) | |_| | |_| |_) | |_| | |_                                                                                                     
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                    
                |_|                                                                                                                  
*/                                                                                                                                   
                                                                                                                                     
WORK.WANT total obs=6                                                                                                                
                                                                                                                                     
  TYPE_CD    AREA    NAME     AZ    BH    CR    IM    KS    LL                                                                       
                                                                                                                                     
    AZ         3     Lucy      1     0     0     0     0     0                                                                       
    BH         5     Frank     0     1     0     0     0     0                                                                       
    CR         1     John      0     0     1     0     0     0                                                                       
    IM         8     Susan     0     0     0     1     0     0                                                                       
    KS        10     Mary      0     0     0     0     1     0                                                                       
    LL         9     Jill      0     0     0     0     0     1                                                                       
                                                                                                                                     
/*         _       _   _                                                                                                             
 ___  ___ | |_   _| |_(_) ___  _ __  ___                                                                                             
/ __|/ _ \| | | | | __| |/ _ \| `_ \/ __|                                                                                            
\__ \ (_) | | |_| | |_| | (_) | | | \__ \                                                                                            
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/                                                                                            
           ____                                                                                                                      
  __ _    |  _ \                                                                                                                     
 / _` |   | |_) |                                                                                                                    
| (_| |_  |  _ <                                                                                                                     
 \__,_(_) |_| \_\                                                                                                                    
                                                                                                                                     
*/                                                                                                                                   
                                                                                                                                     
options validvarname=upcase;                                                                                                         
libname sd1 "d:/sd1";                                                                                                                
data sd1.have;                                                                                                                       
input type_cd$ area name$;                                                                                                           
cards4;                                                                                                                              
AZ 3 Lucy                                                                                                                            
BH 5 Frank                                                                                                                           
CR 1 John                                                                                                                            
IM 8 Susan                                                                                                                           
KS 10 Mary                                                                                                                           
LL 9 Jill                                                                                                                            
;;;;                                                                                                                                 
run;quit;                                                                                                                            
                                                                                                                                     
%utl_submit_r64('                                                                                                                    
library(haven);                                                                                                                      
library(data.table);                                                                                                                 
library(SASxport);                                                                                                                   
have<-as.data.table(read_sas("d:/sd1/have.sas7bdat"));                                                                               
want<-have[dcast(have, TYPE_CD ~ TYPE_CD, value.var = "TYPE_CD", fun = length), on = .(TYPE_CD)];                                    
want;                                                                                                                                
write.xport(want,file="d:/xpt/want.xpt");                                                                                            
');                                                                                                                                  
                                                                                                                                     
%utlfkil(d/xpt/want.xpt);                                                                                                            
                                                                                                                                     
proc datasets lib=work nolist;                                                                                                       
 delete wantxpt want;                                                                                                                
run;quit;                                                                                                                            
                                                                                                                                     
libname xpt xport "d:/xpt/want.xpt";                                                                                                 
data want;                                                                                                                           
  set xpt.want;                                                                                                                      
run;quit;                                                                                                                            
libname xpt clear;                                                                                                                   
                                                                                                                                     
/*        _                                                                                                                          
| |__    | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___                                                                               
| `_ \   | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \                                                                              
| |_) |  | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/                                                                              
|_.__(_)  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|                                                                              
                                 |_|                                                                                                 
*/                                                                                                                                   
                                                                                                                                     
                                                                                                                                     
data have;                                                                                                                           
input type_cd$      area       name$;                                                                                                
cards;                                                                                                                               
AZ 3  Lucy                                                                                                                           
BH 5  Frank                                                                                                                          
CR 1  John                                                                                                                           
IM 8  Susan                                                                                                                          
KS 10 Mary                                                                                                                           
LL 9  Jill                                                                                                                           
;                                                                                                                                    
                                                                                                                                     
data temp / view=temp;                                                                                                               
set have;                                                                                                                            
count=1;                                                                                                                             
run;                                                                                                                                 
                                                                                                                                     
proc transpose data=temp out=wide(drop=_name_ count) prefix=State_;                                                                  
by _all_;                                                                                                                            
id type_cd;                                                                                                                          
var count;                                                                                                                           
run;                                                                                                                                 
                                                                                                                                     
proc stdize data=wide out=want missing=0 reponly;                                                                                    
run;quit;                                                                                                                            
                                                                                                                                     
/*                  _                                                                                                                
  ___     ___  __ _| |                                                                                                               
 / __|   / __|/ _` | |                                                                                                               
| (__ _  \__ \ (_| | |                                                                                                               
 \___(_) |___/\__, |_|                                                                                                               
                 |_|                                                                                                                 
*/                                                                                                                                   
                                                                                                                                     
                                                                                                                                     
data have;                                                                                                                           
input type_cd$      area       name$;                                                                                                
cards;                                                                                                                               
AZ 3  Lucy                                                                                                                           
BH 5  Frank                                                                                                                          
CR 1  John                                                                                                                           
IM 8  Susan                                                                                                                          
KS 10 Mary                                                                                                                           
LL 9  Jill                                                                                                                           
;                                                                                                                                    
                                                                                                                                     
proc sql noprint;                                                                                                                    
select distinct type_cd into: valv separated by ' ' from have;                                                                       
quit;                                                                                                                                
                                                                                                                                     
                                                                                                                                     
data want;                                                                                                                           
set have;                                                                                                                            
array vals(&sqlobs)  &valv;                                                                                                          
do i = 1 to &sqlobs;                                                                                                                 
if vname(vals(i))=type_cd then vals(i)=1;                                                                                            
else vals(i)=0;                                                                                                                      
end;                                                                                                                                 
drop i;                                                                                                                              
run;                                                                                                                                 
                                                                                                                                     
