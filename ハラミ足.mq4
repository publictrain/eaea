//
// yasciiSimple06
// はらみ足
//

//マジックナンバーの定義
#define MAGIC  42108

//パラメーターの設定//
extern double Lots = 0.01;     //取引ロット数
extern int Slip = 10;         //許容スリッページ数
extern string Comments =  "Simple06"; //コメント

extern double ILC = 20.0 ;
extern double TP = 40.0 ;

//変数の設定//
int Ticket_L = 0; //買い注文の結果をキャッチする変数
int Ticket_S = 0; //売り注文の結果をキャッチする変数
int Exit_L = 0;   //買いポジションの決済注文の結果をキャッチする変数
int Exit_S = 0;   //売りポジションの決済注文の結果をキャッチする変数
int OS1 ;
int OS2 ;
double   OOPL;
double   OOPS;

int start()
  {

   if (Volume[0]>1 || IsTradeAllowed() == false) return(0) ;

   double lc = ILC;
   if(( Digits ==3 ) ||(Digits ==5)) lc = lc*10.0 ;
   double tp = TP;
   if(( Digits ==3 ) ||(Digits ==5)) tp = tp*10.0 ;

   //買いポジションのエグジット
   OS1 = OrderSelect(Ticket_L, SELECT_BY_TICKET);  
   OOPL = OrderOpenPrice();   
   if( (Close[1] < OOPL - lc*Point || Close[1] > OOPL + tp*Point)
      && (Ticket_L != 0 && Ticket_L != -1 ))
    {     
      Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Blue);
      if( Exit_L ==1 ) {Ticket_L = 0;}
    }    

   //売りポジションのエグジット
   OS2 = OrderSelect(Ticket_S, SELECT_BY_TICKET); 
   OOPS = OrderOpenPrice();
   if( (Close[1] > OOPS + lc*Point || Close[1] < OOPS - tp*Point)
       && (Ticket_S != 0 && Ticket_S != -1 ))
    {     
      Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Red);
      if( Exit_S ==1 ) {Ticket_S = 0;} 
    }   

   //買いエントリー
   if( Close[1] > Open[1] && Close[2] < Open[2] && Close[3] < Open[3] && Close[3] > Close[2]
       &&  Close[2] < Open[1] && Open[2] > Close[1]
       && ( Ticket_L == 0 || Ticket_L == -1 ) 
       && ( Ticket_S == 0 || Ticket_S == -1 ))
    {  
      Ticket_L = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip,0,0,Comments,MAGIC,0,Blue);
    }

   //売りエントリー
   if( Close[1] < Open[1] && Close[2] > Open[2] && Close[3] > Open[3] && Close[3] < Close[2]
       &&  Close[2] > Open[1] && Open[2] < Close[1]
       && ( Ticket_S == 0 || Ticket_S == -1 )
       && ( Ticket_L == 0 || Ticket_L == -1 ))
    {   
      Ticket_S = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip,0,0,Comments,MAGIC,0,Red);     
    } 

   return(0);
  }