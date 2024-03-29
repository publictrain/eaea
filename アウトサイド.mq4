//+------------------------------------------------------------------+
//|                                                      トレンドの流れ.mq4 |
//|                                                           myamya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "myamya"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int magic = 123456;
double lot;
double before0candle_end,before1candle_end,
before0candle_start,before1candle_start,
before0candle_high,before1candle_high,
before0candle_low,before1candle_low;

double rsi;

input int TP =180;

extern double Lot_Multipiler = 2.0;//マーチンゲール法を実行するときの倍率
extern double Base_Lot_Size = 0.02;//最初のロットサイズ
extern int Max_Martingale = 20;//最大実行回数



/*
double Base_Lots
マーチンゲール法を実行する際の、最初のロットサイズを指定します。
double Multiplier
負けトレードの次のトレードのロットサイズを、前回のトレードのロットサイズの何倍にするかを指定します。
int Max
マーチンゲール法を実行する最大回数を指定します。
*/
double Martingale(double Base_Lots,double Multipiler,int Max)
{
int Loss_Count = 0;//Loss_Countは、直近のトレードの連敗回数を格納する変数です。
for (int i=OrdersHistoryTotal()-1;i>=0;i--)
   {
   if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
      {
      if(OrderMagicNumber()==magic&&OrderSymbol()==Symbol())//
         {
         if(OrderProfit()<=0)//選択した注文の利益額（スワップや手数料は考慮しません。）を取得するもの
            {
            Loss_Count++;
            }else if(OrderProfit()>0)
            {
            break;
            }
          }
       }
    }  
     
if(Loss_Count >=Max)
{
   Loss_Count=Max;
}

double Lots = Base_Lots*MathPow(Multipiler,Loss_Count);//MathPowは乗数
if(Lots >=MarketInfo(Symbol(),MODE_MAXLOT))
{
Lots=MarketInfo(Symbol(),MODE_MAXLOT);
}

return(Lots);
}
            
         
   
 
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  /*
     for(int icount=0; icount<4;icount++)
     {
      rsi = iRSI(
              NULL,           // 通貨ペア
              0,              // 時間軸
              14,             // 平均期間
              PRICE_CLOSE,  // 適用価格
              0 // シフト
             );   
     
     }
      */
                
                
      before0candle_start = iOpen(NULL,0,0);
      before1candle_start = iOpen(NULL,0,1);
      

      before0candle_end = iClose(NULL,0,0);
      before1candle_end = iClose(NULL,0,1);
      

      before0candle_high = iHigh(NULL,0,0);
      before1candle_high = iHigh(NULL,0,1);
      

      before0candle_low = iLow(NULL,0,0);
      before1candle_low = iLow(NULL,0,1);
      
      if(before1candle_end-before1candle_start>0.08 )//陽線
      {
         if(OrdersTotal()==0)
         {
            lot = Martingale(Base_Lot_Size,Lot_Multipiler,Max_Martingale);
            int buy = OrderSend(
            Symbol(),
            OP_BUY,//買い注文
            lot,
            before0candle_start,
            40,
            before1candle_low,//損切り価格
            before0candle_start + (TP*_Point),//利確
            "買った",
            magic,
            0,
            clrRed
            );
         }
      }else if(before1candle_start-before1candle_end>0.08)//陰線
      {
         if(OrdersTotal()==0)
         {
            lot=Martingale(Base_Lot_Size,Lot_Multipiler,Max_Martingale);
            int sell = OrderSend(
            Symbol(),
            OP_SELL,//売り注文
            lot,
            before0candle_start,
            40,
            before1candle_high,//損切り価格
            before0candle_start - (TP*_Point),//利確
            "売った",
            magic,
            0,
            clrBlue
            );
         }
      
      
      }
   
  }
//+------------------------------------------------------------------+
