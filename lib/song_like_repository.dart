// nur ein Beispiel dafür, wie das Abstract DB Repo aussehen könnte
abstract class SongLikeRepository {
  Future<bool> isLiked(String title);
  Future<void> setLike(String title, bool liked);
  Future<void> resetAll();
  Future<List<String>> getLikedSongs();
}
