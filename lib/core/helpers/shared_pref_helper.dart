import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  StorageHelper._(); // private constructor → static usage only

  // ────────────────────────────────────────────
  //  SharedPreferences - General Methods
  // ────────────────────────────────────────────

  static Future<SharedPreferences> _getPrefs() =>
      SharedPreferences.getInstance();

  static Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
    if (kDebugMode) debugPrint('Storage → removed: $key');
  }

  static Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
    if (kDebugMode) debugPrint('Storage → SharedPreferences cleared');
  }

  // ────────────────────────────────────────────
  //  Generic typed write / read
  // ────────────────────────────────────────────

  static Future<void> setValue<T>(String key, T value) async {
    final prefs = await _getPrefs();

    if (kDebugMode) {
      debugPrint('Storage → set $key = $value (${value.runtimeType})');
    }

    switch (value) {
      case String _:
        await prefs.setString(key, value);
      case int _:
        await prefs.setInt(key, value);
      case bool _:
        await prefs.setBool(key, value);
      case double _:
        await prefs.setDouble(key, value);
      case List<String> _:
        await prefs.setStringList(key, value);
      default:
        if (kDebugMode) {
          debugPrint(
            'Storage → Unsupported type for key $key: ${value.runtimeType}',
          );
        }
    }
  }

  static Future<String?> getString(String key, {String? defaultValue}) async {
    final prefs = await _getPrefs();
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<int?> getInt(String key, {int? defaultValue}) async {
    final prefs = await _getPrefs();
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<bool?> getBool(String key, {bool? defaultValue}) async {
    final prefs = await _getPrefs();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<double?> getDouble(String key, {double? defaultValue}) async {
    final prefs = await _getPrefs();
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<List<String>?> getStringList(
    String key, {
    List<String>? defaultValue,
  }) async {
    final prefs = await _getPrefs();
    return prefs.getStringList(key) ?? defaultValue;
  }

  // ────────────────────────────────────────────
  //  Flutter Secure Storage (for sensitive data)
  // ────────────────────────────────────────────

  static const _secureStorage = FlutterSecureStorage();

  static Future<void> setSecureString(String key, String value) async {
    if (kDebugMode) {
      debugPrint('SecureStorage → set $key (length: ${value.length})');
    }
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecureString(String key) async {
    final value = await _secureStorage.read(key: key);
    if (kDebugMode && value != null) {
      debugPrint('SecureStorage → read $key (length: ${value.length})');
    }
    return value;
  }

  static Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
    if (kDebugMode) debugPrint('SecureStorage → removed: $key');
  }

  static Future<void> clearAllSecure() async {
    await _secureStorage.deleteAll();
    if (kDebugMode) debugPrint('SecureStorage → all data cleared');
  }

  // ────────────────────────────────────────────
  //  Role selection storage
  // ────────────────────────────────────────────

  static const String keySelectedRole = 'selected_role';

  static const String roleDoctor = 'doctor';
  static const String roleParent = 'parent';
  static const String roleWebsite = 'website';

  static Future<void> saveSelectedRole(String role) async {
    await setValue(keySelectedRole, role);
    if (kDebugMode) debugPrint('Storage → saved role: $role');
  }

  static Future<String?> getSelectedRole() async {
    final role = await getString(keySelectedRole);
    if (kDebugMode) debugPrint('Storage → retrieved role: $role');
    return role;
  }

  static Future<void> clearSelectedRole() async {
    await remove(keySelectedRole);
  }

  // ────────────────────────────────────────────
  //  Common / Reusable high-level helpers
  // ────────────────────────────────────────────

  static Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await setValue(key, jsonEncode(json));
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    final raw = await getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) debugPrint('Storage → json decode failed for $key: $e');
      return null;
    }
  }

  // ────────────────────────────────────────────
  //  First launch / onboarding pattern
  // ────────────────────────────────────────────

  static const String keyFirstLaunch = 'first_launch';

  static Future<bool> isFirstLaunch() async {
    return await getBool(keyFirstLaunch, defaultValue: true) ?? true;
  }

  static Future<void> setNotFirstLaunch() async {
    await setValue(keyFirstLaunch, false);
  }

  // ────────────────────────────────────────────
  //  Auth related helpers (customize / remove as needed)
  // ────────────────────────────────────────────

  static const String keyUserEmail = 'user_email';
  static const String keyAccessToken = 'access_token';
  static const String keyUserName = 'user_name';

  static Future<void> saveEmail(String email) => setValue(keyUserEmail, email);
  static Future<String?> getEmail() => getString(keyUserEmail);

  static Future<void> saveAccessToken(String token) =>
      setSecureString(keyAccessToken, token);

  static Future<String?> getAccessToken() => getSecureString(keyAccessToken);

  static Future<void> saveUserName(String userName) =>
      setValue(keyUserName, userName);

  static Future<String?> getUserName() => getString(keyUserName);

  // ────────────────────────────────────────────
  //  Selected child (persisted across screens)
  // ────────────────────────────────────────────

  static const String keyChildId = 'selected_child_id';

  /// Persists the most-recently used child id so every downstream screen
  /// can resolve it without requiring a route argument.
  static Future<void> saveChildId(int childId) => setValue(keyChildId, childId);

  /// Returns the stored child id, or [defaultValue] (1) when none has been
  /// saved yet.
  static Future<int> getChildId({int defaultValue = 1}) async =>
      await getInt(keyChildId) ?? defaultValue;

  static Future<void> clearAuthData() async {
    await Future.wait([
      remove(keyUserEmail),
      remove(keyUserName),
      removeSecure(keyAccessToken),
      clearSelectedRole(),
    ]);
  }
}
