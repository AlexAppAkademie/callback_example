import "package:callback_example/like_provider.dart";
import "package:callback_example/song.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class SongTile extends StatelessWidget {
  final Song song;

  SongTile({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    // Consumer<LikeProvider> ist ein Widget, das auf Änderungen in LikeProvider hört.
    // Es baut sich neu auf, wenn notifyListeners() in LikeProvider aufgerufen wird.
    return Consumer<LikeProvider>(
      builder: (context, likeProvider, child) {
        // Da wir die Information, ob ein Song geliket ist, für unser Icon-Widget zwei Mal benötigen,
        // speichern wir das Ergebnis des Zugriffs darauf lieber in einer Variablen, anstatt 2x nachzuschauen
        final bool isLiked = likeProvider.isLiked(song.title);

        return ListTile(
          title: Text(song.title),
          trailing: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: () => likeProvider.toggleLike(song.title), // Like-Status umschalten
          ),
        );
      },
    );
  }
}
