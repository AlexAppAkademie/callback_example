import "package:flutter/material.dart";

class SongTile extends StatefulWidget {
  final String title;
  final Function(bool) onLikeChanged;

  SongTile({
    super.key,
    required this.title,
    required this.onLikeChanged,
  });

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  bool _liked = false;

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
    });
    widget.onLikeChanged(_liked);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: IconButton(
        icon: Icon(
          _liked ? Icons.favorite : Icons.favorite_border,
          color: null,
        ),
        onPressed: _toggleLike,
      ),
    );
  }
}
