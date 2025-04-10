import 'package:callback_example/song_like_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// nur ein Beispiel dafür, wie das SharedPrefsRepo aussehen könnte
class SharedPrefsLikeRepository implements SongLikeRepository {
  static const _prefix = 'liked_';

  @override
  Future<bool> isLiked(String title) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefix$title') ?? false;
  }

  @override
  Future<void> setLike(String title, bool liked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$title', liked);
  }

  @override
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  @override
  Future<List<String>> getLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getKeys()
        .where((k) => k.startsWith(_prefix) && prefs.getBool(k) == true)
        .map((k) => k.replaceFirst(_prefix, ''))
        .toList();
  }
}
