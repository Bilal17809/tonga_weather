import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/dialog_utils.dart';

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  final RxBool isConnectedRx = false.obs;
  final _internetStatusController = StreamController<bool>.broadcast();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkInitialConnection();
    _listenToChanges();
  }

  @override
  void onClose() {
    _subscription.cancel();
    _internetStatusController.close();
    super.onClose();
  }

  Future<void> _checkInitialConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      result.first == ConnectivityResult.none
          ? _updateConnectionStatus(false)
          : await _verifyInternet();
    } catch (_) {
      _updateConnectionStatus(false);
    }
  }

  void _listenToChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      results.first == ConnectivityResult.none
          ? _updateConnectionStatus(false)
          : await _verifyInternet();
    }, onError: (_) => _updateConnectionStatus(false));
  }

  Future<void> _verifyInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _updateConnectionStatus(connected);
    } catch (_) {
      _updateConnectionStatus(false);
    }
  }

  void _updateConnectionStatus(bool status) {
    if (isConnectedRx.value != status) {
      isConnectedRx.value = status;
      _internetStatusController.add(status);
    }
  }

  Future<bool> checkInternetWithDialog(
    BuildContext context, {
    required Future<void> Function() onRetry,
  }) async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (!hasInternet) {
        await DialogUtil.showNoInternetDialog(Get.context!, onRetry: onRetry);
        return false;
      }
      return true;
    } catch (_) {
      await DialogUtil.showNoInternetDialog(Get.context!, onRetry: onRetry);
      return false;
    }
  }

  Stream<bool> get internetStatusStream => _internetStatusController.stream;
}
