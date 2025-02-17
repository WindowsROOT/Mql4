//+------------------------------------------------------------------+
//|                                               v2.1 News+Line.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.10"
#property strict


#import "wininet.dll"
int InternetOpenW(string sAgent,int lAccessType,string sProxyName="",string sProxyBypass="",int lFlags=0);
int InternetOpenUrlW(int hInternetSession,string sUrl,string sHeaders="",int lHeadersLength=0,int lFlags=0,int lContext=0);
int InternetReadFile(int hFile,uchar &sBuffer[],int lNumBytesToRead,int &lNumberOfBytesRead);
int InternetCloseHandle(int hInet);
#import
int hSession_IEType;
int hSession_Direct;
int Internet_Open_Type_Preconfig=0;
int Internet_Open_Type_Direct=1;

int hSession(bool Direct){
   string InternetAgent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
   if(Direct){
      if(hSession_Direct==0){
         hSession_Direct=InternetOpenW(InternetAgent,Internet_Open_Type_Direct,"0","0",0);
      }
   return(hSession_Direct);
   } else {
   if(hSession_IEType==0){
      hSession_IEType=InternetOpenW(InternetAgent,Internet_Open_Type_Preconfig,"0","0",0);
   }
   return(hSession_IEType);
   }
}
string httpGET(string strUrl){
   int handler=hSession(false);
   int response= InternetOpenUrlW(handler,strUrl);
   if(response == 0)return("0");
   uchar ch[100000]; string toStr=""; int dwBytes,h=-1;
   while(InternetReadFile(response,ch,100000,dwBytes)){
      if(dwBytes<=0) break; toStr=toStr+CharArrayToString(ch,0,dwBytes);
   }
   InternetCloseHandle(response);
   return(toStr);
}

input string SymbolSetting = "=================================";//• Symbol Setting
input string Symbol1 = "EURUSDk";//• Symbol 1
input double Lot1 = 0.02;//• Lot 1
input string Symbol2 = "GBPUSDk";//• Symbol 2
input double Lot2 = 0.01;//• Lot 2
input string Symbol3 = "USDCHFk";//• Symbol 3
input double Lot3 = 0.03;//• Lot 3
input int MaxOrder = 3;//• Lot 3
input string TradingSetting = "=================================";//• Trading Setting
input int MagicNumber = 123456;//• Magic Number
input int Slippage = 3;//• Slippage
input string ProfitTargetSetting = "=================================";//• Profit Target Setting
input double ProfitTarget = 10;//• Profit Target
input string CutLossTargetSetting = "=================================";//• CutLoss Target Setting
input double CutLossTarget = 50;//• CutLoss Target
input string IndicatorSetting = "=================================";//• Indicator Setting
input int Period_MA = 10;//• Period MA
input ENUM_TIMEFRAMES TimeFrame_MA = PERIOD_M1;//• Time Frame MA
input int Shift_MA = 0;//• Shift MA
input ENUM_MA_METHOD Method_MA = MODE_EMA;//• Method MA
input ENUM_APPLIED_PRICE Price_MA = PRICE_CLOSE;//• Price MA
input string LineNotifySetting = "=================================";//• Line Notify Setting
input bool Use_LineNotify = true;//• Use LineNotify
input string PleaseAddLink = "https://notify-api.line.me/api/notify";//• Please Add Link
input string line_token = "enter your line token here" ;//• Line Token
input string SettingNews = "=================================";//• News Setting
input bool Use_NewsAvoid = true;//• Use NewsAvoid
input bool Use_AutoStopMartingaleBreakNews = true;//• Use AutoStopMartingaleBreakNews
input int StopTrade_BeforeNews_Min = 60;//• StopTradeBeforeNews_Min
input int ContinueTrade_AfterNews_Min = 120;//• ContinueTradeAfterNews_Min
input string SettingForexFactoryCalendar = "=================================";//• Setting Forex Factory Calendar Indicator
input bool IncludeHigh = true;//• IncludeHigh
input bool IncludeMedium = true;//• IncludeMedium
input bool IncludeLow = true;//• IncludeLow
input int OffsetHours = 3;//• OffsetHours
input bool AllowTimeUpdateNews = true;//• AllowTimeUpdateNews
input int TimeUpdateNewsMinutes = 240;//• TimeUpdateNewsMinutes
input bool ReportAllForAUD = true;//• ReportAllForAUD
input bool ReportAllForCAD = true;//• ReportAllForCAD
input bool ReportAllForCHF = true;//• ReportAllForCHF
input bool ReportAllForEUR = true;//• ReportAllForEUR
input bool ReportAllForGBP = true;//• ReportAllForGBP  
input bool ReportAllForJPY = true;//• ReportAllForJPY
input bool ReportAllForNZD = true;//• ReportAllForNZD
input bool ReportAllForUSD = true;//• ReportAllForUSD
input bool ReportAllForCNY = false;//• ReportAllForCNY
input color TxtColorImpactHigh = clrRed;//• TxtColorImpactHigh
input color TxtColorImpactMedium = clrYellow;//• TxtColorImpactMedium
input color TxtColorImpactLow = clrWhite;//• TxtColorImpactLow
input color TxtColorDate = clrPeru;//• TxtColorDate
input color TxtColorTime = clrOrange;//• TxtColorTime
input color TxtColorCountry = clrAqua;//• TxtColorCountry
input color TxtColorTitle = clrDeepSkyBlue;//• TxtColorTitle
input string EndSetting = "=================================";//• End Setting

