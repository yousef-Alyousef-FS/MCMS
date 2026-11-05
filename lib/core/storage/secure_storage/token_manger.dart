import 'package:medical_center/core/storage/secure_storage/secure_storage_service.dart';

class TokenManager {

  TokenManager(this._storage);
  final SecureStorageService _storage;

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
    // save access token
  }

  Future<String?> getAccessToken() async {
    return await _storage.read('access_token');
  
    // get access token
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
    // save refresh token
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read('refresh_token');
  
    // get refresh token
  }

  Future<void> clearTokens() async {
    await _storage.delete('access_token');
    await _storage.delete('refresh_token');
  }

  Future<bool> hasToken() async {
    // check if access token exists
    return await _storage.containsKey('access_token');
  }
}
