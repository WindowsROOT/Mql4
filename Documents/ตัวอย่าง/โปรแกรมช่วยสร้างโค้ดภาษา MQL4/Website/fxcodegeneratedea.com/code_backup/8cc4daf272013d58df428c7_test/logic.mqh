double TP;
double SL;
double Lots;
double Magic = 123456;
string ea_name = "8cc4daf272013d58df428c7_test_";
bool Open_Buy(){
 if( iATR(NULL,PERIOD_M1,1,1) > iCCI(NULL,PERIOD_M1,1,PRICE_CLOSE,1) ) { 
 return 1; 
 } else 
return 0; }
bool Open_Sell(){
return 0; }
bool Close_Buy(){
return 0; }
bool Close_Sell(){
 if( iMomentum(NULL,PERIOD_M1,1,PRICE_CLOSE,1) > iLow(NULL,PERIOD_M1,1) ) { 
 return 1; 
} else 
return 0; }
bool Option(){
TP = 300;
SL = 300;
Lots = 0.01;
if( TP != 0 ){
return 1;
}else return 0;
}