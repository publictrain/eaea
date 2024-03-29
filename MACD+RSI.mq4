//+------------------------------------------------------------------+
//|                                                     GMMAみやざき.mq4 |
//|                                                           myamya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "myamya"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


int magic = 12345;

double EMA34;
double Macd0,Macd1,Macd2;
double signal0,signal1,signal2;
double rsi;




input int TP =400;
input int SL =200;



int pos_ptr;
int fast=19;
int slow=39;

double ea_order_stop_price,ea_order_good_price;
bool want_longs,want_shorts;

int OnInit()
  {

   return(INIT_SUCCEEDED);
  }



void OnTick()
  {
     //EMA34=iMA(NULL,0,34,0,MODE_EMA,PRICE_CLOSE,0);
     Macd0=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_MAIN,0);
     Macd1=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_MAIN,1);
     Macd2=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_MAIN,2);
     signal0=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_SIGNAL,0);
     signal1=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_SIGNAL,1);
     signal2=iMACD(NULL,0,fast,slow,9,PRICE_CLOSE,MODE_SIGNAL,2);
    
    
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
     if(Macd1<signal1 && Macd0>signal0 && rsi<30)//買い
     {
         pos_ptr=1;
         
     }else if(Macd1>signal1 && Macd0<signal0 && rsi>70)//売り
     {
         pos_ptr=0;

     }else
     {
         pos_ptr=-1;//なにもしない
     }
     
     }//forの終わり
     
     
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
     
     
     
     if(OrdersTotal()>0)
     {
       for(int i = OrdersTotal() - 1; i >= 0; i--)
       {

        //保有ポジションを一つ選択
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
           {

            //選択したポジションが、実行されている通貨ペアと同じかどうかチェック
            if(OrderSymbol() == Symbol())
               {

                //選択したポジションが、この自動売買のマジックナンバーと同じかチェック
                if(OrderMagicNumber() == magic)
                   {
                     if(OrderType()==OP_BUY && pos_ptr == 0)
                      //ポジションを決済
                      {
                      bool orderClose = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 10, clrNONE);
                      }else if(OrderType()==OP_SELL && pos_ptr == 1)
                      {
                      bool orderClose = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 10, clrNONE);
                      }
                   }
               }
           }
       }
     
     }
     
     
     
   
  }
  
  
  

