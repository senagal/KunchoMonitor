import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'AuthPage.dart';
import 'HomePage.dart';
import 'MusicPlayerPage.dart';
import 'ProfilePage.dart';
import 'favorite_songs_page.dart';
import 'loadUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('usersBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Music Player',
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'ComicNeue'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(),
        '/music': (context) => MusicPlayerPage(),
        '/profile': (context) => ProfilePage(),
        '/favorites': (context) => FavoriteSongsPage(),
      },
    );
  }
}
