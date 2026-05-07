import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../network/isar_service.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register Network (Dio)
  locator.registerLazySingleton<Dio>(() => DioClient().dio);

  // 2. Register Local Database (Isar)
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Register Repository
  locator.registerLazySingleton<ProductRepositoryImpl>(
    () => ProductRepositoryImpl(locator<Dio>()),
  );

  // 4. Register Cubit (State Management)
  // Pakai registerFactory agar Cubit baru dibuat setiap kali halaman dibuka
  locator.registerFactory<ProductCubit>(
    () => ProductCubit(locator<ProductRepositoryImpl>()),
  );
}