import 'package:flutter/material.dart';
import 'package:sales_management_application/config/constants.dart';
import '../helper/helper.dart';
import 'order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(String id) onTap;

  const OrderCard(
      {super.key,
        required this.order,
        required this.onTap,
       });

  @override
  Widget build(BuildContext context) {
    final details = order.details;
    final totalQuantity = order.totalQuantity;
    final createdAt = Helper.formatTime(order.createdAt);
    final status = Helper.getStatusReceipt(order.status);
    final totalAmount =
    Helper.formatCurrency(order.totalAmount);

    // Lấy chi tiết sản phẩm đầu tiên và số lượng sản phẩm còn lại
    final firstDetail = details.isNotEmpty ? details.first : null;
    final additionalItems =
    details.length > AppNum.one ? details.length - AppNum.one : AppNum.zero;

    return Card(
      child: ListTile(
        leading: Text(createdAt),
        //không có KH mặc định là khách lẻ
        title: Text(
          order.customer == null ? AppString.retailCustomer : order.customer!.name,
          style:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalAmount,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              status, // Hiển thị trạng thái
              style: TextStyle(
                color: order.status == AppNum.two
                    ? Colors.green
                    : order.status == AppNum.one
                    ? Colors.orange
                    : Colors.red, // Thay đổi màu sắc của văn bản
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${details.length} mặt hàng - Số lượng: $totalQuantity',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Hiển thị chi tiết sản phẩm đầu tiên
            if (firstDetail != null)
              Text(
                '${firstDetail.product!.name} x${firstDetail.quantity} ${firstDetail.product!.unit}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            // Hiển thị số mặt hàng bổ sung nếu có
            if (additionalItems > AppNum.zero)
              Text(
                '+$additionalItems mặt hàng khác',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        onTap: () {
          onTap(order.id.toString());
        },
      ),
    );
  }
}
