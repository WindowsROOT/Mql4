double TP;
double SL;
double Lots;
double Magic = 123456;
string ea_name = "2cb64fcf1303851245c6552_fxcodegeneratedea-759_";
bool Open_Buy(){
return 0; }
bool Open_Sell(){
return 0; }
bool Close_Buy(){
return 0; }
bool Close_Sell(){
return 0; }
bool Option(){
TP = 300;
SL = 300;
Lots = 0.01;
if( TP != 0 ){
return 1;
}else return 0;
}