import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  // Memastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp.router agar bisa memakai GoRouter
    return MaterialApp.router(
      title: 'UTD Store Raisya',
      debugShowCheckedModeBanner: false,
      // Menyambungkan ke file app_router.dart yang tadi kita buat
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}