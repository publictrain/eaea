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

int magic = 12345;
double before0candle_end,before1candle_end,
before0candle_start,before1candle_start,
before0candle_high,before1candle_high,
before0candle_low,before1candle_low;

double rsi;

input int TP =90;

 
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
      
                
                
      before0candle_start = iOpen(NULL,0,0);
      before1candle_start = iOpen(NULL,0,1);
      

      before0candle_end = iClose(NULL,0,0);
      before1candle_end = iClose(NULL,0,1);
      

      before0candle_high = iHigh(NULL,0,0);
      before1candle_high = iHigh(NULL,0,1);
      

      before0candle_low = iLow(NULL,0,0);
      before1candle_low = iLow(NULL,0,1);
      
      if(before1candle_end-before1candle_start>0.08 && rsi<30)//陽線
      {
         if(OrdersTotal()==0)
         {
            int buy = OrderSend(
            Symbol(),
            OP_BUY,//買い注文
            0.1,
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
      }else if(before1candle_start-before1candle_end>0.08 && rsi>70)//陰線
      {
         if(OrdersTotal()==0)
         {
            int sell = OrderSend(
            Symbol(),
            OP_SELL,//売り注文
            0.1,
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
