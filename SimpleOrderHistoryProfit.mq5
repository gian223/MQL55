#include <Trade/Trade.mqh>

CTrade trade;

int OnInit(){
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   
}

void OnTick(){
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   
   if (PositionsTotal() < 1) {
      trade.Buy(0.10, NULL, Ask, 0 , (Ask+150 * _Point), NULL);
      trade.Sell(0.10, NULL, Ask, 0 , (Ask-150 * _Point), NULL);
   }
   
   string MyLastProfit = GetLastProfit();
   
   Comment("My last profit", MyLastProfit);
}


string GetLastProfit(){
   uint TotalNumberOfDeals = HistoryDealsTotal();
   ulong TicketNumber = 0;
   long OrderType, DealEntry;
   double OrderProfit = 0;
   string MySymbol = "";
   string PositionDirection = "";
   string MyResult = "";
   
   HistorySelect(0, TimeCurrent());
   
   for (uint i=0; i < TotalNumberOfDeals; i++){
      if ((TicketNumber = HistoryDealGetTicket(i)) > 0){
         OrderProfit = HistoryDealGetDouble(TicketNumber, DEAL_PROFIT);
         OrderType = HistoryDealGetInteger(TicketNumber, DEAL_TYPE);
         MySymbol = HistoryDealGetString(TicketNumber, DEAL_SYMBOL);
         DealEntry = HistoryDealGetInteger(TicketNumber, DEAL_ENTRY);
         
         if (MySymbol == _Symbol) {
            if (OrderType == ORDER_TYPE_BUY) PositionDirection = "SELL-TRADE";
            
            if (OrderType == ORDER_TYPE_SELL) PositionDirection = "BUY-TRADE";
            
            MyResult = "Profit: "+OrderProfit+" Ticket: "+TicketNumber+"Position Direction: "+PositionDirection;
         }
      }
   }
   return MyResult;
}