import 'package:hive/hive.dart';

Future<void> insertUser(String username, String password) async {
  final box = Hive.box('usersBox');
  await box.put(username, password);
}

Future<Map<String, String>?> getUser(String username) async {
  final box = Hive.box('usersBox');
  if (box.containsKey(username)) {
    return {'username': username, 'password': box.get(username)};
  }
  return null;
}
