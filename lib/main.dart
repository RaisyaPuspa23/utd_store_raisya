import 'package:flutter/material.dart';
import 'core/di/injection.dart'; // Import pelayan/injection kamu [cite: 456]
import 'core/router/app_router.dart';

void main() {
  // Memastikan binding Flutter sudah siap 
  WidgetsFlutterBinding.ensureInitialized();

  // WAJIB: Panggil setupLocator sebelum aplikasi jalan! 
  setupLocator(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTD Store Raisya',
      debugShowCheckedModeBanner: false,
      routerConfig: router, // Memakai router dari app_router.dart [cite: 471]
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), // Pakai pink sesuai style kamu
        useMaterial3: true,
      ),
    );
  }
}