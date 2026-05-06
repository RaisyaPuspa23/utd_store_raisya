import 'package:dio/dio.dart';
import '../../domain/entities/product.dart';
// import domain entity...

class ProductRepositoryImpl {
  final Dio dio;
  ProductRepositoryImpl(this.dio);

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');
      final List data = response.data;

      return data.map((item) {
        // LOGIKA NIM GANJIL: Tambahkan [Diskon 10%] di layer Service/Repo
        // Sesuai NIM Raisya 20123007
        String originalTitle = item['title'] ?? '';
        String modifiedTitle = "$originalTitle [Diskon 10%]"; 

        return Product(
          id: item['id'],
          title: modifiedTitle,
          price: (item['price'] as num).toDouble(),
          description: item['description'] ?? '',
          image: item['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Gagal ambil data: $e");
    }
  }
}