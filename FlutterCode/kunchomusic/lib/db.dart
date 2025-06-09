import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> openHiveBox() async {
  if (!Hive.isBoxOpen('usersBox')) {
    await Hive.openBox('usersBox');
  }
}

Future<void> insertUser(String username, String password) async {
  await openHiveBox();
  final box = Hive.box('usersBox');
  await box.put(username, password);
}

Future<Map<String, String>?> getUser(String username) async {
  await openHiveBox();
  final box = Hive.box('usersBox');
  if (box.containsKey(username)) {
    return {'username': username, 'password': box.get(username)};
  }
  return null;
}

Future<void> setCurrentUser(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('currentUser', username);
}

Future<String?> getCurrentUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('currentUser');
}

Future<List<String>> getStarredSongs(String? username) async {
  final prefs = await SharedPreferences.getInstance();
  if (username == null) return [];
  return prefs.getStringList('starred_$username') ?? [];
}

Future<void> saveStarredSongs(String username, List<String> songs) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('starred_$username', songs);
}
