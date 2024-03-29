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
input int SL = 390;
input int TP = 550;

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

double ema_space;
double ema_space_before;

double stocha1;
double stocha2;

double ea_order_stop_price;
double ea_order_good_price;

int buy;
int sell;
int spread;
int count_buy;
int count_sell;
int count_space_buy;
int count_space_sell;
int count_mod;


bool   modify_ret;  





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

   
   count_buy = 0;
   count_sell = 0;
   spread = 20;

   
   
   ema_space = 0;
   ema_space_before = 0;

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
   //damiani戻り値が1のときトレンド
   for(int i = 0;i<3;i++)//iを増やすと時間計算量が増えていく。しかし、Ordermodifyの正当性が高くなる。
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
      

         if(ema1>ema2 && ema2>ema3 && ema3>ema4 && ema4>ema5 && ema5>ema6 && ema6>ema7 && ema7>ema8 && ema8>ema9 && ema9>ema10 && ema10>ema11 && ema11>ema12)//ロングのとき
         {
            count_buy++;
            ema_space_before = ema6-ema7;
               if(ema_space_before>ema_space)
               {
                  ema_space = ema_space_before;
                  count_space_buy++;//ema6とema7が開いていくかどうかの計算
                  //Print(count_space_buy);
               }else
               {
                  count_space_buy=0;
               }
         }else if(ema1<ema2 && ema2<ema3 && ema3<ema4 && ema4<ema5 && ema5<ema6 && ema6<ema7 && ema7<ema8 && ema8<ema9 && ema9<ema10 && ema10<ema11 && ema11<ema12)//ショートのとき
         {
            count_sell++;
            ema_space_before = ema7-ema6;
               if(ema_space_before>ema_space)
               {
                  ema_space = ema_space_before;
                  count_space_sell++;//ema6とema7が開いていくかどうかの計算
                  //Print(count_space_sell);
               }else
               {
                  count_space_sell=0;
               }
               
         }
      
   }


//上のコードはOnTickごとに毎回実行sれる
//下のコードは注文があるかどうかで分けられている
   if(OrdersTotal()==0 && count_buy==2 && stocha2>50)
   {
      count_mod=0;//これはOrderModify関数を無限に呼び出し続けないためのもの
      ea_order_stop_price =  Ask - SL * Point;  //損切りポイント
      ea_order_good_price = Ask + TP * Point;  //利喰いポイント
      buy = OrderSend(
      Symbol(),
      OP_BUY,//買い注文
      0.1,
      Ask,
      spread,
      ea_order_stop_price,//損切り価格
      ea_order_good_price,//利確
      "買った",
      magic,
      0,
      clrRed
      );
   }else if(OrdersTotal()==0 && count_sell==2 && stocha2<50)
   {
      count_mod=0;//これはOrderModify関数を無限に呼び出し続けないためのもの
      ea_order_stop_price = Bid + SL * Point;  //損切りポイント
      ea_order_good_price = Bid - TP * Point;  //利喰いポイント 
      sell = OrderSend(
      Symbol(),
      OP_SELL,//売り注文
      0.1,
      Bid,
      spread,
      ea_order_stop_price,//損切り価格
      ea_order_good_price,//利確
      "売った",
      magic,
      0,
      clrBlue
      );
    }else if(OrdersTotal()>0 && count_space_buy>10 && count_mod==0)//ロングポジション
    {
      ea_order_stop_price =  Ask - (SL * Point*1.2);  //損切りポイント
      ea_order_good_price =  Ask + (TP * Point*1.2);  //利喰いポイント
      modify_ret = OrderModify(
                                 buy,      // チケットNo
                                 OrderOpenPrice(),  // 注文価格
                                 ea_order_stop_price,            // ストップロス価格
                                 ea_order_good_price,           // リミット価格
                                 OrderExpiration(), // 有効期限
                                 clrForestGreen               // 色
                               );
      count_mod++;//これはOrderModify関数を無限に呼び出し続けないためのもの
      count_space_buy=0;
    }else if(OrdersTotal()>0 && count_space_sell>10 && count_mod==0)//ショートポジション
    {
       ea_order_stop_price = Bid + (SL * Point*1.2);  //損切りポイント
       ea_order_good_price = Bid - (TP * Point*1.2);  //利喰いポイント 

       modify_ret = OrderModify(
                                 sell,      // チケットNo
                                 OrderOpenPrice(),  // 注文価格
                                 ea_order_stop_price,            // ストップロス価格
                                 ea_order_good_price,           // リミット価格
                                 OrderExpiration(), // 有効期限
                                 clrForestGreen              // 色
                                );
       count_mod++;//これはOrderModify関数を無限に呼び出し続けないためのもの
       count_space_sell=0;
    
    }
   
   

   
   


}
   
   

