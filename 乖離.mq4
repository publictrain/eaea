//+------------------------------------------------------------------+
//|                                                           乖離.mq4 |
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

double ema;
double ans_sell,ans_buy;
double close;
double imp = 0.2;

double ea_order_good_price;
double TP = 600;

int magic = 101002;


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
   close = iClose(NULL,0,0);
   ema = iMA(NULL, 0, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
   ans_sell = Bid-ema;
   ans_buy = MathAbs(Ask-ema);
   if(ans_sell>imp)
   {
   if(OrdersTotal()==0)
         {
         ea_order_good_price = Bid - TP * Point;
            int sell = OrderSend(
            Symbol(),
            OP_SELL,//売り注文
            0.1,
            Bid,
            40,
            NULL,//損切り価格
            ea_order_good_price,//利確
            "売った",
            magic,
            0,
            clrBlue
            );
           
         }
   }else if(ans_buy>imp)
   {
      if(OrdersTotal()==0)
         {
         ea_order_good_price = Ask + TP * Point;
            int buy = OrderSend(
            Symbol(),
            OP_BUY,//買い注文
            0.1,
            Ask,
            40,
            NULL,//損切り価格
            ea_order_good_price,//利確
            "買った",
            magic,
            0,
            clrRed
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
                     if(OrderType()==OP_BUY &&Ask>ema)
                      //ポジションを決済
                      {
                      bool orderClose = OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 10, clrNONE);
                      }else if(OrderType()==OP_SELL && Bid<ema)
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
