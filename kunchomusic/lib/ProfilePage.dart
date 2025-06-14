import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? currentUser;
  List<String> starredSongs = [];
  List<Map<String, dynamic>> allSongs = [];
  bool isLoading = true;

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
        Hive.isBoxOpen('usersBox')
            ? Hive.box('usersBox')
            : await Hive.openBox('usersBox');
    final savedAvatar = prefs.getString('avatar_$username');

    setState(() {
      if (username != null && box.containsKey(username)) {
        currentUser = username;
        starredSongs = prefs.getStringList('starred_$username') ?? [];
        selectedAvatarPath = savedAvatar ?? avatarPaths[0];
      } else {
        currentUser = 'Guest';
        selectedAvatarPath = avatarPaths[0];
      }
      isLoading = false;
    });
  }

  Future<void> _loadSongs() async {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, selectedAvatarPath);
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset('../assets/bgg.png', fit: BoxFit.cover),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          20.0,
                          16.0,
                          40.0,
                        ),
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
                                        ? const Icon(
                                          Icons.account_circle,
                                          size: 60,
                                        )
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                currentUser ?? 'Guest',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Choose your Avatar:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children:
                                  avatarPaths.map((path) {
                                    bool isSelected =
                                        selectedAvatarPath == path;
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
                            const SizedBox(height: 30),
                            const Text(
                              'Starred Songs',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Divider(color: Colors.white),
                            starredSongs.isEmpty
                                ? const Center(
                                  child: Text(
                                    'No starred songs yet!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                                : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: starredSongs.length,
                                  itemBuilder: (context, index) {
                                    final songId = starredSongs[index];
                                    final song = allSongs.firstWhere(
                                      (s) => s['id'] == songId,
                                      orElse: () => {'title': 'Unknown Song'},
                                    );
                                    return ListTile(
                                      title: Text(
                                        song['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
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
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: _logout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    224,
                                    171,
                                    46,
                                  ),
                                ),
                                child: const Text('Logout'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
