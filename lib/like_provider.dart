import 'package:flutter/material.dart';

// LikeProvider verwaltet alle Like-Zustände global und erbt von ChangeNotifier, um Änderungen signalisieren zu können.
class LikeProvider extends ChangeNotifier {
  final Map<String, bool> _likes = {}; // Map speichert Like-Status pro Song-Titel

  // Gibt zurück, ob ein Song geliked ist - falls der Like-Status des Songs noch nicht per Klick auf das Herz-Icon verändert wurde,
  // existiert dazu noch kein Eintrag in der Map _likes, weshalb null returned werden würde. Um das zu verhindern und gleichzeitig
  // einen Standardwert (false) festzulegen, wird der "if-null" Operator ?? verwendet
  bool isLiked(String title) => _likes[title] ?? false;

  void toggleLike(String title) {
    // _likes[title] = !_likes[title] würde hier nicht funktionieren, wenn der Song zum ersten Mal geliket wird,
    // weil dann noch kein Eintrag dazu in der Map existiert (= null), deshalb nutzen wir die Funktion isLiked, die diesen Fall abfängt
    _likes[title] = !isLiked(title);
    notifyListeners(); // Benachrichtigt alle Listener (in dem Fall das Consumer-Widget SongTile), dass sich der Status geändert hat
  }

  void resetLikes() {
    // zum "Entliken" aller Songs löschen wir einfach jegliche "Erinnerung" an sie
    // - ein Song, zu dem kein Eintrag in der Map existiert, ist standardmäßig ja nicht geliket (isLiked liefert false)
    _likes.clear();
    notifyListeners();
  }

  // Gibt die Gesamtzahl der gelikten Songs zurück
  // 1. mit _likes.values können wir uns alle Werte in der Map anschauen
  // 2. mit .where() können wir die Werte nach einer Bedingung filtern
  // 3. .where((isLiked) => isLiked) holt uns nur die Werte, bei denen isLiked == true ist (== true können wir aber weglassen)
  // 4. mit .length holen wir uns die Länge dieser "Liste", also die Anzahl der gelikten Songs
  int get totalLikes => _likes.values.where((isLiked) => isLiked).length;
}
