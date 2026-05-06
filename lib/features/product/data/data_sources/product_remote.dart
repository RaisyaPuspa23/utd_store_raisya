import 'package:dio/dio.dart';

class ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSource(this.dio);

  Future<List<dynamic>> getProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');
    return response.data;
  }
}