import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  static LocalStorage? _localStorage;

  static Future<void> init() async {
    _localStorage = LocalStorage('app_data');
    await _localStorage!.ready;
  }

  static Future<void> saveData(String key, dynamic value) async {
    if (_localStorage == null) {
      await init();
    }
    await _localStorage!.setItem(key, value);
  }

  static dynamic getData(String key) {
    if (_localStorage == null) {
      throw Exception('Local storage not initialized');
    }
    return _localStorage!.getItem(key);
  }
}