datetime LastTimeUpdateNewsMinutes;
struct StructOfNew{
   string text;
   string title;
   string country;
   string date;
   string time;
   string impact;
   string forecast;
   string previous;
}WeeklyNews[300];
int index_WeeklyNews = 0;

void GetWeeklyNews(){
   for(int i=0;i<index_WeeklyNews;i++){
      WeeklyNews[i].text = "";
      WeeklyNews[i].title = "";
      WeeklyNews[i].country = "";
      WeeklyNews[i].date = "";
      WeeklyNews[i].time = "";
      WeeklyNews[i].impact = "";
      WeeklyNews[i].forecast = "";
      WeeklyNews[i].previous = "";
   }
   index_WeeklyNews = 0;
   string text = httpGET("https://cdn-nfs.faireconomy.media/ff_calendar_thisweek.xml");
   string HttpText = StringSubstr(text,StringFind(text,"<weeklyevents>",0),StringFind(text,"</weeklyevents>",0)-StringFind(text,"<weeklyevents>",0));
   int counter = 0;
   string str ="",end="\n";
   while(StringFind(HttpText,"</event>",0)>=0){
      WeeklyNews[index_WeeklyNews].text = StringSubstr(HttpText,StringFind(HttpText,"<event>",0),StringFind(HttpText,"</event>",0)-StringFind(HttpText,"<event>",0));
      StringReplace(HttpText,StringSubstr(HttpText,0,StringFind(HttpText,"</event>",counter)+StringLen("</event>")),"");
      index_WeeklyNews++;
   }
   for(int i=0;i<index_WeeklyNews;i++){
   WeeklyNews[i].title = GetArrayNews(i,WeeklyNews[i].text,"<title>","</title>");
   WeeklyNews[i].country = GetArrayNews(i,WeeklyNews[i].text,"<country>","</country>");
   WeeklyNews[i].date = GetArrayNews(i,WeeklyNews[i].text,"<date>","</date>");
   WeeklyNews[i].time = GetArrayNews(i,WeeklyNews[i].text,"<time>","</time>");
   WeeklyNews[i].impact = GetArrayNews(i,WeeklyNews[i].text,"<impact>","</impact>");
   WeeklyNews[i].forecast = GetArrayNews(i,WeeklyNews[i].text,"<forecast>","</forecast>");
   WeeklyNews[i].previous = GetArrayNews(i,WeeklyNews[i].text,"<previous>","</previous>");
   }
}
string SlotReplace[16] = {
"<title>",
"</title>",
"<country>",
"</country>",
"<date>",
"</date>",
"<time>",
"</time>",
"<impact>",
"</impact>",
"<forecast>",
"</forecast>",
"<previous>",
"</previous>",
"<![CDATA[",
"]]>" };//16
string GetArrayNews(int array,string text,string first,string second){
   string str = StringSubstr(text,StringFind(text,first,0),StringFind(text,second,0)-StringFind(text,first,0));
   for(int i=0;i<16;i++){
      StringReplace(str,SlotReplace[i],"");
   } 
   if(first=="<date>"){
      string day,month,year;
      month = StringSubstr(str,0, 2);
      day = StringSubstr(str,3, 2);
      year = StringSubstr(str,6, 4);
      str = year+"."+month+"."+day;
   }
   if(first=="<time>"){
      if(StringFind(str,"am",0)>=0){
         if(StringLen(str)<7){
            string hour = StringSubstr(str,0,StringLen(str)-5);
            hour = IntegerToString((StringToInteger(hour)));
            string min = StringSubstr(str,2,2);
            hour = IntegerToString((StringToInteger(hour)+OffsetHours));
            if(StringToInteger(hour)>=12){
               hour = IntegerToString(StringToInteger(hour)-12);
            }
            if(StringToInteger(hour)>=24){
               hour = IntegerToString(StringToInteger(hour)-24);
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)+(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<0){
               hour = IntegerToString(24-MathAbs(StringToInteger(hour)));
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)-(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<10) hour = "0"+hour;
            str = hour+":"+min;
            
         }
         if(StringLen(str)>=7){
            string hour = StringSubstr(str,0,StringLen(str)-5);
            hour = IntegerToString((StringToInteger(hour)));
            if(StringToInteger(hour)>=12){
               hour = IntegerToString(StringToInteger(hour)-12);
            }
            string min = StringSubstr(str,3,2);
            hour = IntegerToString((StringToInteger(hour)+OffsetHours));
            if(StringToInteger(hour)>=24){
               hour = IntegerToString(StringToInteger(hour)-24);
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)+(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<0){
               hour = IntegerToString(24-MathAbs(StringToInteger(hour)));
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)-(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<10) hour = "0"+hour;
            str = hour+":"+min;
         }
      }
      if(StringFind(str,"pm",0)>=0){
         if(StringLen(str)<7){
            string hour = StringSubstr(str,0,StringLen(str)-5);
            
            if(StringToInteger(hour)>=12){ 
            hour = IntegerToString((StringToInteger(hour)-12)); 
            }else{ hour = IntegerToString((StringToInteger(hour)+12));  }
            
            string min = StringSubstr(str,2,2);
            hour = IntegerToString((StringToInteger(hour)+OffsetHours));
            if(StringToInteger(hour)>=24){
               hour = IntegerToString(StringToInteger(hour)-24);
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)+(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<0){
               hour = IntegerToString(24-MathAbs(StringToInteger(hour)));
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)-(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<10) hour = "0"+hour;
            str = hour+":"+min;
         }
         if(StringLen(str)>=7){ 
            string hour = StringSubstr(str,0,StringLen(str)-5);
            if(StringToInteger(hour)>=12){ 
               hour = IntegerToString(StringToInteger(hour)); 
            }else{ hour = IntegerToString((StringToInteger(hour)+12));  }
            
            string min = StringSubstr(str,3,2);
            hour = IntegerToString((StringToInteger(hour)+OffsetHours));
            if(StringToInteger(hour)>=24){
               hour = IntegerToString(StringToInteger(hour)-24);
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)+(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<0){
               hour = IntegerToString(24-MathAbs(StringToInteger(hour)));
               WeeklyNews[array].date = TimeToStr(StringToTime(WeeklyNews[array].date)-(60*60*24),TIME_DATE);
            }
            if(StringToInteger(hour)<10) hour = "0"+hour;
            str = hour+":"+min;
         }
      }
   }
   return str;
}
void ShowNewsOnDisplay(){
   for(int i=1;i<200;i++){
      if(ObjectFind(0,"Impact")!=0) ObjectDelete(0,"Impact"+IntegerToString(i));
      if(ObjectFind(0,"Date")!=0) ObjectDelete(0,"Date"+IntegerToString(i));
      if(ObjectFind(0,"Time")!=0) ObjectDelete(0,"Time"+IntegerToString(i));
      if(ObjectFind(0,"Country")!=0) ObjectDelete(0,"Country"+IntegerToString(i));
      if(ObjectFind(0,"Title")!=0) ObjectDelete(0,"Title"+IntegerToString(i));
   }
   int x=10,y=6;
   LabelNewsCreate("Sponsor",10,10,CORNER_LEFT_LOWER,"NEWS FOREX CALENDAR",10,clrGold,ANCHOR_LEFT_LOWER);
   for(int i=0;i<index_WeeklyNews;i++){
      if(StringToTime(WeeklyNews[i].date+" "+WeeklyNews[i].time)>=TimeCurrent()-(60*60*12) && StringToTime(WeeklyNews[i].date+" "+WeeklyNews[i].time)<=TimeCurrent()+(60*60*12)){
         if((IncludeHigh && WeeklyNews[i].impact=="High") 
         || (IncludeMedium && WeeklyNews[i].impact=="Medium") 
         || (IncludeLow && WeeklyNews[i].impact=="Low")){
            if((ReportAllForAUD && WeeklyNews[i].country=="AUD") 
            || (ReportAllForCAD && WeeklyNews[i].country=="CAD") 
            || (ReportAllForCHF && WeeklyNews[i].country=="CHF") 
            || (ReportAllForEUR && WeeklyNews[i].country=="EUR") 
            || (ReportAllForGBP && WeeklyNews[i].country=="GBP") 
            || (ReportAllForJPY && WeeklyNews[i].country=="JPY") 
            || (ReportAllForNZD && WeeklyNews[i].country=="NZD") 
            || (ReportAllForUSD && WeeklyNews[i].country=="USD")
            || (ReportAllForCNY && WeeklyNews[i].country=="CNY")
            ){
                  int len = 0;
                  string impact = WeeklyNews[i].impact;
                  color impact_col = clrRed;
                  if(impact=="Low"){ impact_col = TxtColorImpactLow;}
                  if(impact=="Medium"){ impact_col = TxtColorImpactMedium;}
                  if(impact=="High"){ impact_col = TxtColorImpactHigh;}
                  LabelNewsCreate("Impact"+IntegerToString(i),x,y+20,CORNER_LEFT_LOWER,"["+WeeklyNews[i].impact+"]",8,impact_col,ANCHOR_LEFT_LOWER);
                  len = 45;
                  LabelNewsCreate("Date"+IntegerToString(i),x+len,y+20,CORNER_LEFT_LOWER,"["+WeeklyNews[i].date+"]",8,TxtColorDate,ANCHOR_LEFT_LOWER);
                  len += (int)(StringLen("["+WeeklyNews[i].date+"]")*5.2);
                  LabelNewsCreate("Time"+IntegerToString(i),x+len,y+20,CORNER_LEFT_LOWER,"["+WeeklyNews[i].time+"]",8,TxtColorTime,ANCHOR_LEFT_LOWER);
                  len += (int)(StringLen("["+WeeklyNews[i].time+"]")*5.2);
                  LabelNewsCreate("Country"+IntegerToString(i),x+len,y+20,CORNER_LEFT_LOWER,"["+WeeklyNews[i].country+"]",8,TxtColorCountry,ANCHOR_LEFT_LOWER);
                  len += (int)(StringLen("["+WeeklyNews[i].country+"]")*6.1);
                  LabelNewsCreate("Title"+IntegerToString(i),x+len,y+20,CORNER_LEFT_LOWER,"["+WeeklyNews[i].title+"]",8,TxtColorTitle,ANCHOR_LEFT_LOWER);
                  y+=12;
               
            }     
         }
      }
   }
}
int RangeOfNews(){  
   int count = 0;
   for(int i=0;i<index_WeeklyNews;i++){
      if(StringToTime(WeeklyNews[i].date+" "+WeeklyNews[i].time)>=TimeCurrent()-(60*StopTrade_BeforeNews_Min) 
      && StringToTime(WeeklyNews[i].date+" "+WeeklyNews[i].time)<=TimeCurrent()+(60*ContinueTrade_AfterNews_Min)){
         if((IncludeHigh && WeeklyNews[i].impact=="High") 
         || (IncludeMedium && WeeklyNews[i].impact=="Medium") 
         || (IncludeLow && WeeklyNews[i].impact=="Low")){
            if((ReportAllForAUD && WeeklyNews[i].country=="AUD") 
            || (ReportAllForCAD && WeeklyNews[i].country=="CAD") 
            || (ReportAllForCHF && WeeklyNews[i].country=="CHF") 
            || (ReportAllForEUR && WeeklyNews[i].country=="EUR") 
            || (ReportAllForGBP && WeeklyNews[i].country=="GBP") 
            || (ReportAllForJPY && WeeklyNews[i].country=="JPY") 
            || (ReportAllForNZD && WeeklyNews[i].country=="NZD") 
            || (ReportAllForUSD && WeeklyNews[i].country=="USD")
            || (ReportAllForCNY && WeeklyNews[i].country=="CNY")
            ){
               count++;
            }
         }
      }
   }
   return count;
}
void LabelNewsCreate(const string        name="Label",             // label name 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER // anchor type
                 )           
  { 
   const long chart_ID=0;
   const int sub_window=0;
   ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
} 

