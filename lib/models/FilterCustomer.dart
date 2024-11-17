class FilterCustomer{
  DateTime? fromDate; 
  DateTime? toDate; 
  num? fromSellAmount; 
  num? toSellAmount;
  num? fromReturnAmount; 
  num? toReturnAmount; 
  bool isMan;
  bool isWoman;
  bool isActive;
  bool isInactive;

  FilterCustomer({
    required this.fromDate, 
    required this.toDate,
    required this.fromSellAmount, 
    required this.toSellAmount,
    required this.fromReturnAmount, 
    required this.toReturnAmount, 
    required this.isMan,
    required this.isWoman,
    required this.isActive,
    required this.isInactive,
  });
}