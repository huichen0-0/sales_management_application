import 'package:sales_management_application/invoice/invoice_receipt.dart';
import 'package:sales_management_application/products/product_service.dart';
import 'package:sales_management_application/time_filter/time_filter_service.dart';
import '../customers/model/customer.dart';
import '../customers/service/customer_service.dart';
import '../receipt/receipt_detail.dart';
import '../return_import/return_import_filter.dart';
import '../sort/sorting_controller.dart';
import '/config/constants.dart';
import 'order.dart';
import 'order_detail.dart';
import 'order_filter.dart';
import 'order_service.dart';

class OrderController {
  //lấy dữ liệu từ db, key gán vào id
   List<Order> data = [  ];
   ReturnImportFilter filter = ReturnImportFilter();
   OrderService orderService = OrderService();
   ProductService productService = ProductService();
   CustomerService customerService = CustomerService();
   TimeFilterService timeFilterService = TimeFilterService();

  // Hàm lấy dữ liệu
  Future<List<Order>> getData(OrderFilter filter, String? customerId, DateTime? fromDate, DateTime? toDate) async {

    List<Order> results = [];
    List<Order> orders = await orderService.getData(filter);
    for(Order o in orders) {
      if (timeFilterService.isTimeFilterd(o.createdAt, fromDate, toDate)
            &&
          ((customerId == null) || (customerId != null && o.customerId == customerId))
      ) {
        List<OrderDetail> detailResult = [];
        for (OrderDetail detail in o.details) {
          detail.product = await productService.getProduct(detail.productId);
          detailResult.add(detail);
        }
        o.details = detailResult;
        Customer customer = await customerService.getCustomerByKey(
           o.customerId);
        o.customer = customer;
        results.add(o);
      }
    }
    return results;
  }

  /// XỬ LÝ PHIẾU ///
  //tổng giá trị hiên thị (tổng tiền hàng), đã hoàn thành mới cộng
  num getTotalDisplayValue(List<Order> orders) {
    return orders.fold(
      AppNum.zero,
          (sum, order) {
        return sum + (order.status == AppNum.two ? order.totalAmount : AppNum.zero);
      },
    );
  }

  //Hủy phiếu
  bool cancelOrder(Order order) {
    orderService.cancelReceipt(order.id);
    return true;
  }

  // Hàm thêm mới/cập nhật phiếu
  void updateOrder({
    required Order updatedItem,
  }) {
    final index = data.indexWhere((order) => order.id == updatedItem.id);
    if (index == -1) {
      data.add(updatedItem);
    } else {
      data[index] = updatedItem;
    }
  }

  // Hàm lấy phiếu theo ID future
  Future<Order?> getOrderByIdAsync(String id) async {
    return data.firstWhere(
          (order) => order.id == id,
      orElse: () => Order.empty(),
    );
  }

  // Hàm lấy phiếu theo ID
  Order? getOrderById(String id) {
    return data.firstWhere(
          (order) => order.id == id,
      orElse: () => Order.empty(),
    );
  }

  // lấy dữ liệu dạng MAP
  List<Map<String, dynamic>> convertToJSON(List<Order>? data) => [
    for (var order in data ?? <Order>[]) order.toJson1(),
  ];

  // chuyển sang danh sách object
  List<Order> convertFromJSON(List<Map<String, dynamic>> json) {
    return json
        .map((orderJson) => Order.fromJson(orderJson))
        .toList();
  }

  /// XỬ LÝ CHI TIẾT PHIẾU ///
  // kiểm tra hàng hóa đã trong phiếu kiểm chưa
  bool existDetail(Order order, String productId) {
    return order.details.any((item) => item.productId == productId);
  }

  /// Hàm lấy chi tiết phiếu trong phiếu hủy xuất
  OrderDetail getDetailByProductId(Order order, String productId) {
    // return order.details.firstWhere(
    //       (detail) => detail.productId == productId,
    //   orElse: () => OrderDetail.empty(),
    // );
    return OrderDetail.empty();
  }

  /// Hàm cập nhật chi tiết phiếu trong phiếu hủy xuất
  void updateDetail(Order order, OrderDetail detail) {
    final detailIndex = order.details.indexWhere(
          (item) => item.productId == detail.productId,
    );

    if (detailIndex != -1) {
      // Cập nhật chi tiết phiếu
      order.details[detailIndex] = detail;
    } else {
      // Thêm chi tiết phiếu mới
      order.details.add(detail);
    }
  }

  //Hàm xóa chi tiết phiếu ra khỏi phiếu
  void removeDetail(Order order, OrderDetail detail) {
    order.details.remove(detail);
  }

  ///lọc theo thời gian
  List<Order> filterOrdersByDateRange(
      List<Order> orders, DateTime? startDate, DateTime? endDate) {
    List<Order> filteredOrders = orders;
    if (startDate != null) {
      filteredOrders = orders.where((order) {
        return order.createdAt.isAfter(startDate);
      }).toList();
    }
    if (endDate != null) {
      filteredOrders = filteredOrders.where((order) {
        return order.createdAt.isBefore(endDate);
      }).toList();
    }
    return filteredOrders;
  }

  ///lọc theo bộ lọc
  List<Order> filterOrders(
      List<Order> orders,
      Map<String, dynamic> filters,
      ) {
    List<Order> filteredOrders = orders;
    //bộ lọc
    if (filters.isNotEmpty) {
      final statusFilters = filters[AppAttribute.status] as Map<int, bool>;
      filteredOrders = orders.where((order) {
        return statusFilters[order.status] == true;
      }).toList();
    }
    return filteredOrders;
  }

  ///sắp xếp
  List<Order> sortOrders(
      List<Order> orders,
      String sortOption
      ) {
    // Sắp xếp theo tùy chọn
    final sortingController = SortingController(convertToJSON(orders));
    sortingController.updateSorting(sortOption, AppAttribute.totalAmount);

    return convertFromJSON(sortingController.currentData);
  }

  /// Xử lý logic Lưu tạm
  bool saveTemporary(Order newOrder) {
   newOrder.status = 1;
   orderService.save(newOrder, 'Order');
   return true;
  }

  bool saveComplete(Order newOrder) {
    newOrder.status = 2;
    orderService.save(newOrder, 'Order');
    return true;
  }

  /// Xử lý logic click thanh toán
  InvoiceReceipt createInvoiceBasedOnOrder(Order order){
    //Tạo hóa đơn mới dựa trên đơn đặt hàng
    final invoice = InvoiceReceipt(
        id: '',
        partnerId: order.customerId,
        customer: order.customer,
        payments: [],
        status: 2,
        createdAt: DateTime.now(),
        details: [],
        returned: false,
        uid: ''
    );
    for(var detail in order.details) {
      invoice.details.add(
          ReceiptDetail(
              productId: detail.productId,
              product: detail.product,
              quantity: detail.quantity,
          ),
      );
    }
    return invoice;
  }
}
