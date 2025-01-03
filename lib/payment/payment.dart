class Payment {
  num amount; // Số tiền thanh toán
  String method; // Phương thức thanh toán (VD: "cash", "credit card", "bank transfer")
  DateTime createdAt; // Ngày thanh toán
  String? note; // Ghi chú thêm (nếu có)

  Payment({
    required this.amount,
    required this.method,
    required this.createdAt,
    this.note,
  });

  Payment.empty()
      : amount = 0,
        method = '',
        createdAt = DateTime.now(),
        note = null;

  /// Khởi tạo từ JSON
  factory Payment.fromJson(Map<dynamic, dynamic> json) => Payment(
    amount: json['amount'],
    method: json['method'],
    createdAt: DateTime.parse(json['createdAt']),
    note: json['note'],
  );

  /// Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'method': method,
    'createdAt': createdAt.toIso8601String(),
    if (note != null) 'note': note,
  };
}
