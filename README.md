# Song-Like-App als Beispiel für State Management mit setState und Callbacks

## Übersicht

Dieses Beispiel demonstriert, wie man mit Flutter den State in einer einfachen "Song-Like-App" verwaltet. Zu Beginn werden die Like-Buttons für jeden Song lokal im Widget gespeichert. Im zweiten Schritt wird der State von den `SongTile`-Widgets in die Eltern-Komponente `SongListScreen` hochgehoben. Zudem wird ein Reset-Feature hinzugefügt, um alle Songs auf einmal zu entliken.

## Zustand 1: Vor dem Reset-Feature

In diesem ersten Zustand speichern die einzelnen `SongTile`-Widgets ihren eigenen Like-Status lokal. Wenn ein Benutzer auf das Herz-Icon klickt, wird der Like-Status nur für dieses einzelne Widget geändert. Die Gesamtzahl der Likes wird oben auf der Seite angezeigt, aber das Zurücksetzen aller Likes auf einmal ist nicht möglich.

### Codebeispiel:

```dart
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
```

### Lernziele in diesem Zustand:
- **State Management mit `setState()`**: Wiederholen, wie lokale Zustände innerhalb von Stateful Widgets verwaltet werden.
- **Callback-Mechanismus**: Lernen, wie eine Eltern-Komponente durch einen Callback den Zustand von Kind-Komponenten überwachen und anpassen kann.

## Zustand 2: Nach dem Reset-Feature (Lifting State Up)

In diesem erweiterten Zustand wird der Like-Status nicht mehr lokal in den `SongTile`-Widgets gespeichert, sondern in der Eltern-Komponente `SongListScreen`. Dies ermöglicht die zentrale Verwaltung des Zustands für alle Songs und fügt eine neue Funktion hinzu, um alle Songs gleichzeitig zu entliken.

### Codebeispiel:

```dart
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
      for (var song in songs) {
        song.liked = false;
      }
    });
  }

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
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongTile(
                  title: song.title,
                  liked: song.liked,
                  onLikeChanged: () => _toggleLike(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Lernziele nach dem Reset-Feature:
- **Lifting State Up**: Lernen, wie man den State von untergeordneten Widgets in eine Eltern-Komponente hochhebt, um den Zustand zentral zu verwalten.
- **Erweiterte Callback-Nutzung**: Der Callback wird nur noch verwendet, um die Aktion „Like/Unlike“ vom Kind zur Eltern-Komponente zu melden, wodurch das Kind-Widget stateless wird.

## Fazit

In diesem Beispiel wurde das einfache Prinzip von `setState()` zur Verwaltung von lokalem Zustand eingeführt und dann durch das Konzept des "Lifting State Up" erweitert. Dieses Vorgehen ermöglicht es, den Zustand zentral zu steuern und komplexere Features wie das Zurücksetzen aller Likes zu implementieren. Dieses Beispiel stellt eine Grundlage für die Diskussion über fortgeschrittene State-Management-Techniken, wie z. B. den Einsatz von `Provider` oder `Riverpod`, dar.
