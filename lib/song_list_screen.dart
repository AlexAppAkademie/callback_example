import "package:callback_example/song.dart";
import "package:callback_example/song_tile.dart";
import "package:flutter/material.dart";

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

  void _toggleLike(int index) {
    setState(() {
      songs[index].liked = !songs[index].liked;
    });
  }

  void _resetLikes() {
    setState(() {
      for (Song song in songs) {
        song.liked = false;
      }
    });
  }

  // Erklärung:
  // Getter-Methode, die die Liste songs nach denen filtert,
  // die geliked wurden und daraus eine neue temporäre Liste erstellt,
  // nur um auf deren Länge (= die Anzahl geliketer Songs) zuzugreifen.
  // Getter haben den Vorteil, dass man sie wie eine normale Variable benutzen kann
  int get _totalLikes => songs.where((song) => song.liked).length;
  // Alternative:
  // int _totalLikes() {
  //   int totalLikes = 0;
  //   for (Song song in songs) {
  //     if (song.liked) totalLikes++;
  //   }
  //   return totalLikes;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Songs & Likes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Gesamt-Likes: $_totalLikes",
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: _resetLikes,
            child: Text("Alle Likes zurücksetzen"),
          ),
          Expanded(
            child: ListView(
              children: songs.map((song) {
                return SongTile(
                  title: song.title,
                  liked: song.liked,
                  onLikeChanged: () => _toggleLike(songs.indexOf(song)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
