import 'package:flutter/foundation.dart';

Future<String> calculateCryptoTax() async {

  final result = await compute(
    heavyCalculation,
    70000000,
  );

  return result;
}

String heavyCalculation(int totalLoop) {

  final total =
      longCalculation(totalLoop);

  return
      "Total Pajak Kripto selesai 🚀 Hasil: $total";
}

int longCalculation(int totalLoop) {

  int total = 0;

  for (int i = 0; i < totalLoop; i++) {

    total += i;

    // biar emulator ga freeze brutal
    if (i % 1000000 == 0) {

      total ~/= 2;
    }
  }

  return total;
}