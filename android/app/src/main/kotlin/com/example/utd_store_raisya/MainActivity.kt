package com.example.utd_store_raisya

import android.content.Context
import android.os.BatteryManager
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "battery.channel"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {

        super.configureFlutterEngine(
            flutterEngine
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "getBatteryLevel") {

                val batteryLevel =
                    getBatteryLevel()

                result.success(
                    batteryLevel.toString()
                )

            } else if (call.method == "showToast") {

                Toast.makeText(

                    this,

                    "Native Android Toast 🚀",

                    Toast.LENGTH_SHORT

                ).show()

                result.success(null)

            } else {

                result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {

        val batteryManager =
            getSystemService(
                Context.BATTERY_SERVICE
            ) as BatteryManager

        return batteryManager.getIntProperty(
            BatteryManager.BATTERY_PROPERTY_CAPACITY
        )
    }
}