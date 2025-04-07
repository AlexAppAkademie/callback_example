import "package:flutter/material.dart";

class SongTile extends StatelessWidget {
  final String title;
  bool liked;
  // da der Wert von liked jetzt nicht mehr in SongTile verändert wird,
  // sondern in SongListScreen, und diese Änderung nur veranlasst werden muss,
  // müssen wir den Wert nicht mehr übergeben und brauchen somit keine Function mehr
  // wir können den Datentyp zu einem einfachen VoidCallback ändern
  final VoidCallback onLikeChanged;

  SongTile({
    super.key,
    required this.title,
    required this.liked,
    required this.onLikeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: Icon(
          liked ? Icons.favorite : Icons.favorite_border,
          color: liked ? Colors.red : null,
        ),
        onPressed: onLikeChanged,
      ),
    );
  }
}
