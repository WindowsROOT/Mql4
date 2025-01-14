//+------------------------------------------------------------------+
//|                                                  WindowsRoot.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


input string SymbolSetting = "===========================";//• Symbol Setting
input string Symbol1 = "EURUSD";//• Symbol 1
input double Lot1 = 0.15;//• Lot 1
input string Symbol2 = "GBPUSD";//• Symbol 2
input double Lot2 = 0.1;//• Lot 2
input string Symbol3 = "USDCHF";//• Symbol 3
input double Lot3 = 0.25;//• Lot 3
input string TradingSetting = "===========================";//• Trading Setting
input int MagicNumber = 123456;//• Magic Number
input int Slippage = 3;//• Slippage
input string ProfitTargetSetting = "===========================";//• Profit Target Setting
input double ProfitTarget = 50;//• Profit Target
input string CutLossTargetSetting = "===========================";//• CutLoss Target Setting
input double CutLossTarget = 50;//• CutLoss Target
input string IndicatorSetting = "===========================";//• Indicator Setting
input int Period_MA = 10;//• Period MA
input ENUM_TIMEFRAMES TimeFrame_MA = PERIOD_H4;//• Time Frame MA
input int Shift_MA = 0;//• Shift MA
input ENUM_MA_METHOD Method_MA = MODE_EMA;//• Method MA
input ENUM_APPLIED_PRICE Price_MA = PRICE_CLOSE;//• Price MA
input string EndSetting = "=======================";

string Comments = "WindowsRoot";

datetime lastTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   EventSetTimer(1);
   lastTime = iTime(Symbol1,0,1);
   
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
       iClose(Symbol2,0,1) > getMA(Symbol2,1) && 
       (iClose(Symbol3,0,1) > getMA(Symbol3,1) || iClose(Symbol3,0,1) < getMA(Symbol3,1)) )
   {
      if( iOpen(Symbol1,0,1) < getMA(Symbol1,1) || 
          iOpen(Symbol2,0,1) < getMA(Symbol2,1) ||
          (iClose(Symbol3,0,1) > getMA(Symbol3,1) && iOpen(Symbol3,0,1) < getMA(Symbol3,1) ) ||
          (iClose(Symbol3,0,1) < getMA(Symbol3,1) && iOpen(Symbol3,0,1) > getMA(Symbol3,1) ) )
      {
         if(lastTime<iTime(Symbol1,0,1))
         {
            if(countTotal(Symbol1,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol1,MODE_ASK);
               int ticket = OrderSend(Symbol1,OP_BUY,Lot1,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol2,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol2,MODE_ASK);
               int ticket = OrderSend(Symbol2,OP_BUY,Lot2,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol3,OP_BUY)==0)
            {
               double openprice = MarketInfo(Symbol3,MODE_ASK);
               int ticket = OrderSend(Symbol3,OP_BUY,Lot3,openprice,Slippage,0,0,Comments,MagicNumber,0,clrLime);
               lastTime = iTime(Symbol1,0,1);
            }
         }
      }
   }
   //Sell
   if( iClose(Symbol2,0,1) < getMA(Symbol2,1) && 
       iClose(Symbol3,0,1) < getMA(Symbol3,1) && 
       (iClose(Symbol1,0,1) < getMA(Symbol1,1) || iClose(Symbol1,0,1) > getMA(Symbol1,1)) )
   {
      if( iOpen(Symbol2,0,1) > getMA(Symbol2,1) || 
          iOpen(Symbol3,0,1) > getMA(Symbol3,1) ||
          (iClose(Symbol1,0,1) < getMA(Symbol1,1) && iOpen(Symbol1,0,1) > getMA(Symbol1,1) ) ||
          (iClose(Symbol1,0,1) > getMA(Symbol1,1) && iOpen(Symbol1,0,1) < getMA(Symbol1,1) ) )
      {
         if(lastTime<iTime(Symbol1,0,1))
         {
            if(countTotal(Symbol1,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol1,MODE_BID);
               int ticket = OrderSend(Symbol1,OP_SELL,Lot1,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol2,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol2,MODE_BID);
               int ticket = OrderSend(Symbol2,OP_SELL,Lot2,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
               lastTime = iTime(Symbol1,0,1);
            }
            if(countTotal(Symbol3,OP_SELL)==0)
            {
               double openprice = MarketInfo(Symbol3,MODE_BID);
               int ticket = OrderSend(Symbol3,OP_SELL,Lot3,openprice,Slippage,0,0,Comments,MagicNumber,0,clrRed);
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
            if(OrderType()==OP_BUY)
            {
               result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),Slippage,clrNONE);
            }
            else if(OrderType()==OP_SELL)
            {
               result = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),Slippage,clrNONE);
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
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   functionShowComment();
   ShowDisplayFunction();
   functionOpenOrder();
   functionCloseOrder();
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
