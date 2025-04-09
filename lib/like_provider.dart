import 'package:flutter/material.dart';

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

  int get totalLikes => _likes.values.where((isLiked) => isLiked).length;
}
