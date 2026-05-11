import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

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

  // Menyimpan ID product yang sudah dibookmark
  List<String> bookmarkedIds = [];

  @override
  void initState() {
    super.initState();

    fetchProducts();
    loadBookmarks();
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

  // 🔥 LOAD BOOKMARK
  Future<void> loadBookmarks() async {

    final isarService = locator<IsarService>();

    final bookmarks = await isarService.getBookmarks();

    setState(() {
      bookmarkedIds =
          bookmarks.map((e) => e.productId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('UTD Store Raisya'),

        backgroundColor: Colors.pink,

        foregroundColor: Colors.white,

        actions: [

          // 🔥 BUTTON MENU BOOKMARK
          IconButton(

            icon: const Icon(Icons.bookmark),

            onPressed: () {
              context.push('/bookmarks');
            },
          ),
        ],
      ),

      backgroundColor: Colors.pink.shade50,

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )

          : ListView.builder(

              itemCount: products.length,

              itemBuilder: (context, index) {

                final product = products[index];

                // LOGIKA NIM GANJIL
                final String displayTitle =
                    "${product['title']} [Diskon 10%]";

                // Cek apakah product sudah dibookmark
                final bool isBookmarked =
                    bookmarkedIds.contains(
                  product['id'].toString(),
                );

                return Padding(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  child: Card(

                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),

                    child: ListTile(

                      leading: ClipRRect(

                        borderRadius:
                            BorderRadius.circular(8),

                        child: Image.network(

                          product['image'],

                          width: 50,
                          height: 50,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {

                            return const Icon(
                              Icons.image_not_supported,
                            );
                          },
                        ),
                      ),

                      title: Text(

                        displayTitle,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "\$${product['price']}",
                      ),

                      trailing: IconButton(

                        icon: Icon(

                          isBookmarked
                              ? Icons.favorite
                              : Icons.favorite_border,

                          color: Colors.pink,
                        ),

                        onPressed: () async {

                          final isarService =
                              locator<IsarService>();

                          // Kalau belum dibookmark
                          if (!isBookmarked) {

                            final bookmark =
                                ProductBookmark()

                              ..productId =
                                  product['id'].toString()

                              ..name = displayTitle

                              ..image = product['image']

                              ..createdAt =
                                  DateTime.now();

                            await isarService
                                .saveBookmark(bookmark);

                            bookmarkedIds.add(
                              product['id'].toString(),
                            );

                            if (context.mounted) {

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                const SnackBar(

                                  content: Text(
                                    'Berhasil di Bookmark 💖',
                                  ),

                                  backgroundColor:
                                      Colors.pink,
                                ),
                              );
                            }

                          } else {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              const SnackBar(

                                content: Text(
                                  'Produk sudah dibookmark',
                                ),
                              ),
                            );
                          }

                          setState(() {});
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