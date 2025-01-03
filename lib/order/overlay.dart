import 'package:flutter/material.dart';

import '../products/product.dart';

class OverlaySearchResult extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onProductSelected;
  final LayerLink layerLink; // Để định vị overlay

  const OverlaySearchResult({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.layerLink,
  });

  @override
  _OverlaySearchResultState createState() => _OverlaySearchResultState();
}

class _OverlaySearchResultState extends State<OverlaySearchResult> {
  @override
  Widget build(BuildContext context) {
    return CompositedTransformFollower(
      link: widget.layerLink,
      offset: const Offset(0, 55), // Để overlay nằm dưới search
      child: Material(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5), // Giới hạn chiều cao
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return ListTile(
                title: Text('${product.name} (${product.unit})'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mã: ${product.barcode} - SL: ${product.quantity}'),
                    Text('${product.sellingPrice} VND'),
                  ],
                ),
                onTap: () {
                  widget.onProductSelected(product);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}