import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'AuthPage.dart';
import 'HomePage.dart';
import 'MusicPlayerPage.dart';
import 'ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with path from path_provider
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  // Open the users box
  await Hive.openBox('usersBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Music Player',
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'ComicNeue'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/home': (context) => HomePage(),
        '/music': (context) => MusicPlayerPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
