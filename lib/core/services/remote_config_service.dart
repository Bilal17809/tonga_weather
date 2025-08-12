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

  bool getBool(String androidKey, String iosKey) {
    final key = _selectPlatformKey(androidKey, iosKey);
    return _remoteConfig.getBool(key);
  }

  int getInt(String androidKey, String iosKey) {
    final key = _selectPlatformKey(androidKey, iosKey);
    return _remoteConfig.getInt(key);
  }

  String getString(String androidKey, String iosKey) {
    final key = _selectPlatformKey(androidKey, iosKey);
    return _remoteConfig.getString(key);
  }

  String _selectPlatformKey(String androidKey, String iosKey) {
    if (Platform.isAndroid) {
      if (androidKey.isEmpty) throw UnsupportedError('Android key missing');
      return androidKey;
    } else if (Platform.isIOS) {
      if (iosKey.isEmpty) throw UnsupportedError('iOS key missing');
      return iosKey;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
