import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/services.dart';
import '../constants/constant.dart';
import '/core/theme/theme.dart';

class DialogUtil {
  static Future<void> showNoInternetDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) {
    final RxBool isConnected = ConnectivityService.instance.isConnectedRx;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("No Internet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please check your internet connection and try again."),
            const SizedBox(height: kBodyHp),
            Obx(
              () => Row(
                children: [
                  Icon(
                    isConnected.value ? Icons.wifi : Icons.wifi_off,
                    color: isConnected.value ? kGreen : kRed,
                  ),
                  const SizedBox(width: kElementWidthGap),
                  Text(
                    isConnected.value ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: isConnected.value ? kGreen : kRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isConnected.value
                  ? () async {
                      Navigator.of(context).pop();
                      await onRetry();
                    }
                  : null,
              child: const Text("Retry"),
            ),
          ),
        ],
      ),
    );
  }
}
