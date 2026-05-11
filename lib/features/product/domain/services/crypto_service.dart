import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoService {

  late WebSocketChannel channel;

  final StreamController<String>
      _priceController =
      StreamController.broadcast();

  Stream<String> get bitcoinPriceStream =>
      _priceController.stream;

  CryptoService() {

    connectWebSocket();
  }

  void connectWebSocket() {

    channel = WebSocketChannel.connect(

      Uri.parse(
        'wss://ws.coincap.io/prices?assets=bitcoin',
      ),
    );

    channel.stream.listen(

      (event) {

        final data = jsonDecode(event);

        final price = data['bitcoin'];

        if (price != null) {

          _priceController.add(price);
        }
      },

      onError: (error) {

        print("WebSocket Error: $error");
      },

      onDone: () {

        print("WebSocket Closed");
      },
    );
  }

  void dispose() {

    channel.sink.close();

    _priceController.close();
  }
}