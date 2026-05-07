import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRepository {
  final Dio dio;

  ProductRepository(this.dio);

  Future<List<ProductModel>> getProducts() async {
    final response =
        await dio.get('https://fakestoreapi.com/products');

    List data = response.data;

    // 🔥 LOGIKA NIM GANJIL DI SINI (BUKAN DI UI)
    return data.map((json) {
      final product = ProductModel.fromJson(json);

      return ProductModel(
        title: "${product.title} [Diskon 10%]",
        price: product.price,
        image: product.image,
      );
    }).toList();
  }
}