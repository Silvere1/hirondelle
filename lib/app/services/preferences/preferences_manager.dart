import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  SharedPreferences? _sharedPrefs;
  PrefManager._();

  static final PrefManager instance = PrefManager._();

  Future<SharedPreferences> get preference async {
    if (_sharedPrefs != null) {
      return _sharedPrefs!;
    } else {
      _sharedPrefs = await SharedPreferences.getInstance();
      return _sharedPrefs!;
    }
  }

  setStr(String key, String value) async {
    var pref = await instance.preference;
    await pref.setString(key, value);
  }

  setBool(String key, bool value) async {
    var pref = await instance.preference;
    await pref.setBool(key, value);
  }

  Future<bool> exist(String key) async {
    var pref = await instance.preference;
    return pref.containsKey(key);
  }

  bool existForce(String key) => _sharedPrefs!.containsKey(key);

  Future<String> getStr(String key) async {
    var pref = await instance.preference;
    return pref.getString(key)!;
  }

  String getStrForce(String key) =>
      existForce(key) ? _sharedPrefs!.getString(key)! : "";

  bool getBoolForce(String key) =>
      existForce(key) ? _sharedPrefs!.getBool(key)! : false;

  remove(String key) async {
    var pref = await instance.preference;
    pref.remove(key);
  }

  cleanAll() async {
    var pref = await instance.preference;
    await pref.clear();
  }
}
