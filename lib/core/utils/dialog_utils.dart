import 'package:flutter/material.dart';
import 'package:tonga_weather/core/constants/constant.dart';
import 'package:tonga_weather/core/theme/app_colors.dart';

class DialogUtils {
  static Future<void> showNoInternetDialog(
    BuildContext context, {
    required bool isConnected,
    required Future<void> Function() onRetry,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please check your internet connection and try again.",
              ),
              const SizedBox(height: kBodyHp),
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.wifi : Icons.wifi_off,
                    color: isConnected ? kGreen : kRed,
                  ),
                  const SizedBox(width: kElementWidthGap),
                  Text(
                    isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: isConnected ? kGreen : kRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isConnected
                  ? () async {
                      Navigator.of(context).pop();
                      await onRetry();
                    }
                  : null,
              child: const Text("Retry"),
            ),
          ],
        );
      },
    );
  }
}
