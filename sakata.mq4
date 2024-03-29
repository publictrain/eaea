//+------------------------------------------------------------------+
//|                                                       sakata.mq4 |
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
double before3candle_end,before2candle_end,before1candle_end,before3candle_start,before2candle_start,before1candle_start,
before3candle_high,before2candle_high,before1candle_high,before3candle_low,before2candle_low,before1candle_low;
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnTick()
  {
      before3candle_start = iOpen(NULL,0,3);
      before2candle_start = iOpen(NULL,0,2);
      before1candle_start = iOpen(NULL,0,1);
      
      before3candle_end = iClose(NULL,0,3);
      before2candle_end = iClose(NULL,0,2);
      before1candle_end = iClose(NULL,0,1);
      
      before3candle_high = iHigh(NULL,0,3);
      before2candle_high = iHigh(NULL,0,2);
      before1candle_high = iHigh(NULL,0,1);
      
      before3candle_low = iLow(NULL,0,3);
      before2candle_low = iLow(NULL,0,2);
      before1candle_low = iLow(NULL,0,1);
      if(before3candle_end>before3candle_start)//三本前のローソク足終値＞3本前のローソク足の始値
      {
         if(before2candle_end>before2candle_start)//にほんまえの　ローソク足終値＞二本前のローソク足の始値
         {
            if(before1candle_end>before1candle_start)//一本前のローソク足終値＞一本前のローソク足の始値
            {
               if(before3candle_end>before2candle_start)//3本前のローソク足終値＞二本前のローソク足の始値
               {
                  if(before2candle_end>before1candle_start)//二本前のローソク足終値＞一本前のローソク足の始値
                  {
                        int sell = OrderSend(
                        Symbol(),
                        OP_BUY,//買い注文
                        0.1,
                        Ask,
                        20,
                        before1candle_high,//損切り価格
                        Ask + (30*_Point),//利確
                        "買った",
                        magic,
                        0,
                        clrRed
                        );
                           
                     }
                   }
               }
            }
         }
      

      if(before3candle_start>before3candle_end)//三本前のローソク足始値＞3本前のローソク足の終値
      {
         if(before2candle_start>before2candle_end)//にほんまえの　ローソク足始値＞二本前のローソク足の終値
         {
            if(before1candle_start>before1candle_end)//一本前のローソク足始値＞一本前のローソク足の終値
            {
               if(before3candle_end<before2candle_start)//3本前のローソク足終値＜二本前のローソク足の始値
               {
                  if(before2candle_end<before1candle_start)//二本前のローソク足終値＜一本前のローソク足の始値
                  {
                     if(OrdersTotal()==0)
                     {
                        int sell = OrderSend(
                        Symbol(),
                        OP_SELL,//売り注文
                        0.1,
                        Bid,
                        20,
                        before1candle_high,//損切り価格
                        Bid - (30*_Point),//利確
                        "売った",
                        magic,
                        0,
                        clrRed
                        );
                           
                     }
                   }
               }
            }
         }
      }
   }
//+------------------------------------------------------------------+
