import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../data/repositories/product_repository_impl.dart';
// import repository & entity...

abstract class ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductCubit extends Cubit<ProductState> {
  final ProductRepositoryImpl repository;
  ProductCubit(this.repository) : super(ProductLoading());

  void fetchProducts() async {
    try {
      emit(ProductLoading());
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}