void LineNotify(string token,string Massage){
   string headers;
   char post[], result[];
   headers="Authorization: Bearer "+token+"\r\n";
   headers+="Content-Type: application/x-www-form-urlencoded\r\n";
   ArrayResize(post,StringToCharArray("message="+Massage,post,0,WHOLE_ARRAY,CP_UTF8)-1);
   int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 10000, post, result, headers);
   Print("Status code: " , res, ", error: ", GetLastError());
   Print("Server response: ", CharArrayToString(result));
}

double getHistoryProfit()
{
   double _profit = 0;
   for(int i=OrdersHistoryTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)){
         if(OrderType()<=OP_SELL){
            _profit += OrderProfit()+OrderSwap()+OrderCommission();
         }
      }
   }
   return _profit;
}
int lastTotal = 0;
double lastProfit = 0;

void functionLineNotify()
{
   if(!Use_LineNotify) return;
   if(lastTotal != countAllTotal())
   {
      string message = "",endl="\n";
      message += "ระบบ EA v2.1 News+Line แจ้งเตือนรายละเอียดดังนี้";
      message += "AccountNumber : "+IntegerToString(AccountNumber())+endl;
      message += "HistoryProfit : "+DoubleToStr(getHistoryProfit(),2)+endl;
      message += "Balance : "+DoubleToStr(AccountBalance(),2)+endl;
      message += "Equity : "+DoubleToStr(AccountEquity(),2)+endl;
      message += "Profit : "+DoubleToStr(AccountProfit(),2)+endl;
      
      int cntS1=0,cntS2=0,cntS3=0;
      for(int i=OrdersTotal()-1;i>=0;i--){
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
            if(OrderSymbol()==Symbol1) cntS1++;
            if(OrderSymbol()==Symbol2) cntS2++;
            if(OrderSymbol()==Symbol3) cntS3++;
         }
      }
      
      message += Symbol1+" : "+IntegerToString(cntS1)+endl;
      message += Symbol2+" : "+IntegerToString(cntS2)+endl;
      message += Symbol3+" : "+IntegerToString(cntS3)+endl;
      
      LineNotify(line_token,message);
      lastTotal = countAllTotal();
   }
}



