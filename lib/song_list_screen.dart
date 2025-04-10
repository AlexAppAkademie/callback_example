import "package:callback_example/like_provider.dart";
import "package:callback_example/song_tile.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Songs & Likes")),
      // wir nutzen Consumer, um bei Änderungen nur den body statt das ganze Scaffold inkl. AppBar neuzuladen
      body: Consumer<LikeProvider>(
        builder: (context, likeProvider, child) {
          return likeProvider.loading
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                        children: likeProvider.songs.map((song) => SongTile(song: song)).toList(),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
