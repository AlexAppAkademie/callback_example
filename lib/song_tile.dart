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
    return Consumer<LikeProvider>(
      builder: (context, likeProvider, child) {
        final bool isLiked = likeProvider.isLiked(song.title);

        return ListTile(
          title: Text(song.title),
          trailing: IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: () => likeProvider.toggleLike(song.title),
          ),
        );
      },
    );
  }
}
