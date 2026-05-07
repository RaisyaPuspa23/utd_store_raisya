import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/product/domain/product_bookmark_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ProductBookmarkSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Simpan Bookmark
  Future<void> saveBookmark(ProductBookmark bookmark) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.productBookmarks.putSync(bookmark));
  }

  // Hapus Bookmark
  Future<void> deleteBookmark(int id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.productBookmarks.deleteSync(id));
  }

  // Stream Reaktif (Logika Reactive UI) - Modul 6
  Stream<List<ProductBookmark>> getBookmarksStream() async* {
    final isar = await db;
    yield* isar.productBookmarks.where().watch(fireImmediately: true);
  }
}