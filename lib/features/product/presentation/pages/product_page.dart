import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data produk (Nanti kita hubungkan ke API & Bloc)
    final List<Map<String, dynamic>> products = [
      {'title': 'Fjallraven - Foldsack No. 1', 'price': 109.95},
      {'title': 'Mens Casual Premium Slim Fit', 'price': 22.3},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('UTD Store Raisya'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          // LOGIKA NIM GANJIL: Tambahkan [Diskon 10%]
          final String displayTitle = "${product['title']} [Diskon 10%]";

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.blue),
              title: Text(displayTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("\$${product['price']}"),
              trailing: IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // Nanti di sini fungsi Isar Bookmark
                },
              ),
            ),
          );
        },
      ),
    );
  }
}