import '../models/user_model.dart';
import '../../core/local_storage/local_database.dart';
import '../../core/local_storage/shared_preference_helper.dart';
import '../../core/error/exception.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<bool> isUserLoggedIn();
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalDatabase _localDatabase;
  final SharedPreferenceHelper _preferences;

  AuthLocalDataSourceImpl({
    required LocalDatabase localDatabase,
    required SharedPreferenceHelper preferences,
  })  : _localDatabase = localDatabase,
        _preferences = preferences;

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      // Save to local database
      await _localDatabase.insert('users', user.toDatabase());

      // Save token and user ID to preferences
      await _preferences.saveToken(user.token);
      await _preferences.saveUserId(user.id);
      await _preferences.saveUserEmail(user.email);
    } catch (e) {
      throw CacheException(message: 'Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userId = _preferences.getUserId();
      if (userId == null) return null;

      final result = await _localDatabase.queryWhere(
        'users',
        'userId = ?',
        [userId],
      );

      if (result.isEmpty) return null;

      return UserModel.fromDatabase(result.first);
    } catch (e) {
      throw CacheException(message: 'Failed to get user: $e');
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = _preferences.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      throw CacheException(message: 'Failed to check login status: $e');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final userId = _preferences.getUserId();
      if (userId != null) {
        await _localDatabase.delete('users', 'userId = ?', [userId]);
      }
      await _preferences.clearToken();
      await _preferences.clearAll();
    } catch (e) {
      throw CacheException(message: 'Failed to delete user: $e');
    }
  }
}