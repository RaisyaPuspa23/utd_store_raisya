import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../domain/services/realtime_product_service.dart';
import '../../domain/services/crypto_service.dart';
import '../../domain/services/crypto_tax_service.dart';

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

  // 🔥 BITCOIN REALTIME
  final cryptoService = CryptoService();

  String bitcoinPrice = "0";

  bool isCalculatingTax = false;

  // 🔥 REALTIME PRODUCT
  final realtimeService = RealtimeProductService();

  List<Map<String, dynamic>> realtimeProducts = [];

  // 🔥 BOOKMARK
  List<String> bookmarkedIds = [];

  @override
  void initState() {
    super.initState();

    fetchProducts();
    loadBookmarks();

    // REALTIME PRODUCT
    realtimeService.startRealtimeUpdates();

    realtimeService.productStream.listen((data) {

      setState(() {

        realtimeProducts =
            List<Map<String, dynamic>>.from(data);

      });

    });

    // REALTIME BITCOIN
    cryptoService.bitcoinPriceStream.listen((price) {

      setState(() {

        bitcoinPrice = price;

      });

    });

  }

  // 🔥 FETCH API
  Future<void> fetchProducts() async {

    try {

      final response =
          await Dio().get(
        'https://fakestoreapi.com/products',
      );

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

    final isarService =
        locator<IsarService>();

    final bookmarks =
        await isarService.getBookmarks();

    setState(() {

      bookmarkedIds =
          bookmarks.map((e) => e.productId).toList();

    });
  }

  @override
  void dispose() {

    realtimeService.dispose();

    cryptoService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('UTD Store Raisya'),

        backgroundColor: Colors.pink,

        foregroundColor: Colors.white,

        actions: [

          // 🔥 BUTTON BOOKMARK
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

          : Column(

              children: [

                // 🔥 CARD BITCOIN REALTIME
                Container(

                  margin: const EdgeInsets.all(12),

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(16),

                    boxShadow: const [

                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black12,
                      ),

                    ],
                  ),

                  child: Column(

                    children: [

                      const Row(

                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.currency_bitcoin,
                            color: Colors.orange,
                          ),

                          SizedBox(width: 8),

                          Text(

                            "Bitcoin Real-time Price",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,

                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(

                        "\$$bitcoinPrice",

                        style: const TextStyle(

                          fontSize: 28,

                          fontWeight: FontWeight.bold,

                          color: Colors.green,

                        ),
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.pink,

                          foregroundColor: Colors.white,

                        ),

                        onPressed: isCalculatingTax

                            ? null

                            : () async {

                                setState(() {

                                  isCalculatingTax = true;

                                });

                                final result =
                                    await calculateCryptoTax();

                                setState(() {

                                  isCalculatingTax = false;

                                });

                                if (context.mounted) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    SnackBar(

                                      content: Text(
                                        result,
                                      ),

                                      backgroundColor:
                                          Colors.pink,
                                    ),
                                  );
                                }
                              },

                        child: isCalculatingTax

                            ? const SizedBox(

                                width: 20,

                                height: 20,

                                child:
                                    CircularProgressIndicator(

                                  color: Colors.white,

                                  strokeWidth: 2,
                                ),
                              )

                            : const Text(
                                "Kalkulasi Pajak Kripto",
                              ),
                      ),
                    ],
                  ),
                ),

                // 🔥 LIST PRODUCT
                Expanded(

                  child: ListView.builder(

                    itemCount:
                        realtimeProducts.length +
                            products.length,

                    itemBuilder: (context, index) {

                      final product =
                          index < realtimeProducts.length

                              ? realtimeProducts[index]

                              : products[
                                  index -
                                      realtimeProducts.length
                                ];

                      final String displayTitle =
                          "${product['title']} [Diskon 10%]";

                      final bool isBookmarked =
                          bookmarkedIds.contains(
                        product['id'].toString(),
                      );

                      return Padding(

                        padding:
                            const EdgeInsets.symmetric(

                          horizontal: 10,

                          vertical: 6,
                        ),

                        child: Card(

                          elevation: 4,

                          shape:
                              RoundedRectangleBorder(

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
                                    (context,
                                        error,
                                        stackTrace) {

                                  return const Icon(
                                    Icons
                                        .image_not_supported,
                                  );
                                },
                              ),
                            ),

                            title: Text(

                              displayTitle,

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
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

                                if (!isBookmarked) {

                                  final bookmark =
                                      ProductBookmark()

                                        ..productId =
                                            product['id']
                                                .toString()

                                        ..name =
                                            displayTitle

                                        ..image =
                                            product['image']

                                        ..createdAt =
                                            DateTime.now();

                                  await isarService
                                      .saveBookmark(
                                    bookmark,
                                  );

                                  bookmarkedIds.add(
                                    product['id']
                                        .toString(),
                                  );

                                  if (context.mounted) {

                                    ScaffoldMessenger.of(
                                            context)
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

                                  ScaffoldMessenger.of(
                                          context)
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
                ),
              ],
            ),
    );
  }
}