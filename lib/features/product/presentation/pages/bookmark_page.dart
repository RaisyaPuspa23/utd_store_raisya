import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Jalankan 'flutter pub add intl' di terminal
import '../../../../core/di/injection.dart';
import '../../../../core/network/isar_service.dart';
import '../../domain/product_bookmark_model.dart';


class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil IsarService melalui locator
    final isarService = locator<IsarService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Favorit'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      // StreamBuilder membuat UI reaktif (langsung berubah jika data dihapus)
      body: StreamBuilder<List<ProductBookmark>>(
        stream: isarService.getBookmarksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookmarks = snapshot.data ?? [];

          if (bookmarks.isEmpty) {
            return const Center(child: Text('Belum ada produk favorit.'));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              
              // LOGIKA PERSONAL NIM 07: Format waktu simpan
              final jamSimpan = DateFormat('HH:mm').format(item.createdAt);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Disimpan pukul: $jamSimpan'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Hapus dari database Isar
                      isarService.deleteBookmark(item.id);
                    },
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