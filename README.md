# Song-Like-App – von `setState()` zu `Provider`

## 🧭 Projektübersicht

Diese Beispiel-App zeigt Schritt für Schritt, wie man mit Flutter einen Like-Mechanismus für Songs umsetzt. Dabei wird die App in **drei Zuständen** aufgebaut, die verschiedene Ansätze zum **State Management** demonstrieren:

- **Zustand 1:** Lokaler State mit `setState()`
- **Zustand 2:** „Lifting State Up“ zur Eltern-Komponente
- **Zustand 3:** Globaler State mit `Provider`

Ziel ist es, ein Verständnis für verschiedene State-Management-Konzepte und deren Stärken und Schwächen zu entwickeln.

---

## 🧩 Zustand 1: Lokaler State mit `setState()`

Jedes `SongTile`-Widget speichert für sich selbst, ob es geliked ist. Die Eltern-Komponente zählt die Likes über einen Callback hoch oder runter.

### 📌 Codeauszug aus `SongTile`:
```dart
class SongTile extends StatefulWidget {
  final String title;
  final Function(bool) onLikeChanged;

  ...
}

class _SongTileState extends State<SongTile> {
  bool _liked = false;

  void _toggleLike() {
    setState(() => _liked = !_liked);
    widget.onLikeChanged(_liked); // ❌ Callback nach oben
  }
}
```

### 🎯 Lernziele:
- Funktionsweise von `setState()` verstehen
- Verwendung von **Callbacks**, um vom Kind nach oben zu kommunizieren
- Grenzen erkennen: Kein globaler Überblick, kein Reset möglich

---

## 🪜 Zustand 2: Lifting State Up zur Eltern-Komponente

Der Liked-Status wird **zentral** in `SongListScreen` gehalten. `SongTile` wird stateless und bekommt den Status sowie die Umschaltfunktion als Props.

### 📌 Codeauszug:
```dart
class Song {
  String title;
  bool liked;
  Song(this.title, {this.liked = false});
}

class _SongListScreenState extends State<SongListScreen> {
  List<Song> songs = [...];

  void _toggleLike(int index) {
    setState(() => songs[index].liked = !songs[index].liked);
  }

  void _resetLikes() {
    setState(() => songs.forEach((s) => s.liked = false));
  }
}
```

### 🎯 Lernziele:
- **Lifting State Up**: Zustände dort verwalten, wo sie gemeinsam gebraucht werden
- Zentrale Kontrolle über alle Likes ermöglicht „Unlike all“
- Nachteil: Zustand bleibt auf diese Komponente beschränkt

---

## 🚀 Zustand 3: Globaler State mit `Provider`

Der Zustand wird nun über `Provider` **global** verwaltet. Die `LikeProvider`-Klasse ist für die gesamte App verfügbar und speichert die Like-Zustände aller Songs.

### 📌 Wichtige Konzepte:
- `ChangeNotifier` zur Beobachtbarkeit
- `Provider` zur Zustandsverteilung
- `Consumer` zur gezielten Aktualisierung einzelner Widgets

### 📌 Codeauszug aus `like_provider.dart`:
```dart
class LikeProvider extends ChangeNotifier {
  final Map<String, bool> _likes = {};

  bool isLiked(String title) => _likes[title] ?? false;

  void toggleLike(String title) {
    _likes[title] = !isLiked(title);
    notifyListeners();
  }

  void resetLikes() {
    _likes.clear();
    notifyListeners();
  }

  int get totalLikes => _likes.values.where((liked) => liked).length;
}
```

### 📌 Integration in `main.dart`:
```dart
void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => LikeProvider(),
    child: App(),
  ),
);
```

### 📌 Verwendung in der UI:
```dart
// song_list_screen.dart
final likeProvider = Provider.of<LikeProvider>(context);
Text("Gesamt-Likes: ${likeProvider.totalLikes}");
ElevatedButton(onPressed: likeProvider.resetLikes, ...);

// song_tile.dart
Consumer<LikeProvider>(
  builder: (context, likeProvider, child) {
    final isLiked = likeProvider.isLiked(song.title);
    return IconButton(
      icon: Icon(...),
      onPressed: () => likeProvider.toggleLike(song.title),
    );
  },
);
```

### 🎯 Lernziele:
- Einstieg in **reaktives, globales State Management** mit `Provider`
- **Entkopplung** von UI und Logik
- Verbesserte Testbarkeit und Wiederverwendbarkeit

---

## 📊 Vergleich der drei Zustände

| Zustand                        | Verwaltung          | Reset-Funktion       | Wiederverwendbarkeit | Testbarkeit |
|-------------------------------|---------------------|----------------------|----------------------|-------------|
| 1. Lokal mit `setState()`     | im Kind-Widget      | nicht möglich        | niedrig              | schlecht    |
| 2. Lifting State Up           | in Eltern-Komponente| möglich              | mittel               | okay        |
| 3. Provider                   | global & entkoppelt | elegant möglich      | hoch                 | gut         |

---

## 💡 Weiterführende Ideen

- Speicherung der Likes mit `SharedPreferences` oder `Firebase`
- Benutzerverwaltung oder dynamisches Laden von Songs
- Animationen bei Like/Unlike
- Performance-Optimierung mit `Selector` oder `context.select`

---

## ✅ Fazit

Diese Übung zeigt die Entwicklung vom einfachen lokalen State bis hin zum flexiblen, globalen State Management mit `Provider`.

Studierende lernen dabei:

- Wie Flutter mit `setState()` arbeitet
- Wann und wie man **State hochtreibt** (*Lifting State Up*)
- Warum **Callbacks** nützlich, aber unpraktisch bei wachsender Komplexität sind
- Wie man mit `Provider` **sauberes, reaktives und wartbares** State Management aufbaut