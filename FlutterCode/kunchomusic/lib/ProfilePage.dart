import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? currentUser;
  List<String> starredSongs = [];
  List<Map<String, dynamic>> allSongs = [];
  bool isLoading = true;

  // Your new avatar images
  final List<String> avatarPaths = [
    'assets/wero.jpg',
    'assets/Abush.png',
    'assets/birabiro.png',
    'assets/Bitiko.png',
    'assets/Mitu.png',
  ];

  String? selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSongs();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('currentUser');
    final box =
        await Hive.isBoxOpen('usersBox')
            ? Hive.box('usersBox')
            : await Hive.openBox('usersBox');
    final savedAvatar = prefs.getString('avatar_$username');

    setState(() {
      if (username != null && box.containsKey(username)) {
        currentUser = username;
        starredSongs = prefs.getStringList('starred_$username') ?? [];
        selectedAvatarPath = savedAvatar ?? avatarPaths[0]; // default avatar
      } else {
        currentUser = 'Guest';
        selectedAvatarPath = avatarPaths[0];
      }
      isLoading = false;
    });
  }

  Future<void> _loadSongs() async {
    // dummy data
    setState(() {
      allSongs = [
        {'id': '1', 'title': 'Twinkle Twinkle Little Star'},
        {'id': '2', 'title': 'Old MacDonald'},
        {'id': '3', 'title': 'The Wheels on the Bus'},
      ];
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            selectedAvatarPath != null
                                ? AssetImage(selectedAvatarPath!)
                                : null,
                        child:
                            selectedAvatarPath == null
                                ? Icon(Icons.account_circle, size: 60)
                                : null,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        currentUser ?? 'Guest',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Choose your Avatar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children:
                          avatarPaths.map((path) {
                            bool isSelected = selectedAvatarPath == path;
                            return GestureDetector(
                              onTap: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                if (currentUser != null) {
                                  await prefs.setString(
                                    'avatar_$currentUser',
                                    path,
                                  );
                                }
                                setState(() {
                                  selectedAvatarPath = path;
                                });
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(path),
                                child:
                                    isSelected
                                        ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.purple,
                                              width: 3,
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 30),
                    Text(
                      'Starred Songs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child:
                          starredSongs.isEmpty
                              ? Center(child: Text('No starred songs yet!'))
                              : ListView.builder(
                                itemCount: starredSongs.length,
                                itemBuilder: (context, index) {
                                  final songId = starredSongs[index];
                                  final song = allSongs.firstWhere(
                                    (s) => s['id'] == songId,
                                    orElse: () => {'title': 'Unknown Song'},
                                  );
                                  return ListTile(
                                    title: Text(song['title']),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () async {
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        setState(() {
                                          starredSongs.remove(songId);
                                        });
                                        await prefs.setStringList(
                                          'starred_$currentUser',
                                          starredSongs,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: _logout,
                        child: Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
