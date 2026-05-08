import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart'; 
import '../../../../core/network/isar_service.dart'; 
import '../../domain/product_bookmark_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // 🔥 FETCH API
  Future<void> fetchProducts() async {
    try {
      final response =
          await Dio().get('https://fakestoreapi.com/products');

      setState(() {
        products = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTD Store Raisya'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.pink.shade50,

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                // LOGIKA NIM GANJIL
                final String displayTitle =
                    "${product['title']} [Diskon 10%]";

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        ),
                      ),
                      title: Text(
                        displayTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("\$${product['price']}"),
                      trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.pink,
                          ),
                          onPressed: () async {
                          // Panggil service lewat locator
                          final isarService = locator<IsarService>();

                          final bookmark = ProductBookmark()
                            ..productId = product['id'].toString()
                            ..name = displayTitle
                            ..image = product['image']
                            ..createdAt = DateTime.now();

                          await isarService.saveBookmark(bookmark);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil di Bookmark!'),
                                backgroundColor: Colors.pink,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}