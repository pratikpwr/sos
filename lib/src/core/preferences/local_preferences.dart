import 'package:shared_preferences/shared_preferences.dart';

import '../error/exception.dart';

class LocalPreferences {
  static LocalPreferences? _instance;

  LocalPreferences._internal();

  factory LocalPreferences() => _instance ?? LocalPreferences._internal();

  late SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return;
  }

  Future<bool> set<T>(String key, T value) async {
    if (value == null) {
      return Future.value(false);
    }

    if (!(<Type>[bool, double, int, String, List<String>].contains(T))) {
      throw const CacheException("Argument is of unexpected type");
    }

    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    } else if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else {
      throw const CacheException("Unexpected type passed as argument");
    }
  }

  T? get<T>(String key) {
    if ((T is bool?) || T is bool) {
      return sharedPreferences.getBool(key) as T?;
    } else if ((T is double?) || T is double) {
      return sharedPreferences.getDouble(key) as T?;
    } else if ((T is int?) || T is int) {
      return sharedPreferences.getInt(key) as T?;
    } else if ((T is List<String>?) || T is List<String>) {
      return sharedPreferences.getStringList(key) as T?;
    } else if ((T is String?) || T is String) {
      return sharedPreferences.getString(key) as T?;
    } else {
      // throw LocalStorageException("Unexpected type passed as argument");
      return sharedPreferences.get(key) as T?;
    }
  }

  Future<bool> remove(String key) => sharedPreferences.remove(key);

  Future<bool> clear() => sharedPreferences.clear();
}
