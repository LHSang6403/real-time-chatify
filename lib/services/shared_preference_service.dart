import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  SharedPreference() {
    init();
  }

  Future<void> init() async {
    try {
      /// Checks if shared preference exist
      Future prefsTemp = SharedPreferences.getInstance();
      final SharedPreferences prefs = await prefsTemp;
      prefs.getString("app-name");
    } catch (err) {
      print(err);
      SharedPreferences.setMockInitialValues({});
      Future prefsTemp = SharedPreferences.getInstance();
      final SharedPreferences prefs = await prefsTemp;
      prefs.setString("app-name", "RT Chatify");
    }
  }

  dynamic writeBoolToLocal(String key, bool value) async {
    Future prefsTemp = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefsTemp;
    var res = prefs.setBool(key, value);
    return res;
  }

  dynamic readBoolFormLocal(String key) async {
    Future prefsTemp = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefsTemp;
    bool res = prefs.getBool(key)!;
    return res;
  }

  Future reset() async {
    Future prefsTemp = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefsTemp;
    prefs.clear();
  }
}
