import 'package:flutter/material.dart';

class MusicService with ChangeNotifier {
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void togglePlayback() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void play() {
    if (!_isPlaying) {
      _isPlaying = true;
      notifyListeners();
    }
  }

  void pause() {
    if (_isPlaying) {
      _isPlaying = false;
      notifyListeners();
    }
  }
}
