double TP;
double SL;
double Lots;
double Magic = 123456;
string ea_name = "1023c643df0124a52d58df1_TestPJ_";
bool Open_Buy(){
 if( iMA(NULL,PERIOD_M15,12,0,MODE_EMA,PRICE_CLOSE,1) > iMA(NULL,PERIOD_M15,36,0,MODE_EMA,PRICE_CLOSE,1)   &&   
iLow(NULL,PERIOD_M15,1) <= iMA(NULL,PERIOD_M15,12,0,MODE_EMA,PRICE_CLOSE,1) ) { 
 return 1; 
 } else 
return 0; }
bool Open_Sell(){
return 0; }
bool Close_Buy(){
 if( iADX(NULL,PERIOD_M15,14,PRICE_CLOSE,MODE_MAIN,1) > 40   &&   
iADX(NULL,PERIOD_M15,14,PRICE_CLOSE,MODE_MAIN,2) > iADX(NULL,PERIOD_M15,14,PRICE_CLOSE,MODE_MAIN,1) ) { 
 return 1; 
} else 
return 0; }
bool Close_Sell(){
return 0; }
bool Option(){
TP = 450;
SL = 300;
Lots = 0.01;
if( TP != 0 ){
return 1;
}else return 0;
}