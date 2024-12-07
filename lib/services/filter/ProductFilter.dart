class ProductFilter {
  bool isBelowStockLimit=false;
  bool isAboveStockLimit=false;
  bool isSoldOut=false;
  bool isAvailable=false;
  bool isActive=true;
  bool isInactive=true;

  ProductFilter() {
    isBelowStockLimit=false;
    isAboveStockLimit=false;
    isSoldOut=false;
    isAvailable=false;
    isActive=true;
    isInactive=true;
  }

  void setStatus(bool isBelowStockLimit, bool isAboveStockLimit, bool isSoldOut, bool isAvailable) {
    this.isBelowStockLimit = isBelowStockLimit;
    this.isAboveStockLimit = isAboveStockLimit;
    this.isSoldOut = isSoldOut;
    this.isAvailable = isAvailable;
  }

  String getStatus() {
    if (this.isBelowStockLimit == true) {
      return 'Dưới định mức tồn';
    }
    else if (this.isAboveStockLimit == true) {
      return 'Vượt định mức tồn';
    }
    else if (this.isAvailable == true) {
      return 'Còn hàng';
    }
    else if (this.isSoldOut == true) {
      return 'Hết hàng';
    }
    else {
      return 'Tất cả hàng hóa';
    }
  }
}