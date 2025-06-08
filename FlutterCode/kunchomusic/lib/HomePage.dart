import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUser;
  List<Map<String, dynamic>> songs = [];
  List<String> starredSongs = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSongs();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('currentUser');
      starredSongs = prefs.getStringList('starred_$currentUser') ?? [];
    });
  }

  Future<void> _loadSongs() async {
    // For demo, we're using a hardcoded list
    setState(() {
      songs = [
        {
          'id': '1',
          'title': 'Twinkle Twinkle Little Star',
          'artist': 'Kids Songs',
          'duration': '1:45',
          'path': 'twinkle.mp3',
          'image': 'twinkle.jpg',
        },
        {
          'id': '2',
          'title': 'Old MacDonald',
          'artist': 'Kids Songs',
          'duration': '2:10',
          'path': 'macdonald.mp3',
          'image': 'farm.jpg',
        },
        {
          'id': '3',
          'title': 'The Wheels on the Bus',
          'artist': 'Kids Songs',
          'duration': '2:30',
          'path': 'wheels.mp3',
          'image': 'bus.png',
        },
      ];
    });
  }

  void _toggleStar(String songId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (starredSongs.contains(songId)) {
        starredSongs.remove(songId);
      } else {
        starredSongs.add(songId);
      }
    });
    await prefs.setStringList('starred_$currentUser', starredSongs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kids Music Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hello, $currentUser!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final isStarred = starredSongs.contains(song['id']);
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/${song['image']}'),
                    ),
                    title: Text(song['title']),
                    subtitle: Text(song['artist']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isStarred ? Icons.star : Icons.star_border,
                            color: isStarred ? Colors.amber : null,
                          ),
                          onPressed: () => _toggleStar(song['id']),
                        ),
                        Text(song['duration']),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/music', arguments: song);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
