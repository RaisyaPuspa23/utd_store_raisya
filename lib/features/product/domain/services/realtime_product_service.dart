import 'dart:async';

class RealtimeProductService {

  final StreamController<List>
      _productController =
      StreamController.broadcast();

  List realtimeProducts = [];

  Stream<List> get productStream =>
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
              "New Product ${realtimeProducts.length + 1}",

          "price": 99.9,

          "image":
              "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        };

        realtimeProducts.insert(0, newProduct);

        _productController.add(realtimeProducts);
      },
    );
  }

  void dispose() {
    _productController.close();
  }
}