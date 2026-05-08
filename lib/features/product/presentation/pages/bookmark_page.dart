import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/isar_service.dart';
import '../../domain/product_bookmark_model.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorite Products 💖'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      backgroundColor: Colors.pink.shade50,

      body: StreamBuilder<List<ProductBookmark>>(
        stream: isarService.getBookmarksStream(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          }

          final bookmarks = snapshot.data ?? [];

          // Kalau belum ada bookmark
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.pink,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Belum ada produk favorit 💔',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {

              final item = bookmarks[index];

              // LOGIKA PERSONAL NIM 07
              final jamSimpan =
                  DateFormat('HH:mm').format(item.createdAt);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: Image.network(
                        item.image,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),

                    title: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),

                      child: Text(
                        'Disimpan pukul: $jamSimpan',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),

                      onPressed: () async {

                        await isarService.deleteBookmark(item.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Bookmark dihapus',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}