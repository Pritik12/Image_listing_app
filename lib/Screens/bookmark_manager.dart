class BookmarkManager {
  static final List<String> _bookmarkedImages = [];

  static List<String> get bookmarks => _bookmarkedImages;

  static void addBookmark(String imageUrl) {
    if (!_bookmarkedImages.contains(imageUrl)) {
      _bookmarkedImages.add(imageUrl);
    }
  }

  static void removeBookmark(String imageUrl) {
    _bookmarkedImages.remove(imageUrl);
  }
}
