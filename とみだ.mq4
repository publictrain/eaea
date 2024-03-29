//+------------------------------------------------------------------+
//|                                                          とみだ.mq4 |
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




input int TP =800;
input int SL =400;
//input int TP =200;//最適化後
//input int SL =700;//最適化後
input int MA_Short_Period =5;//短期足MA
input int MA_Middle_Period =25;//中期足MA
input int MA_Long_Period =50;//長期足MA


int pos_ptr;
int fast=19;
int slow=39;
int magic=23232323;

double ea_order_stop_price,ea_order_good_price;
bool want_longs,want_shorts;

double stocha1,stocha2,stocha3,stocha4,stocha5,stocha6;
double rci75,rci100;
double Short_MA,Middle_MA,Long_MA;

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
//---
   Short_MA = iMA(NULL,0,MA_Short_Period,0,MODE_SMA,PRICE_CLOSE,1);//短期足MA
   Middle_MA = iMA(NULL,0,MA_Middle_Period,0,MODE_SMA,PRICE_CLOSE,1);//中期足MA
   Long_MA = iMA(NULL,0,MA_Long_Period,0,MODE_SMA,PRICE_CLOSE,1);//長期足MA
   
   
   rci75 = iRCI( 
               Symbol(),
               0,
               75,
               0
              );
              
   /*           
   rci100 = iRCI( 
            Symbol(),
            0,
            100,
            0
            );
   */
            
   stocha1 = iStochastic(
                             Symbol(),           // 通貨ペア
                             0,               // 時間軸
                             5,               // %K期間
                             3,               // %D期間
                             3,               // スローイング
                             MODE_SMA,       // 平均化メソッド
                             0,               // 価格(Low/HighまたはClose/Close)
                             MODE_MAIN,      // ラインインデックス
                             0 // シフト
                            ); 

   stocha2 = iStochastic(
                             Symbol(),           // 通貨ペア
                             0,               // 時間軸
                             5,               // %K期間
                             3,               // %D期間
                             3,               // スローイング
                             MODE_SMA,       // 平均化メソッド
                             0,               // 価格(Low/HighまたはClose/Close)
                             MODE_SIGNAL,      // ラインインデックス
                             0 // シフト
                            ); //スローストキャス
   stocha3 = iStochastic(
                          Symbol(),           // 通貨ペア
                          0,               // 時間軸
                          5,               // %K期間
                          3,               // %D期間
                          1,               // スローイング
                          MODE_SMA,       // 平均化メソッド
                          0,               // 価格(Low/HighまたはClose/Close)
                          MODE_MAIN,      // ラインインデックス
                          0 // シフト
                         ); //ファストストキャス





   stocha4 = iStochastic(
                             Symbol(),           // 通貨ペア
                             30,               // 時間軸
                             5,               // %K期間
                             3,               // %D期間
                             3,               // スローイング
                             MODE_SMA,       // 平均化メソッド
                             0,               // 価格(Low/HighまたはClose/Close)
                             MODE_MAIN,      // ラインインデックス
                             0 // シフト
                            ); 

   stocha5 = iStochastic(
                             Symbol(),           // 通貨ペア
                             30,               // 時間軸
                             5,               // %K期間
                             3,               // %D期間
                             3,               // スローイング
                             MODE_SMA,       // 平均化メソッド
                             0,               // 価格(Low/HighまたはClose/Close)
                             MODE_SIGNAL,      // ラインインデックス
                             0 // シフト
                            ); //スローストキャス
   stocha6 = iStochastic(
                          Symbol(),           // 通貨ペア
                          30,               // 時間軸
                          5,               // %K期間
                          3,               // %D期間
                          1,               // スローイング
                          MODE_SMA,       // 平均化メソッド
                          0,               // 価格(Low/HighまたはClose/Close)
                          MODE_MAIN,      // ラインインデックス
                          0 // シフト
                         ); //ファストストキャス

   
   


     

     
     
     
     
 
     //Short_MA > Middle_MA && Middle_MA > Long_MA && 
     //&& stocha3<stocha2<stocha1
     if(Short_MA > Middle_MA && Middle_MA > Long_MA && stocha1<20 && stocha2<20 && stocha3<20 &&  stocha3<stocha2 && stocha2<stocha1 )
     {
         ea_order_stop_price =  Ask - SL * Point;  //損切りポイント
         ea_order_good_price = Ask + TP * Point;  //利喰いポイント

         if(OrdersTotal()==0)
         {
         if(stocha4>20 || stocha5>20 || stocha6>20)
         {
            int buy = OrderSend(
            Symbol(),
            OP_BUY,//買い注文
            0.1,
            Ask,
            40,
            ea_order_stop_price,//損切り価格
            //ea_order_good_price,//利確
            NULL,
            "買った",
            magic,
            0,
            clrRed
            );
          }
         }
     }
     // && stocha1<stocha2<stocha3
     //Short_MA < Middle_MA && Middle_MA < Long_MA && 
     if(Short_MA < Middle_MA && Middle_MA < Long_MA && stocha1>80 && stocha2>80 && stocha3>80 && stocha1<stocha2 && stocha2<stocha3)
     {
         ea_order_stop_price = Bid + SL * Point;  //損切りポイント
         ea_order_good_price = Bid - TP * Point;  //利喰いポイント 
         if(OrdersTotal()==0)
         {
         if(stocha4<80 || stocha5<80 || stocha6<80)
         {
            int sell = OrderSend(
            Symbol(),
            OP_SELL,//売り注文
            0.1,
            Bid,
            40,
            ea_order_stop_price,//損切り価格
            //ea_order_good_price,//利確
            NULL,
            "売った",
            magic,
            0,
            clrBlue
            );
           }
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
                     if(OrderType()==OP_BUY && rci75>80)
                      //ポジションを決済
                      {
                      bool orderClose = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 10, clrNONE);
                      }else if(OrderType()==OP_SELL && rci75<-80)
                      {
                      bool orderClose = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 10, clrNONE);
                      }
                   }
               }
           }
       }
     
     }
     
     
  }
//+------------------------------------------------------------------+







double iRCI(const string symbol, int timeframe, int period, int index)//iRCI関数
{   
    int rank;
    double d = 0;
    double close_arr[];
    ArrayResize(close_arr, period); 

    for (int i = 0; i < period; i++) {
        close_arr[i] = iClose(symbol, timeframe, index + i);
    }

    ArraySort(close_arr, WHOLE_ARRAY, 0, MODE_DESCEND);

    for (int j = 0; j < period; j++) {
        rank = ArrayBsearch(close_arr,
                            iClose(symbol, timeframe, index + j),
                            WHOLE_ARRAY,
                            0,
                            MODE_DESCEND);
        d += MathPow(j - rank, 2);
    }

    return((1 - 6 * d / (period * (period * period - 1))) * 100);
}
