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

  // =========================
  // SAVE BOOKMARK
  // =========================
  Future<void> saveBookmark(ProductBookmark bookmark) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.productBookmarks.put(bookmark);
    });
  }

  // =========================
  // DELETE BOOKMARK
  // =========================
  Future<void> deleteBookmark(int id) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.productBookmarks.delete(id);
    });
  }

  // =========================
  // STREAM BOOKMARK
  // =========================
  Stream<List<ProductBookmark>> getBookmarksStream() async* {
    final isar = await db;

    yield* isar.productBookmarks
        .where()
        .watch(fireImmediately: true);
  }

  // =========================
  // GET ALL BOOKMARKS
  // =========================
  Future<List<ProductBookmark>> getBookmarks() async {
    final isar = await db;

    return await isar.productBookmarks
        .where()
        .findAll();
  }
}