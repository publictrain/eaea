//+------------------------------------------------------------------+
//|                                                         移動平均.mq4 |
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

double fast0,slow0,fast1,slow1;




input int TP =400;
input int SL =200;



int pos_ptr;
int fast=19;
int slow=39;
int magic=23232323;

double ea_order_stop_price,ea_order_good_price;
bool want_longs,want_shorts;

double rsi;


int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   fast0 = iMA(NULL, 0, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
   slow0 = iMA(NULL, 0, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
   fast1 = iMA(NULL, 0, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
   slow1 = iMA(NULL, 0, 50, 0, MODE_EMA, PRICE_CLOSE, 1);
   
   
   for(int i=0;i<10;i++)
     {
     rsi = iRSI(
                   NULL,           // 通貨ペア
                   0,              // 時間軸
                   14,             // 平均期間
                   PRICE_CLOSE,  // 適用価格
                   i // シフト
                ); 
          
   
     want_longs=false;
     want_shorts=false;
     pos_ptr=-1;
     
     
     if(slow1>fast1 && fast0>slow0)//買い
     {
         pos_ptr=1;
         
     }else if(slow1<fast1 && fast0<slow0)//売り
     {
         pos_ptr=0;

     }else
     {
         pos_ptr=-1;//なにもしない
     }
     

     
     }
     
     
     if(pos_ptr==1)
     {
         want_longs = true;
         ea_order_stop_price =  Ask - SL * Point;  //損切りポイント
         ea_order_good_price = Ask + TP * Point;  //利喰いポイント
     
     }else if(pos_ptr==0)
     {
         want_shorts = true;
         ea_order_stop_price = Bid + SL * Point;  //損切りポイント
         ea_order_good_price = Bid - TP * Point;  //利喰いポイント 
     }
     
     
     if(want_longs)
     {

         if(OrdersTotal()==0)
         {
            int buy = OrderSend(
            Symbol(),
            OP_BUY,//買い注文
            0.1,
            Ask,
            40,
            ea_order_stop_price,//損切り価格
            ea_order_good_price,//利確
            "買った",
            magic,
            0,
            clrRed
            );
         }
     }
     
     if(want_shorts)
     {

         if(OrdersTotal()==0)
         {
            int sell = OrderSend(
            Symbol(),
            OP_SELL,//売り注文
            0.1,
            Bid,
            40,
            ea_order_stop_price,//損切り価格
            ea_order_good_price,//利確
            "売った",
            magic,
            0,
            clrBlue
            );
         }
     }
     
     
  }
//+------------------------------------------------------------------+
