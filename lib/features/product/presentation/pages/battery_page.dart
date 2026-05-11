import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() =>
      _BatteryPageState();
}

class _BatteryPageState
    extends State<BatteryPage> {

  static const platform = MethodChannel(
    'battery.channel',
  );

  String batteryLevel = "0";

  Future<void> getBatteryLevel() async {

    try {

      final String result =
          await platform.invokeMethod(
        'getBatteryLevel',
      );

      setState(() {

        batteryLevel = result;

      });

    } on PlatformException catch (e) {

      batteryLevel =
          "Failed: ${e.message}";
    }
  }

  Future<void> showNativeToast() async {

    try {

      await platform.invokeMethod(
        'showToast',
      );

    } on PlatformException catch (e) {

      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Native Battery Android",
        ),

        backgroundColor: Colors.pink,

        foregroundColor: Colors.white,
      ),

      backgroundColor: Colors.pink.shade50,

      body: Center(

        child: Container(

          margin: const EdgeInsets.all(20),

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),
          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Icon(

                Icons.battery_full,

                size: 100,

                color: Colors.green,
              ),

              const SizedBox(height: 20),

              Text(

                "$batteryLevel%",

                style: const TextStyle(

                  fontSize: 40,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(

                onPressed: getBatteryLevel,

                child: const Text(
                  "Check Battery",
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(

                onPressed: showNativeToast,

                child: const Text(
                  "Show Native Toast",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}