import "package:callback_example/like_provider.dart";
import "package:callback_example/shared_prefs_like_repo.dart";
import "package:callback_example/song_list_screen.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() {
  final repo = SharedPrefsLikeRepository();
  runApp(
    // Registriert LikeProvider als globale State-Quelle für die gesamte App
    ChangeNotifierProvider(
      create: (context) {
        final LikeProvider likeProvider = LikeProvider(repo);
        //    Der Aufruf hier ist "fire-and-forget" (wir warten nicht mit `await` darauf),
        //    weil `create` synchron sein muss. Der Provider selbst kümmert sich
        //    intern darum, seinen Ladezustand (`loading`) zu verwalten und die
        //    UI via `notifyListeners()` zu informieren.
        likeProvider.initialize();
        return likeProvider; // Die erstellte (aber noch ladende) Provider-Instanz zurückgeben.
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SongListScreen());
  }
}
