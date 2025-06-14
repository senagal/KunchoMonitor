import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'drippyappbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUser;
  String? userAvatarPath;
  List<Map<String, dynamic>> songs = [];
  List<String> starredSongs = [];
  bool isLoading = true;

  // Vibrant and playful colors
  final Color backgroundOffWhite = Color.fromARGB(255, 237, 196, 170);
  final Color mutedOrange = Color.fromARGB(255, 240, 123, 84);
  final Color softBlueGray = Color.fromARGB(255, 6, 45, 68);
  final Color gentleGreen = Color(0xFF88B08D);
  final Color darkChocolateBrown = Color(0xFF4E342E);
  final Color warmGold = Color(0xFFC9A34F);

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    final username = await getCurrentUser();
    final starred = await getStarredSongs(username);
    final prefs = await SharedPreferences.getInstance();
    final avatar = prefs.getString('avatar_$username') ?? 'assets/wero.jpg';

    setState(() {
      currentUser = username;
      starredSongs = starred;
      userAvatarPath = avatar;
      isLoading = false;
    });
    _loadSongs();
  }

  Future<void> _loadSongs() async {
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
    setState(() {
      if (starredSongs.contains(songId)) {
        starredSongs.remove(songId);
      } else {
        starredSongs.add(songId);
      }
    });
    if (currentUser != null) {
      await saveStarredSongs(currentUser!, starredSongs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundOffWhite,
      appBar: DrippyAppBar(
        title: Text('Kuncho'),
        username: currentUser,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(
                  userAvatarPath ?? 'assets/wero.jpg',
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          40,
          12,
          12,
        ), // Increased top padding
        child: Column(
          children: [
            // Removed SizedBox(height: 12) since padding handles spacing
            Flexible(
              child: GridView.builder(
                itemCount: songs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isStarred = starredSongs.contains(song['id']);

                  final bgColor =
                      (index % 2 == 0)
                          ? mutedOrange
                          : softBlueGray; // Only 2 colors

                  return _HoverableSongCard(
                    song: song,
                    isStarred: isStarred,
                    bgColor: bgColor,
                    starColor: warmGold,
                    toggleStar: () => _toggleStar(song['id']),
                    onTap: () {
                      Navigator.pushNamed(context, '/music', arguments: song);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableSongCard extends StatefulWidget {
  final Map<String, dynamic> song;
  final bool isStarred;
  final Color bgColor;
  final Color starColor;
  final VoidCallback toggleStar;
  final VoidCallback onTap;

  const _HoverableSongCard({
    required this.song,
    required this.isStarred,
    required this.bgColor,
    required this.starColor,
    required this.toggleStar,
    required this.onTap,
  });

  @override
  State<_HoverableSongCard> createState() => _HoverableSongCardState();
}

class _HoverableSongCardState extends State<_HoverableSongCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isHovered ? 1.05 : 1.0,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.bgColor.withOpacity(isHovered ? 1.0 : 0.9),
                  widget.bgColor.withOpacity(isHovered ? 0.85 : 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: isHovered ? 12 : 8,
                  offset: Offset(3, 6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: isHovered ? 6 : 4,
                  offset: Offset(-3, -3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/${widget.song['image']}'),
                ),
                Text(
                  widget.song['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.song['artist'],
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.isStarred ? Icons.star : Icons.star_border,
                        color:
                            widget.isStarred ? widget.starColor : Colors.white,
                      ),
                      onPressed: widget.toggleStar,
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 6),
                    Text(
                      widget.song['duration'],
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
