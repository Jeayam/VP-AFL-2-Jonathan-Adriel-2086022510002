import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/storage_exception.dart';

class SettingsService {
  static const _darkModeKey = 'dark_mode_enabled';
  static const _defaultsAssetPath = 'assets/data/settings_defaults.json';

  final AssetBundle _assetBundle;

  SettingsService({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  Future<bool> loadDarkMode() async {
    final preferences = await SharedPreferences.getInstance();
    final savedValue = preferences.getBool(_darkModeKey);
    if (savedValue != null) return savedValue;

    final source = await _assetBundle.loadString(_defaultsAssetPath);
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Default pengaturan tema tidak valid.');
    }

    final defaultValue = decoded['darkModeEnabled'];
    if (defaultValue is! bool) {
      throw const FormatException(
        'Nilai default darkModeEnabled harus berupa boolean.',
      );
    }
    return defaultValue;
  }

  Future<void> saveDarkMode(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setBool(_darkModeKey, enabled);
    if (!saved) {
      throw const StorageException('Pengaturan tema tidak berhasil disimpan.');
    }
  }
}
