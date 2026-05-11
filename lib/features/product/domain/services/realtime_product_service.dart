import 'dart:async';

class RealtimeProductService {

  final StreamController<List<Map<String, dynamic>>>
      _productController =
      StreamController.broadcast();

  List<Map<String, dynamic>> products = [];

  Stream<List<Map<String, dynamic>>> get productStream =>
      _productController.stream;

  void startRealtimeUpdates() {

    // simulasi realtime tiap 10 detik
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) {

        final newProduct = {

          "id": DateTime.now()
              .millisecondsSinceEpoch
              .toString(),

          "title":
              "New Product ${products.length + 1}",

          "price": 99.9,

          "image":
              "https://i.pravatar.cc/150?img=${products.length + 1}",
        };

        products.insert(0, newProduct);

        _productController.add(products);
      },
    );
  }

  void dispose() {
    _productController.close();
  }
}