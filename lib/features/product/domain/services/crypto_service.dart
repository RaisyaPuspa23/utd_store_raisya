import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoService {

  WebSocketChannel? channel;

  final StreamController<String>
      _bitcoinController =
      StreamController.broadcast();

  Stream<String> get bitcoinPriceStream =>
      _bitcoinController.stream;

  void connect() {

    try {

      channel = WebSocketChannel.connect(
        Uri.parse(
          'wss://ws.coincap.io/prices?assets=bitcoin',
        ),
      );

      channel!.stream.listen(

        (event) {

          final data = jsonDecode(event);

          final price =
              data['bitcoin'] ?? '0';

          _bitcoinController.add(price);
        },

        onError: (error) {

          print(
            "WebSocket Error: $error",
          );
        },

        onDone: () {

          print(
            "WebSocket Closed",
          );
        },
      );

    } catch (e) {

      print("Connection Error: $e");
    }
  }

  void dispose() {

    channel?.sink.close();

    _bitcoinController.close();
  }
}