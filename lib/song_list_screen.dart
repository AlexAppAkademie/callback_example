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
    // Hier holen wir uns die Instanz von LikeProvider, die wir in main.dart erstellt haben.
    // Provider.of<LikeProvider>(context) sucht im Widget-Baum nach einem LikeProvider und gibt es zurück.
    // Dies ermöglicht es uns, auf die Methoden von LikeProvider zuzugreifen.
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
            onPressed: likeProvider.resetLikes, // ruft die Reset-Methode im Provider auf
            child: Text("Alle Likes zurücksetzen"),
          ),
          Expanded(
            child: ListView(
              // Jede SongTile bekommt nur das Song-Objekt (kein State/Callback nötig)
              children: songs.map((song) => SongTile(song: song)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