string Comments = "WindowsRoot";

datetime lastTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   EventSetTimer(1);
   lastTime = iTime(Symbol1,0,1);
   if(!IsDllsAllowed() && !IsTesting())
   {
      Alert("Error : Please Allow Dll");
      Print("Error : Please Allow Dll");
   }
   if(!IsTesting()){
      LastTimeUpdateNewsMinutes = TimeCurrent();
      GetWeeklyNews();
      ShowNewsOnDisplay();
   }
   
   
return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
      
}


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
double getMA(string _symbol,int _shift)
{
   return iMA(_symbol,TimeFrame_MA,Period_MA,Shift_MA,Method_MA,Price_MA,_shift);
}

int countTotal(string _symbol,int _type)
{
   int _count = 0;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol()==_symbol && OrderType()==_type && OrderMagicNumber()==MagicNumber){
            _count++;
         }
      }
   }
   return _count;
}
int countAllTotal()
{
   int _count = 0;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderType()<=OP_SELL && OrderMagicNumber()==MagicNumber){
            _count++;
         }
      }
   }
   return _count;
}

void functionOpenOrder()
{
   //Buy
   if( iClose(Symbol1,0,1) > getMA(Symbol1,1) && 
       iClose(Symbol2,0,1) > getMA(Symbol2,1) &&(OrdersTotal()<MaxOrder) &&  
       (iClose(Symbol3,0,1) > getMA(Symbol3,1) || iClose(Symbol3,0,1) < getMA(Symbol3,1)) )
   {
      if( iOpen(Symbol1,0,1) < getMA(Symbol1,1) || 
          iOpen(Symbol2,0,1) < getMA(Symbol2,1) ||(OrdersTotal()<MaxOrder) && 
          (iClose(Symbol3,0,1) > getMA(Symbol3,1) && iOpen(Symbol3,0,1) < getMA(Symbol3,1) ) ||
          (iClose(Symbol3,0,1) < getMA(Symbol3,1) && iOpen(Symbol3,0,1) > getMA(Symbol3,1) ) )
      {
         if(lastTime<iTime(Symbol1,0,1) && (!Use_NewsAvoid || IsTesting() || (Use_NewsAvoid && RangeOfNews()==0)))
         {
            if(countTotal(Symbol1,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol1,MODE_ASK);
               int ticket = OrderSend(Symbol1,OP_BUY,Lot1,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol2,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol2,MODE_ASK);
               int ticket = OrderSend(Symbol2,OP_BUY,Lot2,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol3,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol3,MODE_ASK);
               int ticket = OrderSend(Symbol3,OP_BUY,Lot3,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
         }
      }
   }
   //Sell
   if( iClose(Symbol2,0,1) < getMA(Symbol2,1) && 
       iClose(Symbol3,0,1) < getMA(Symbol3,1) && (OrdersTotal()<MaxOrder)&& 
       (iClose(Symbol1,0,1) < getMA(Symbol1,1) || iClose(Symbol1,0,1) > getMA(Symbol1,1)) )
   {
      if( iOpen(Symbol2,0,1) > getMA(Symbol2,1) || 
          iOpen(Symbol3,0,1) > getMA(Symbol3,1) ||(OrdersTotal()<MaxOrder)&& 
          (iClose(Symbol1,0,1) < getMA(Symbol1,1) && iOpen(Symbol1,0,1) > getMA(Symbol1,1) ) ||
          (iClose(Symbol1,0,1) > getMA(Symbol1,1) && iOpen(Symbol1,0,1) < getMA(Symbol1,1) ) )
      {
         if(lastTime<iTime(Symbol1,0,1) && (!Use_NewsAvoid || IsTesting() || (Use_NewsAvoid && RangeOfNews()==0)))
         {
            if(countTotal(Symbol1,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol1,MODE_BID);
               int ticket = OrderSend(Symbol1,OP_SELL,Lot1,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol2,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol2,MODE_BID);
               int ticket = OrderSend(Symbol2,OP_SELL,Lot2,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol3,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol3,MODE_BID);
               int ticket = OrderSend(Symbol3,OP_SELL,Lot3,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
               if(ticket<0)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
               lastTime = iTime(Symbol1,0,1);
            }
         }
      }
   }
}

double countAllProfit()
{
   double _profit = 0;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderType()<=OP_SELL && OrderMagicNumber()==MagicNumber){
            _profit += OrderProfit()+OrderCommission()+OrderSwap();
         }
      }
   }
   return _profit;
}
void functionCloseAll()
{
   bool result = false;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderMagicNumber()==MagicNumber){
            result = true;
            if(OrderType()==OP_BUY)
            {
               result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),Slippage,clrNONE);
               if(!result)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
            }
            else if(OrderType()==OP_SELL)
            {
               result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),Slippage,clrNONE);
               if(!result)
               {
                  Print("Error : "+getLastError(GetLastError()));
               }
            }
         }
      }
   }
}

