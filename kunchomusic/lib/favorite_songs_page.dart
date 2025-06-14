import 'package:flutter/material.dart';

class FavoriteSongsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final List<Map<String, dynamic>> songs = List<Map<String, dynamic>>.from(
      args['songs'] ?? [],
    );
    final List<String> starred = List<String>.from(args['starred'] ?? []);

    final favoriteSongs =
        songs.where((song) => starred.contains(song['id'])).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6DA), // light beige background
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6B3E1A), // dark brown
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: const Color(0xFFEAD2BC), // soft tan card color
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/${song['image']}'),
                backgroundColor: Colors.white,
              ),
              title: Text(
                song['title'],
                style: const TextStyle(
                  color: Color(0xFF6B3E1A), // match AppBar color
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                song['artist'],
                style: const TextStyle(color: Color(0xFF4B2E15)),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/music', arguments: song);
              },
              trailing: const Icon(
                Icons.chevron_right,
                color: Color(0xFF6B3E1A),
              ),
            ),
          );
        },
      ),
    );
  }
}
