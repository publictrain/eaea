//+------------------------------------------------------------------+
//|                                       Bollinger bands_Sample.mq4 |
//|                                    Copyright 2020, mef Software. |
//|                                             https://fx-prog.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, mef Software."
#property link      "https://fx-prog.com/"
#property version   "1.00"
 
  
input int BB_KIKAN = 20;
 
input double Lots = 0.01;
 
input int SL = 220;
input int TP = 220;
 
 
//一回のバーで仕掛ける
extern string Note02_9          = "--- entry only once per 1 bar --------------------------------";
extern bool   UseEntryPer1Bar   = true;
int gPrvBars       = 0;
//一回のバーで仕掛ける

double waitBB;
datetime prevtime;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//---
       gPrvBars = Bars;//一本のバーだけでしかける
     
//---
   return(INIT_SUCCEEDED);
  }
         
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
int start()
{
int orderPtn=0; //0:何もしない 1:買い 2:売り
int total=0;
int currentBars = Bars;//一本のバーだけでしかｓける

int errorcode;               // エラーコード
int ea_ticket_No,ea_order_entry_Type=0,ea_order_MagicNo;  // チケットNo,エントリタイプ,マジックＮｏ．
double ea_order_stop_price=0,ea_order_good_price=0,ea_order_entry_price=0,ima; //ストップロスレート,利確レート,エントリーレート
         
//---
         
// -----------------------------------------------------------------
// 仕掛けフィルター（１本の足で１回だけ仕掛ける）
// -----------------------------------------------------------------
   if(UseEntryPer1Bar){
     // 新しい足を生成した時ではない場合は、仕掛けない
     if(currentBars == gPrvBars){
       gPrvBars = currentBars;
       return(0);
     }
   }
         
   //ボリンジャーバンドの値を取得
   double BB3UP = iBands(NULL,0,BB_KIKAN,3,0,PRICE_CLOSE,MODE_UPPER,0); //3σの上側
   double BB3LO = iBands(NULL,0,BB_KIKAN,3,0,PRICE_CLOSE,MODE_LOWER,0); //3σの下側
         
   double BB2UP = iBands(NULL,0,BB_KIKAN,2,0,PRICE_CLOSE,MODE_UPPER,0); //2σの上側
   double BB2LO = iBands(NULL,0,BB_KIKAN,2,0,PRICE_CLOSE,MODE_LOWER,0); //2σの下側
   
   double BB1UP = iBands(NULL,0,BB_KIKAN,1,0,PRICE_CLOSE,MODE_UPPER,0); //1σの上側
   double BB1LO = iBands(NULL,0,BB_KIKAN,1,0,PRICE_CLOSE,MODE_LOWER,0); //1σの下側
   //ima = iMA(NULL,0,BB_KIKAN,0,0,PRICE_MEDIAN,0);
         
//***売買判断箇所***//
         
   //Askがボリンジャーバンドの上1σタッチで買いサイン
   if(BB1UP < Ask) 
   {
      orderPtn=1;
   }
   //Bidがボリンジャーバンドの下1σタッチで売りサイン
   else if(BB1LO > Bid)
   {
      orderPtn=2;
   }
   //それ以外は何もしない
   else
   {
      orderPtn=0;
   }
            
   int search_bar=3;
   if(orderPtn==1)
   {         
     for(int i=0;i<search_bar;i++)
     {
      double candle_end = iClose(NULL,0,i);
      if(candle_end<ima)
      {
         orderPtn=1;
      }
      else
      {
         orderPtn=0;
      }
     
     }
   }
   else if(orderPtn==2)
   {
      for(int j=0;i<search_bar;i++)
      {
         double candle_start=iOpen(NULL,0,i);
         if(candle_start<ima)
         {
            orderPtn=2;
         }
         else
         {
            orderPtn=0;
         }
         
       }
   }

//***売買判断箇所***//
         
   total=OrdersTotal();
            
   if(total == 1){
      //既に建玉を保有していたら何もしない
      waitBB=0; 
   }
         
//***エントリー箇所***//
   else if(total == 0 && orderPtn > 0)
   {
      if(orderPtn == 1)
      {
         ea_order_entry_price = Ask;               // 現在の買値でエントリー
         ea_order_entry_Type = OP_BUY;             //OP_BUY
         ea_order_stop_price =  Ask - SL * Point;  //損切りポイント
         ea_order_good_price = Ask + TP * Point;  //利喰いポイント
      }
      else if(orderPtn == 2)
      {
         ea_order_entry_price = Bid;               // 現在の売値でエントリー
         ea_order_entry_Type = OP_SELL;            //OP_SELL      
         ea_order_stop_price = Bid + SL * Point;  //損切りポイント
         ea_order_good_price = Bid - TP * Point;  //利喰いポイント 
      }
               
      ea_order_MagicNo=0000;  //マジックナンバーは0000固定とする
         
      ea_ticket_No = OrderSend(   // 新規エントリー注文
            NULL,                     // 通貨ペア
            ea_order_entry_Type,      // オーダータイプ[OP_BUY / OP_SELL]
            Lots,                     // ロット(0.01単位,FXTFは1=10Lot)
            ea_order_entry_price,     // オーダープライスレート
            20,                       // スリップ上限
            ea_order_stop_price,      // ストップレート
            ea_order_good_price,      // リミットレート
            "テストオーダー",             // オーダーコメント
            ea_order_MagicNo,         // マジックナンバー(識別用)
            0,                        // オーダーリミット時間
            clrRed                    // オーダーアイコンカラー
          );
                 
      if ( ea_ticket_No == -1)           // オーダーエラー
      {
         errorcode = GetLastError();      // エラーコード取得
         if( errorcode != ERR_NO_ERROR)   // エラー発生
         {
             printf("エラー");
         }
      }
      else {    // 注文約定
         Print("新規注文約定。 チケットNo=",ea_ticket_No);
      }
   }
         
         
   return(0);
}