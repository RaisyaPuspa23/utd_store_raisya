import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/services/splash_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() async {
    // Pastikan import SplashService sudah benar di paling atas file
    await SplashService().waitForSplash();
    if (mounted) {
      context.go('/home'); // Pastikan path ini nanti ada di router
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 20),
            // Wajib tampilkan Nama dan NIM
            Text(
              "Raisya Puspa",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "20123007",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const Text("Loading... (7 Seconds)"),
          ],
        ),
      ),
    );
  }
}