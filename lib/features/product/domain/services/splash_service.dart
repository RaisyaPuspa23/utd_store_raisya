import 'dart:async';

class SplashService {
  Future<void> waitForSplash() async {
    // Logika NIM Raisya 20123007: Delay 7 Detik
    await Future.delayed(const Duration(seconds: 7)); 
  }
}