void functionCloseOrder()
{
   if(countAllProfit()>=MathAbs(ProfitTarget)){
      functionCloseAll();
   }
   if(countAllProfit()<=-MathAbs(CutLossTarget)){
      functionCloseAll();
   }
}


void OnTimer()
{
   functionShowComment();
   ShowDisplayFunction();
   functionOpenOrder();
   functionCloseOrder();
   
   functionLineNotify();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(AllowTimeUpdateNews && !IsTesting()){
      if(LastTimeUpdateNewsMinutes < (TimeCurrent()-(60*TimeUpdateNewsMinutes))){
         GetWeeklyNews();
         LastTimeUpdateNewsMinutes = TimeCurrent();
      }
   }
   functionShowComment();
   ShowDisplayFunction();
   functionOpenOrder();
   functionCloseOrder();
   
   functionLineNotify();
}

//+------------------------------------------------------------------+

void functionShowComment()
{
   string str="",endl="\n";
   int dig1,dig2,dig3;
   dig1=(int)MarketInfo(Symbol1,MODE_DIGITS);
   dig2=(int)MarketInfo(Symbol2,MODE_DIGITS);
   dig3=(int)MarketInfo(Symbol3,MODE_DIGITS);
   str += Symbol1+" MA["+DoubleToStr(getMA(Symbol1,1),dig1)+"]";
   str += " Open["+DoubleToStr(iOpen(Symbol1,0,1),dig1)+"]";
   str += " Close["+DoubleToStr(iClose(Symbol1,0,1),dig1)+"]"+endl;
   str += Symbol2+" MA["+DoubleToStr(getMA(Symbol2,1),dig2)+"]";
   str += " Open["+DoubleToStr(iOpen(Symbol2,0,1),dig2)+"]";
   str += " Close["+DoubleToStr(iClose(Symbol2,0,1),dig2)+"]"+endl;
   str += Symbol3+" MA["+DoubleToStr(getMA(Symbol3,1),dig3)+"]";
   str += " Open["+DoubleToStr(iOpen(Symbol3,0,1),dig3)+"]";
   str += " Close["+DoubleToStr(iClose(Symbol3,0,1),dig3)+"]"+endl;
   Comment(str);
}


