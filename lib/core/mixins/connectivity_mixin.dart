import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/services.dart';
import '../common/app_exceptions.dart';
import '../utils/dialog_utils.dart';

mixin ConnectivityMixin on GetxController {
  final ConnectivityService connectivityService = ConnectivityService.instance;
  late final StreamSubscription<bool> _subscription;

  @override
  void onInit() {
    super.onInit();
    _subscription = connectivityService.internetStatusStream.listen(
      _handleInternetChange,
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  void _handleInternetChange(bool connected) {
    debugPrint('[$runtimeType] Internet status: $connected');
    connected ? onInternetConnected() : onInternetDisconnected();
  }

  void onInternetConnected() {
    debugPrint('[$runtimeType] Internet connected');
  }

  void onInternetDisconnected() {
    debugPrint('[$runtimeType] Internet disconnected');
  }

  Future<bool> ensureInternetConnection({
    required Future<void> Function() action,
    BuildContext? context,
  }) async {
    if (!connectivityService.isConnectedRx.value && context != null) {
      await DialogUtil.showNoInternetDialog(context, onRetry: action);
      return false;
    }
    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('[$runtimeType] Action failed: $e');
      return false;
    }
  }

  Future<void> initWithConnectivityCheck({
    required BuildContext context,
    required Future<void> Function() onConnected,
  }) async {
    final ok = await connectivityService.checkInternetWithDialog(
      context,
      onRetry: () =>
          initWithConnectivityCheck(context: context, onConnected: onConnected),
    );

    if (ok) {
      await onConnected();
    } else {
      debugPrint(AppExceptions().noInternet);
    }
  }
}
