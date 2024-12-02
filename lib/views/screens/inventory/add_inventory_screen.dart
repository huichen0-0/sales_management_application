import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_management_application/controllers/inventory_controller.dart';
import 'package:sales_management_application/models/inventory_note.dart';
import 'package:sales_management_application/models/inventory_note_detail.dart';
import 'package:sales_management_application/views/widgets/search_bars/search_product.dart';
import 'package:sales_management_application/views/widgets/thousands_formatter.dart';

class UpdateInventoryScreen extends StatefulWidget {
  final InventoryNote? existingNote; // Tham số cho phiếu kiểm kho hiện có

  const UpdateInventoryScreen({super.key, this.existingNote});


  @override
  State<UpdateInventoryScreen> createState() => _UpdateInventoryScreenState();
}

class _UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
  //phiếu kiểm kho
  InventoryNote inventoryNote = InventoryNote();
  //kiểm kho controller
  final InventoryController _controller = InventoryController();
  @override
  void initState() {
    super.initState();
    // Nếu đang cập nhật phiếu kiểm kho, gán dữ liệu vào `inventoryNote`
    if (widget.existingNote != null) {
      inventoryNote = widget.existingNote!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.existingNote == null
            ? 'Tạo phiếu kiểm kho'
            : 'Cập nhật phiếu kiểm kho'),
      ),
      body: SingleChildScrollView(
        child: ProductSearchBar(
          onProductTap: (product) {
            InventoryNoteDetail inventoryNoteDetail;
            //kiểm tra hàng hóa đã trong phiếu kiểm chưa
            if (inventoryNote.isInInventoryNote(product)) {
              // rồi sẽ lấy ra tiếp tục kiểm
              inventoryNoteDetail =
                  inventoryNote.getInventoryNoteDetailByProduct(product);
              _showInventoryNoteDetailDialog(inventoryNoteDetail, false);
            } else {
              //chưa sẽ tạo hàng kiểm mới
              inventoryNoteDetail = InventoryNoteDetail(product: product);
              _showInventoryNoteDetailDialog(inventoryNoteDetail, true);
            }
          },
          backgroundWidget: inventoryNote.products.isNotEmpty
              ? _buildTableView()
              : _buildEmptyView(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async{
                await _controller.updateInventoryNote(newNote: inventoryNote,status: 0);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Lưu tạm'),
            ),
            ElevatedButton(
              onPressed: () async{
                await _controller.updateInventoryNote(newNote: inventoryNote,status: 1);
                context.pop(true);
              }, // TODO: xử lý nút
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Hoàn thành'),
            ),
          ],
        ),
      ),
    );
  }

  // hiển thị danh sách trống
  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 64,
          ),
          Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey),
          SizedBox(
            height: 16,
          ),
          Text('Chưa có hàng hóa trong phiếu kiểm kho'),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Nếu cần cuộn ngang
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'Hàng kiểm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Tồn kho',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Thực tế',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Lệch',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: [
          for (var item in inventoryNote.products) _buildDataRow(item),
        ],
      ),
    );
  }

  DataRow _buildDataRow(InventoryNoteDetail item) {
    return DataRow(
      cells: [
        DataCell(Text(item.product.name)),
        DataCell(Text('${item.stockQuantity}')),
        DataCell(Text('${item.matchedQuantity}')),
        DataCell(
          Text(
            '${item.quantityDifference}',
            style: TextStyle(
              color: item.quantityDifference! >= 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      // Sử dụng `DataRow` với `GestureDetector` hoặc `InkWell` để làm toàn bộ hàng click được
      onLongPress: () {
        _showInventoryNoteDetailDialog(
            item, false); // Hành động khi click vào hàng
      },
    );
  }

  //thêm thông tin hàng kiểm
  void _showInventoryNoteDetailDialog(
      InventoryNoteDetail inventoryNoteDetail, bool isNew) {
    // Tạo controller cho TextField
    TextEditingController quantityController = TextEditingController(
        text: inventoryNoteDetail.matchedQuantity.toString());
    String productName = inventoryNoteDetail.product.name;
    num checkedQuantity = inventoryNoteDetail.matchedQuantity.toInt();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          // Màu nền tối
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  productName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tồn kho',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${inventoryNoteDetail.product.quantity}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đã kiểm',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${inventoryNoteDetail.matchedQuantity}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chênh lệch',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${inventoryNoteDetail.quantityDifference}',
                    style: TextStyle(
                      color: inventoryNoteDetail.quantityDifference! < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số lượng',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (checkedQuantity > 0) {
                              checkedQuantity--;
                              quantityController.text =
                                  checkedQuantity.toInt().toString();
                            }
                          });
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: quantityController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            ThousandsFormatter(),
                          ],
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              int? parsedValue = int.tryParse(value);
                              if (parsedValue != null && parsedValue >= 0) {
                                checkedQuantity = parsedValue;
                              }
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            checkedQuantity++;
                            quantityController.text =
                                checkedQuantity.toInt().toString();
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text(
                      'THOÁT',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        // Cập nhật giá trị matchedQuantity
                        inventoryNoteDetail.matchedQuantity =
                            checkedQuantity.toDouble();
                        //thêm hàng kiểm vào phiếu
                        isNew
                            ? inventoryNote.products.add(inventoryNoteDetail)
                            : inventoryNote
                                .updateInventoryNoteDetail(inventoryNoteDetail);
                      });
                      Navigator.of(context)
                          .pop(); // Đóng dialog sau khi nhấn "XONG"
                    },
                    child: const Text('XONG'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
