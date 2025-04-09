import "package:callback_example/like_provider.dart";
import "package:callback_example/song.dart";
import "package:callback_example/song_tile.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final List<Song> songs = [
    Song("Dancehall Caballeros"),
    Song("Schüttel deinen Speck"),
    Song("Toxic"),
    Song("Hot in Herre"),
  ];

  @override
  Widget build(BuildContext context) {
    final likeProvider = Provider.of<LikeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Songs & Likes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Gesamt-Likes: ${likeProvider.totalLikes}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: likeProvider.resetLikes,
            child: Text("Alle Likes zurücksetzen"),
          ),
          Expanded(
            child: ListView(
              children: songs.map((song) {
                return SongTile(song: song);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
