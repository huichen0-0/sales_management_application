class Filter {
  bool isChanged;
  int purchaseLowerBound;
  int purchaseUpperBound;
  int debtLowerBound;
  int debtUpperBound;
  bool isActive;
  bool isInActive;

  Filter({required this.isChanged, required this.purchaseLowerBound, required this.purchaseUpperBound,
      required this.debtLowerBound, required this.debtUpperBound, required this.isActive, required this.isInActive});
}