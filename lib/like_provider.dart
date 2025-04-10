import 'package:callback_example/song.dart';
import 'package:callback_example/song_like_repository.dart';
import 'package:flutter/material.dart';

// LikeProvider verwaltet alle Like-Zustände global und erbt von ChangeNotifier, um Änderungen signalisieren zu können.
class LikeProvider extends ChangeNotifier {
  SongLikeRepository repo; // Referenz auf das Repo
  bool loading = true; // um in der UI direkt einen CircularProgressIndicator anzuzeigen

  // Songs befinden sich jetzt nicht mehr in der UI, noch besser wäre es, sie wären ganz ausgelagert
  final List<Song> songs = [
    Song("Dancehall Caballeros"),
    Song("Schüttel deinen Speck"),
    Song("Toxic"),
    Song("Hot in Herre"),
  ];

  final Map<String, bool> _likes = {}; // Map speichert Like-Status pro Song-Titel

  // Konstruktor, der das Repo initialisiert
  LikeProvider(this.repo);

  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 2)); // künstliche Verzögerung, wäre sonst zu schnell
    await loadLikes();
    loading = false; // CircularProgressIndicator nicht mehr anzeigen
    notifyListeners();
  }

  Future<void> loadLikes() async {
    // für jeden Titel den Like-Status aus dem Repo holen
    for (Song song in songs) {
      _likes[song.title] = await repo.isLiked(song.title);
    }
  }

  // Gibt zurück, ob ein Song geliked ist - falls der Like-Status des Songs noch nicht per Klick auf das Herz-Icon verändert wurde,
  // existiert dazu noch kein Eintrag in der Map _likes, weshalb null returned werden würde. Um das zu verhindern und gleichzeitig
  // einen Standardwert (false) festzulegen, wird der "if-null" Operator ?? verwendet
  bool isLiked(String title) => _likes[title] ?? false;

  Future<void> toggleLike(String title) async {
    // _likes[title] = !_likes[title] würde hier nicht funktionieren, wenn der Song zum ersten Mal geliket wird,
    // weil dann noch kein Eintrag dazu in der Map existiert (= null), deshalb nutzen wir die Funktion isLiked, die diesen Fall abfängt
    final bool newValue = !isLiked(title);

    _likes[title] = newValue;
    await repo.setLike(title, newValue);
    notifyListeners(); // Benachrichtigt alle Listener (in dem Fall das Consumer-Widget SongTile), dass sich der Status geändert hat
  }

  Future<void> resetLikes() async {
    // zum "Entliken" aller Songs löschen wir einfach jegliche "Erinnerung" an sie
    // - ein Song, zu dem kein Eintrag in der Map existiert, ist standardmäßig ja nicht geliket (isLiked liefert false)
    _likes.clear();
    await repo.resetAll();
    notifyListeners();
  }

  // Gibt die Gesamtzahl der gelikten Songs zurück
  // 1. mit _likes.values können wir uns alle Werte in der Map anschauen
  // 2. mit .where() können wir die Werte nach einer Bedingung filtern
  // 3. .where((isLiked) => isLiked) holt uns nur die Werte, bei denen isLiked == true ist (== true können wir aber weglassen)
  // 4. mit .length holen wir uns die Länge dieser "Liste", also die Anzahl der gelikten Songs
  int get totalLikes => _likes.values.where((isLiked) => isLiked).length;
}
