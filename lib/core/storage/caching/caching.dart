abstract class Caching {
  Future<void> save(String key, dynamic value);

  Future<dynamic> get(String key);

  Future<void> remove(String key);

  Future<void> clear();
}
