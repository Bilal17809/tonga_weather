import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(minutes: 1),
  }) async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  bool getBool(String androidKey) {
    final key = androidKey;
    if (key.isEmpty) throw UnsupportedError('Platform not supported');
    return _remoteConfig.getBool(key) || true;
  }

  int getInt(String androidKey, String iosKey) {
    final key = Platform.isAndroid
        ? androidKey
        : Platform.isIOS
        ? iosKey
        : '';
    if (key.isEmpty) throw UnsupportedError('Platform not supported');
    return _remoteConfig.getInt(key);
  }
}
