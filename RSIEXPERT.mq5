#include <Trade/Trade.mqh>


CTrade trade;
int rsiHandle;
ulong posTicket;
double globalSL = 0.00400;
double globalTP = 0.00400;
double globalBid = 0.01;

int OnInit(){
   rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, 14, PRICE_CLOSE);
   return 0;
}

void OnDeinit(const int reason){
   
}



void OnTick(){
   double rsi[];
   CopyBuffer(rsiHandle, 0, 0, 1, rsi);
   
   if (rsi[0] > 70) {
      if(posTicket > 0 && PositionSelectByTicket(posTicket)) {
         int posType = (int)PositionGetInteger(POSITION_TYPE);
         if (posType == POSITION_TYPE_BUY) {
            trade.PositionClose(posTicket);
            posTicket = 0;
         }
      }
      if (posTicket <= 0) {
         trade.Sell(globalBid, _Symbol);
         posTicket = trade.ResultOrder();
      }
   }
   
   if (rsi[0] < 20) {
      if(posTicket > 0 && PositionSelectByTicket(posTicket)) {
         int posType = (int)PositionGetInteger(POSITION_TYPE);
         if (posType == POSITION_TYPE_SELL) {
            trade.PositionClose(posTicket);
            posTicket = 0;
         }
      }
      if (posTicket <= 0) {
         double bid = globalBid * 1000;
         trade.Buy(bid, _Symbol);
         posTicket = trade.ResultOrder();
      }
   }
   
   // Check if open trade
   if (PositionSelectByTicket(posTicket)) {
      double posPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double posSl = PositionGetDouble(POSITION_SL);
      double posTp = PositionGetDouble(POSITION_TP);
      int posType = (int)PositionGetInteger(POSITION_TYPE);
      
      if (posType == POSITION_TYPE_BUY) {
         if (posSl == 0) {
            double sl = posPrice - globalSL;
            double tp = posPrice + globalTP;
            trade.PositionModify(posTicket, sl, tp);
         }
      } else if (posType == POSITION_TYPE_SELL) {
         if (posSl == 0) {
            double sl = posPrice + globalSL;
            double tp = posPrice - globalTP;
            trade.PositionModify(posTicket, sl, tp);
         }
      }
   } else {
      posTicket = 0;
   }
   
   
   
   Comment(rsi[0], "\nposTicket", posTicket, "\nposTicket");
}
