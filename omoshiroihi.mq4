// GMMA
#property copyright "nyan"
#property link      ""
#property version   "1.00"
#property strict





input ENUM_APPLIED_PRICE MaPrice = PRICE_CLOSE; // 対象価格
int magic = 12345;

input int Period1 = 3;  // EMA1期間
input int Period2 = 5;  // EMA2期間
input int Period3 = 8;  // EMA3期間
input int Period4 = 10;  // EMA4期間
input int Period5 = 12;  // EMA5期間
input int Period6 = 15;  // EMA6期間
input int Period7 = 30;  // EMA7期間
input int Period8 = 35;  // EMA8期間
input int Period9 = 40;  // EMA9期間
input int Period10 = 45;  // EMA10期間
input int Period11 = 50;  // EMA11期間
input int Period12 = 60;  // EMA12期間



double ema1;
double ema2;
double ema3;
double ema4;
double ema5;
double ema6;
double ema7;
double ema8;
double ema9;
double ema10;
double ema11;
double ema12;






//------------------------------------------------------------------
//初期化
int OnInit()
{

   return (INIT_SUCCEEDED);
}

//------------------------------------------------------------------
//計算イベント
void OnTick()          
{


   int count_buy = 0;
   int count_sell = 0;

   //damiani戻り値が1のときトレンド
   for(int i = 0;i<4;i++)
   {//これはシフトだよーん

   ema1 = iMA(Symbol(), PERIOD_CURRENT, Period1, 0, MODE_EMA, MaPrice, i);
   ema2 = iMA(Symbol(), PERIOD_CURRENT, Period2, 0, MODE_EMA, MaPrice, i);
   ema3 = iMA(Symbol(), PERIOD_CURRENT, Period3, 0, MODE_EMA, MaPrice, i);
   ema4 = iMA(Symbol(), PERIOD_CURRENT, Period4, 0, MODE_EMA, MaPrice, i);
   ema5 = iMA(Symbol(), PERIOD_CURRENT, Period5, 0, MODE_EMA, MaPrice, i);
   ema6 = iMA(Symbol(), PERIOD_CURRENT, Period6, 0, MODE_EMA, MaPrice, i);
   ema7 = iMA(Symbol(), PERIOD_CURRENT, Period7, 0, MODE_EMA, MaPrice, i);
   ema8 = iMA(Symbol(), PERIOD_CURRENT, Period8, 0, MODE_EMA, MaPrice, i);
   ema9 = iMA(Symbol(), PERIOD_CURRENT, Period9, 0, MODE_EMA, MaPrice, i);
   ema10 = iMA(Symbol(), PERIOD_CURRENT, Period10, 0, MODE_EMA, MaPrice, i);
   ema11 = iMA(Symbol(), PERIOD_CURRENT, Period11, 0, MODE_EMA, MaPrice, i);
   ema12 = iMA(Symbol(), PERIOD_CURRENT, Period12, 0, MODE_EMA, MaPrice, i);
      

         if(ema1>ema2 && ema2>ema3 && ema3>ema4 && ema4>ema5 && ema5>ema6 && ema6>ema7 && ema7>ema8 && ema8>ema9 && ema9>ema10 && ema10>ema11 && ema11>ema12)
         {
         count_buy++;
         }else if(ema1<ema2 && ema2<ema3 && ema3<ema4 && ema4<ema5 && ema5<ema6 && ema6<ema7 && ema7<ema8 && ema8<ema9 && ema9<ema10 && ema10<ema11 && ema11<ema12)
         {
         count_sell++;
         }
      
   }

   if(OrdersTotal()==0 && count_buy==3)
   {
      int buy = OrderSend(
      Symbol(),
      OP_BUY,//買い注文
      0.1,
      Ask,
      20,
      Ask - (100*_Point),//損切り価格は50pip下回った時
      Ask + (800*_Point),//利確は20pip上がった時
      "買った",
      magic,
      0,
      clrRed
      );
   }else if(OrdersTotal()==0 && count_sell==3)
   {
      int sell = OrderSend(
      Symbol(),
      OP_SELL,//売り注文
      0.1,
      Bid,
      20,
      Bid + (100*_Point),//損切り価格は50pip下回った時
      Bid - (800*_Point),//利確は20pip上がった時
      "売った",
      magic,
      0,
      clrBlue
      );
    }
   
   

   
   


}
   
   

