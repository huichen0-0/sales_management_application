class SupplierFilter {
  int purchaseLowerBound=0;
  int purchaseUpperBound=0;
  bool isActive=true;
  bool isInactive=true;

  SupplierFilter() {
    this.purchaseUpperBound=0;
    this.purchaseLowerBound=0;
    this.isActive=true;
    this.isInactive=true;
  }
}