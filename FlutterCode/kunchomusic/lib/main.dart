import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
