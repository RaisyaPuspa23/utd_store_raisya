import 'package:isar/isar.dart';

// Penting: Pastikan nama file ini sama dengan bagian .g.dart di bawah
part 'product_bookmark_model.g.dart';

@collection
class ProductBookmark {
  Id id = Isar.autoIncrement; // ID otomatis dari Isar

  late String productId;
  late String name;
  late String image;
  
  // Logika Personal NIM 20123007: Menyimpan waktu simpan
  late DateTime createdAt;
}