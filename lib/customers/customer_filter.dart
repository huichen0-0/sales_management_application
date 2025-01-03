class CustomerFilter{
  DateTime? fromDate; 
  DateTime? toDate; 
  num? fromSellAmount; 
  num? toSellAmount;
  num? fromDebtAmount;
  num? toDebtAmount;
  bool isMan;
  bool isWoman;
  bool isActive;
  bool isInactive;

  CustomerFilter({
    required this.fromDate, 
    required this.toDate,
    required this.fromSellAmount, 
    required this.toSellAmount,
    required this.fromDebtAmount,
    required this.toDebtAmount,
    required this.isMan,
    required this.isWoman,
    required this.isActive,
    required this.isInactive,
  });

  CustomerFilter.empty() :
      isMan = true,
      isInactive = false,
      isActive = true,
      isWoman = true,
      fromSellAmount = 0,
      toSellAmount = 0,
      fromDebtAmount = 0,
      toDebtAmount = 0;
}