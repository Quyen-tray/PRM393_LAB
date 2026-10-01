import 'package:flutter/foundation.dart';

/// Quản lý danh sách phim yêu thích bằng ChangeNotifier.
/// Cả Home và Detail cùng lắng nghe, nên khi bấm tim ở Detail,
/// icon tim ở Home cũng tự cập nhật.
class FavoritesModel extends ChangeNotifier {
  final Set<int> _ids = {};

  bool isFavorite(int movieId) => _ids.contains(movieId);

  void toggle(int movieId) {
    if (!_ids.remove(movieId)) {
      _ids.add(movieId);
    }
    notifyListeners(); // báo cho các widget đang lắng nghe build lại
  }
}

/// Instance dùng chung toàn app (đơn giản, không cần package provider).
final FavoritesModel favorites = FavoritesModel();