double MaxDrawDown=0,MaxDD=0;
void ShowDisplayFunction(){ 
   int Total=0,HistoryTrade=0;
   double profit=0,HistoryLot=0;
   int x_dis=0,y_dis=05;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderMagicNumber()==MagicNumber){
            Total++;
            profit+=OrderProfit()+OrderCommission()+OrderSwap();
         }
      }
   }
   for(int i =OrdersHistoryTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)){
         if(OrderType()<=OP_SELL && OrderMagicNumber()==MagicNumber){
            HistoryTrade++;
            HistoryLot+=OrderLots();
         }
      }
   }
   double PercentProfit = ((profit/(AccountBalance()+AccountCredit()))*100);
   if(PercentProfit<=MaxDrawDown){
      MaxDrawDown = PercentProfit;
   }
   if(MaxDD>=profit){
      MaxDD=profit;
   }
   LabelCreate("EAName",5+x_dis,20+20*0+y_dis,CORNER_RIGHT_UPPER,Comments,"Arail",12,clrLightGray);
   LabelCreate("Name",5+x_dis,20+20*1+y_dis,CORNER_RIGHT_UPPER,"Name : "+AccountName(),"Arail",12,clrTurquoise);
   LabelCreate("Leverage",5+x_dis,20+20*2+y_dis,CORNER_RIGHT_UPPER,"Laverage : "+IntegerToString(AccountLeverage()),"Arail",12,clrTurquoise);
   LabelCreate("Balance",5+x_dis,20+20*3+y_dis,CORNER_RIGHT_UPPER,"Balance : "+DoubleToStr(AccountBalance(),2)+" USD","Arail",11,clrTurquoise);
   LabelCreate("Equity",5+x_dis,20+20*4+y_dis,CORNER_RIGHT_UPPER,"Equity : "+DoubleToStr(AccountEquity(),2)+" USD","Arail",11,clrTurquoise);
   LabelCreate("LotHistory",5+x_dis,20+20*5+y_dis,CORNER_RIGHT_UPPER,"Lot History : "+DoubleToStr(HistoryLot,2),"Arail",11,clrTurquoise);
   LabelCreate("TotalHistory",5+x_dis,20+20*6+y_dis,CORNER_RIGHT_UPPER,"Total History : "+IntegerToString(HistoryTrade),"Arail",11,clrTurquoise);
   LabelCreate("Total",5+x_dis,20+20*7+y_dis,CORNER_RIGHT_UPPER,"Total : "+IntegerToString(Total),"Arail",11,clrWhite);
   LabelCreate("MaxDD",5+x_dis,20+20*8+y_dis,CORNER_RIGHT_UPPER,"%MAX DD : "+DoubleToStr(MaxDrawDown,4)+"%","Arail",11,clrRed);
   LabelCreate("MaxDD2",5+x_dis,20+20*9+y_dis,CORNER_RIGHT_UPPER,DoubleToStr(MaxDD,2)+" USD","Arail",11,clrRed);
   color color_profit = clrLime;
   if(profit<0) color_profit = clrRed;
   LabelCreate("Profit",5+x_dis,20+20*10+y_dis,CORNER_RIGHT_UPPER,"Profit : "+DoubleToStr(profit,2)+" USD","Arail",15,color_profit); 
   
}
void LabelCreate(const string            name="Label",             // label name 
                 const int               x=0,                      // X coordinate 
                 const int               y=0,                      // Y coordinate 
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                 const string            text="Label",             // text 
                 const string            font="Arial",             // font 
                 const int               font_size=10,             // font size 
                 const color             clr=clrRed,               // color 
                 const double            angle=0.0,                // text slope 
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_RIGHT_UPPER, // anchor type 
                 const bool              back=false,               // in the background 
                 const bool              selection=false,          // highlight to move 
                 const bool              hidden=true,              // hidden in the object list 
                 const long              z_order=0)                // priority for mouse click 
  { 
   const long  chart_ID=0;
   const int sub_window=0;
   ResetLastError(); 
   if(ObjectFind(chart_ID,name)==-1){
      ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);  
} 
void ButtonCreate(const string            name="Button",            // button name 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="Button",            // text 
                  const string            font="Arial",             // font 
                  const int               font_size=10,             // font size 
                  const color             clr=clrBlack,             // text color 
                  const color             back_clr=C'236,233,216',  // background color 
                  const color             border_clr=clrNONE,       // border color 
                  const bool              state=false,              // pressed/released 
                  const bool              back=false,               // in the background 
                  const bool              selection=false,          // highlight to move 
                  const bool              hidden=true,              // hidden in the object list 
                  const long              z_order=0)                // priority for mouse click 
  { 
   const long  chart_ID=0;
   const int sub_window=0;
   ResetLastError(); 
   if(ObjectFind(chart_ID,name)==-1){
      ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);  
}
string getLastError(int numCode)
{
   switch(numCode)
   {
      //case	0	: return "	No error returned	"; break;
      //case	1	: return "	No error returned, but the result is unknown	"; break;
      case	2	: return "	Common error	"; break;
      case	3	: return "	Invalid trade parameters	"; break;
      case	4	: return "	Trade server is busy	"; break;
      case	5	: return "	Old version of the client terminal	"; break;
      case	6	: return "	No connection with trade server	"; break;
      case	7	: return "	Not enough rights	"; break;
      case	8	: return "	Too frequent requests	"; break;
      case	9	: return "	Malfunctional trade operation	"; break;
      case	64	: return "	Account disabled	"; break;
      case	65	: return "	Invalid account	"; break;
      case	128	: return "	Trade timeout	"; break;
      case	129	: return "	Invalid price	"; break;
      case	130	: return "	Invalid stops	"; break;
      case	131	: return "	Invalid trade volume	"; break;
      case	132	: return "	Market is closed	"; break;
      case	133	: return "	Trade is disabled	"; break;
      case	134	: return "	Not enough money	"; break;
      case	135	: return "	Price changed	"; break;
      case	136	: return "	Off quotes	"; break;
      case	137	: return "	Broker is busy	"; break;
      case	138	: return "	Requote	"; break;
      case	139	: return "	Order is locked	"; break;
      case	140	: return "	Buy orders only allowed	"; break;
      case	141	: return "	Too many requests	"; break;
      case	145	: return "	Modification denied because order is too close to market	"; break;
      case	146	: return "	Trade context is busy	"; break;
      case	147	: return "	Expirations are denied by broker	"; break;
      case	148	: return "	The amount of open and pending orders has reached the limit set by the broker	"; break;
      case	149	: return "	An attempt to open an order opposite to the existing one when hedging is disabled	"; break;
      case	150	: return "	An attempt to close an order contravening the FIFO rule	"; break;
      case	4000	: return "	No error returned	"; break;
      case	4001	: return "	Wrong function pointer	"; break;
      case	4002	: return "	Array index is out of range	"; break;
      case	4003	: return "	No memory for function call stack	"; break;
      case	4004	: return "	Recursive stack overflow	"; break;
      case	4005	: return "	Not enough stack for parameter	"; break;
      case	4006	: return "	No memory for parameter string	"; break;
      case	4007	: return "	No memory for temp string	"; break;
      case	4008	: return "	Not initialized string	"; break;
      case	4009	: return "	Not initialized string in array	"; break;
      case	4010	: return "	No memory for array string	"; break;
      case	4011	: return "	Too long string	"; break;
      case	4012	: return "	Remainder from zero divide	"; break;
      case	4013	: return "	Zero divide	"; break;
      case	4014	: return "	Unknown command	"; break;
      case	4015	: return "	Wrong jump (never generated error)	"; break;
      case	4016	: return "	Not initialized array	"; break;
      case	4017	: return "	DLL calls are not allowed	"; break;
      case	4018	: return "	Cannot load library	"; break;
      case	4019	: return "	Cannot call function	"; break;
      case	4020	: return "	Expert function calls are not allowed	"; break;
      case	4021	: return "	Not enough memory for temp string returned from function	"; break;
      case	4022	: return "	System is busy (never generated error)	"; break;
      case	4023	: return "	DLL-function call critical error	"; break;
      case	4024	: return "	Internal error	"; break;
      case	4025	: return "	Out of memory	"; break;
      case	4026	: return "	Invalid pointer	"; break;
      case	4027	: return "	Too many formatters in the format function	"; break;
      case	4028	: return "	Parameters count exceeds formatters count	"; break;
      case	4029	: return "	Invalid array	"; break;
      case	4030	: return "	No reply from chart	"; break;
      case	4050	: return "	Invalid function parameters count	"; break;
      case	4051	: return "	Invalid function parameter value	"; break;
      case	4052	: return "	String function internal error	"; break;
      case	4053	: return "	Some array error	"; break;
      case	4054	: return "	Incorrect series array using	"; break;
      case	4055	: return "	Custom indicator error	"; break;
      case	4056	: return "	Arrays are incompatible	"; break;
      case	4057	: return "	Global variables processing error	"; break;
      case	4058	: return "	Global variable not found	"; break;
      case	4059	: return "	Function is not allowed in testing mode	"; break;
      case	4060	: return "	Function is not allowed for call	"; break;
      case	4061	: return "	Send mail error	"; break;
      case	4062	: return "	String parameter expected	"; break;
      case	4063	: return "	Integer parameter expected	"; break;
      case	4064	: return "	Double parameter expected	"; break;
      case	4065	: return "	Array as parameter expected	"; break;
      case	4066	: return "	Requested history data is in updating state	"; break;
      case	4067	: return "	Internal trade error	"; break;
      case	4068	: return "	Resource not found	"; break;
      case	4069	: return "	Resource not supported	"; break;
      case	4070	: return "	Duplicate resource	"; break;
      case	4071	: return "	Custom indicator cannot initialize	"; break;
      case	4072	: return "	Cannot load custom indicator	"; break;
      case	4073	: return "	No history data	"; break;
      case	4074	: return "	No memory for history data	"; break;
      case	4075	: return "	Not enough memory for indicator calculation	"; break;
      case	4099	: return "	End of file	"; break;
      case	4100	: return "	Some file error	"; break;
      case	4101	: return "	Wrong file name	"; break;
      case	4102	: return "	Too many opened files	"; break;
      case	4103	: return "	Cannot open file	"; break;
      case	4104	: return "	Incompatible access to a file	"; break;
      case	4105	: return "	No order selected	"; break;
      case	4106	: return "	Unknown symbol	"; break;
      case	4107	: return "	Invalid price	"; break;
      case	4108	: return "	Invalid ticket	"; break;
      case	4109	: return "	Trade is not allowed. Enable checkbox [Allow live trading] in the Expert Advisor properties	"; break;
      case	4110	: return "	Longs are not allowed. Check the Expert Advisor properties	"; break;
      case	4111	: return "	Shorts are not allowed. Check the Expert Advisor properties	"; break;
      case	4112	: return "	Automated trading by Expert Advisors/Scripts disabled by trade server	"; break;
      case	4200	: return "	Object already exists	"; break;
      case	4201	: return "	Unknown object property	"; break;
      case	4202	: return "	Object does not exist	"; break;
      case	4203	: return "	Unknown object type	"; break;
      case	4204	: return "	No object name	"; break;
      case	4205	: return "	Object coordinates error	"; break;
      case	4206	: return "	No specified subwindow	"; break;
      case	4207	: return "	Graphical object error	"; break;
      case	4210	: return "	Unknown chart property	"; break;
      case	4211	: return "	Chart not found	"; break;
      case	4212	: return "	Chart subwindow not found	"; break;
      case	4213	: return "	Chart indicator not found	"; break;
      case	4220	: return "	Symbol select error	"; break;
      case	4250	: return "	Notification error	"; break;
      case	4251	: return "	Notification parameter error	"; break;
      case	4252	: return "	Notifications disabled	"; break;
      case	4253	: return "	Notification send too frequent	"; break;
      case	4260	: return "	FTP server is not specified	"; break;
      case	4261	: return "	FTP login is not specified	"; break;
      case	4262	: return "	FTP connection failed	"; break;
      case	4263	: return "	FTP connection closed	"; break;
      case	4264	: return "	FTP path not found on server	"; break;
      case	4265	: return "	File not found in the MQL4\\Files directory to send on FTP server	"; break;
      case	4266	: return "	Common error during FTP data transmission	"; break;
      case	5001	: return "	Too many opened files	"; break;
      case	5002	: return "	Wrong file name	"; break;
      case	5003	: return "	Too long file name	"; break;
      case	5004	: return "	Cannot open file	"; break;
      case	5005	: return "	Text file buffer allocation error	"; break;
      case	5006	: return "	Cannot delete file	"; break;
      case	5007	: return "	Invalid file handle (file closed or was not opened)	"; break;
      case	5008	: return "	Wrong file handle (handle index is out of handle table)	"; break;
      case	5009	: return "	File must be opened with FILE_WRITE flag	"; break;
      case	5010	: return "	File must be opened with FILE_READ flag	"; break;
      case	5011	: return "	File must be opened with FILE_BIN flag	"; break;
      case	5012	: return "	File must be opened with FILE_TXT flag	"; break;
      case	5013	: return "	File must be opened with FILE_TXT or FILE_CSV flag	"; break;
      case	5014	: return "	File must be opened with FILE_CSV flag	"; break;
      case	5015	: return "	File read error	"; break;
      case	5016	: return "	File write error	"; break;
      case	5017	: return "	String size must be specified for binary file	"; break;
      case	5018	: return "	Incompatible file (for string arrays-TXT, for others-BIN)	"; break;
      case	5019	: return "	File is directory not file	"; break;
      case	5020	: return "	File does not exist	"; break;
      case	5021	: return "	File cannot be rewritten	"; break;
      case	5022	: return "	Wrong directory name	"; break;
      case	5023	: return "	Directory does not exist	"; break;
      case	5024	: return "	Specified file is not directory	"; break;
      case	5025	: return "	Cannot delete directory	"; break;
      case	5026	: return "	Cannot clean directory	"; break;
      case	5027	: return "	Array resize error	"; break;
      case	5028	: return "	String resize error	"; break;
      case	5029	: return "	Structure contains strings or dynamic arrays	"; break;
      case	5200	: return "	Invalid URL	"; break;
      case	5201	: return "	Failed to connect to specified URL	"; break;
      case	5202	: return "	Timeout exceeded	"; break;
      case	5203	: return "	HTTP request failed	"; break;
      case	65536	: return "	User defined errors start with this code	"; break;
      default: return ""; break;
   }
   return "";
}