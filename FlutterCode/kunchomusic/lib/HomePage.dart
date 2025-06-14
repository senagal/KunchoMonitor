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

  final Color backgroundOffWhite = Color(0xFFFDEBD0);
  final Color yellow = Color(0xFFFFF176); // Bright Yellow
  final Color peach = Color(0xFFFFCCBC); // Soft Peach
  final Color warmGold = Color(0xFFFFC107); // Star color
  final Color darkBrown = Color(0xFF4E342E); // AppBar color
  final Color backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _initializePage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addScopedWillPopCallback(() async {
        _initializePage();
        return true;
      });
    });
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
        avatarPath: userAvatarPath,
        backgroundColor: darkBrown,
        onLogout: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('currentUser'); // Clear saved user
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/auth',
            (route) => false,
          ); // Navigate back to login page
        },
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: Colors.white),
            tooltip: 'Favorites',
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  '/favorites',
                  arguments: {'songs': songs, 'starred': starredSongs},
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            final isStarred = starredSongs.contains(song['id']);
            final bgColor = index % 2 == 0 ? yellow : peach;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _HoverableSongCard(
                song: song,
                isStarred: isStarred,
                bgColor: bgColor,
                starColor: warmGold,
                toggleStar: () => _toggleStar(song['id']),
                onTap: () {
                  Navigator.pushNamed(context, '/music', arguments: song);
                },
              ),
            );
          },
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
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.bgColor.withOpacity(isHovered ? 1.0 : 0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: isHovered ? 12 : 6,
                offset: Offset(3, 6),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: isHovered ? 6 : 4,
                offset: Offset(-3, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/${widget.song['image']}'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.brown[900],
                      ),
                    ),
                    Text(
                      widget.song['artist'],
                      style: TextStyle(fontSize: 12, color: Colors.brown[700]),
                    ),
                    Text(
                      widget.song['duration'],
                      style: TextStyle(fontSize: 12, color: Colors.brown[500]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.isStarred ? Icons.star : Icons.star_border,
                  color: widget.isStarred ? widget.starColor : Colors.brown,
                ),
                onPressed: widget.toggleStar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
