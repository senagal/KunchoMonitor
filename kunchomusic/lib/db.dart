import 'package:hive/hive.dart';

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
  await openHiveBox();
  final box = Hive.box('usersBox');
  await box.put('currentUser', username);
}

Future<String?> getCurrentUser() async {
  await openHiveBox();
  final box = Hive.box('usersBox');
  String? user = box.get('currentUser');
  print('Current user loaded from Hive: $user');
  return user;
}

Future<List<String>> getStarredSongs(String? username) async {
  if (username == null) return [];
  await openHiveBox();
  final box = Hive.box('usersBox');
  final List<dynamic>? songs = box.get('starred_$username');
  if (songs == null) return [];
  return songs.cast<String>();
}

Future<void> saveStarredSongs(String username, List<String> songs) async {
  await openHiveBox();
  final box = Hive.box('usersBox');
  await box.put('starred_$username', songs);
}
