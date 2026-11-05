import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
    // write value
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  
    // read value
  }

  Future<void> delete(String key) async {
    return await _storage.delete(key: key);
    // delete value
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
    // delete all values
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
    // check key
  }
}
