import "package:callback_example/like_provider.dart";
import "package:callback_example/song_list_screen.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() => runApp(
      // Registriert LikeProvider als globale State-Quelle für die gesamte App
      ChangeNotifierProvider(
        create: (_) => LikeProvider(),
        child: App(),
      ),
    );

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SongListScreen());
  }
}
