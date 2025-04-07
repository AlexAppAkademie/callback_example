import "package:callback_example/song_tile.dart";
import "package:flutter/material.dart";

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  int _totalLikes = 0;

  void _handleLike(bool liked) {
    setState(() {
      liked ? _totalLikes++ : _totalLikes--;
    });
  }

  final List<String> songs = [
    "Dancehall Caballeros",
    "Schüttel deinen Speck",
    "Toxic",
    "Hot in Herre",
  ];

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
          Expanded(
            child: ListView(
              children: songs.map((title) {
                return SongTile(
                  title: title,
                  // Callback-Function:
                  // eine Funktion, die als Parameter an ein anderes Widget übergeben wird
                  // Die Eltern-Komponente (SongListScreen) gibt die Funktion _handleLike an die SongTiles weiter
                  // Wenn in SongTile auf das Herz geklickt wird, ruft sie widget.onLikeChanged(_liked) auf
                  // Dadurch wird der Eltern-Komponente signalisiert: "Ich wurde geliked oder entliked"
                  // Das ist wichtig, damit Kind-Widgets ihre Aktionen „nach oben“ melden können
                  onLikeChanged: _handleLike,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
