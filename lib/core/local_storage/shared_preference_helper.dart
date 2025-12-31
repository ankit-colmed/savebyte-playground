import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences _preferences;

  SharedPreferenceHelper(this._preferences);

  // User token
  Future<bool> saveToken(String token) {
    return _preferences.setString('auth_token', token);
  }

  String? getToken() {
    return _preferences.getString('auth_token');
  }

  Future<bool> clearToken() {
    return _preferences.remove('auth_token');
  }

  // User ID
  Future<bool> saveUserId(String userId) {
    return _preferences.setString('user_id', userId);
  }

  String? getUserId() {
    return _preferences.getString('user_id');
  }

  // User email
  Future<bool> saveUserEmail(String email) {
    return _preferences.setString('user_email', email);
  }

  String? getUserEmail() {
    return _preferences.getString('user_email');
  }

  // Last sync time
  Future<bool> saveLastSyncTime(DateTime dateTime) {
    return _preferences.setString('last_sync_time', dateTime.toIso8601String());
  }

  DateTime? getLastSyncTime() {
    final timeString = _preferences.getString('last_sync_time');
    if (timeString == null) return null;
    return DateTime.parse(timeString);
  }

  // Clear all
  Future<bool> clearAll() {
    return _preferences.clear();
  }
}