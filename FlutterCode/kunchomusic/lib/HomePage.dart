import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';

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
  final Color vibrantBrown = Color.fromARGB(255, 104, 41, 7);
  final Color vibrantBlue = Color(0xFF6EC6FF);
  final Color vibrantYellow = Color(0xFFFFF176);
  final Color vibrantGreen = Color(0xFF81C784);
  final Color offWhite = Color(0xFFFFFBF2);
  final Color darkBrown = Color(0xFF4E342E);

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
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: vibrantBrown,
        title: Text(
          'Kids Music Player',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  userAvatarPath ?? 'assets/wero.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              currentUser != null ? '🎵 Hello, $currentUser!' : 'Loading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            SizedBox(height: 12),
            // Limit the height of the grid to avoid overflow
            // Replace ConstrainedBox with Flexible for better dynamic sizing
            Flexible(
              child: GridView.builder(
                itemCount: songs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2, // wider than tall, cards less tall
                ),
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isStarred = starredSongs.contains(song['id']);
                  final bgColor = index % 2 == 0 ? vibrantBlue : vibrantGreen;

                  return _HoverableSongCard(
                    song: song,
                    isStarred: isStarred,
                    bgColor: bgColor,
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
  final VoidCallback toggleStar;
  final VoidCallback onTap;

  const _HoverableSongCard({
    required this.song,
    required this.isStarred,
    required this.bgColor,
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
          scale: isHovered ? 1.05 : 1.0, // Scale up a bit on hover
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
                  radius: 25, // slightly smaller circle
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
                        color: widget.isStarred ? Colors.yellow : Colors.white,
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
