//+------------------------------------------------------------------+
//|                                                  omoshiroihi.mq4 |
//|                                                           myamya |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "myamya"
#property link      ""
#property version   "1.00"
#property strict

static int TicketNumber;
input double LOT = 0.01;//ロット
input int SLIP = 50;//スリッページ
input int MAGIC = 12345;//マジックナンバー
double K_Line = iStochastic(NULL,0,5,3,1,0,0,0,0);
double D_Line = iStochastic(NULL,0,5,3,1,0,0,1,0);

int OnInit()
  {

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }
  
//&& K_Line> 70 && D_Line > 70  OrdersTotal() == 0 &&
void OnTick()
   {
      if(OrdersTotal() == 0 &&Hour() == 9 && Minute() == 55 && D_Line> 50) //オーダーが0で時間が9時55分である場合
      {
         TicketNumber = OrderSend(Symbol(), OP_SELL, LOT, Bid, SLIP, Ask+30*Point, Bid-3*Point, "SELL", MAGIC, 0, clrRed);//ショート（売り）エントリー
      }
      


   }
   
   
    
    //  if(OrdersTotal() > 0 &&  Hour() == 12) //オーダーが0以上で時間が12時である場合
 //  {
 //     bool Exit = OrderClose(TicketNumber, LOT, Bid, SLIP, clrDodgerBlue);//ポジションを決済
 //  }
      //   if(OrdersTotal() > 0)
      //{
       //  bool Exit = OrderModify(TicketNumber,OrderOpenPrice()+6*Point,OrderOpenPrice()-1*Point,0,clrNONE);
      //}

//+------------------------------------------------------------------+
