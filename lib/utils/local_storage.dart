import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

GetStorage localStorage = GetStorage();

void setValueToLocal(String key, dynamic value) {
  log('setValueToLocal : ${value.runtimeType} - $key - $value');
  localStorage.write(key, value);
}

T getValueFromLocal<T>(String key) {
  final val = localStorage.read(key);
  log("getValueFromLocal : ${val.runtimeType} - $key - $val");
  return val;
}

void removeValueFromLocal(String key) {
  log("removeValueFromLocal : $key");
  localStorage.remove(key);
}

/// Returns a Bool if exists in SharedPref
bool getBoolValueAsync(String key, {bool defaultValue = false}) {
  return sharedPreferences.getBool(key) ?? defaultValue;
}