import 'package:flutter/material.dart';
import 'full_imagescreen.dart';
import 'bookmark_manager.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bookmarkedImages = BookmarkManager.bookmarks;

    return Scaffold(
      appBar: AppBar(title: Text("Bookmarked Images")),
      body: bookmarkedImages.isEmpty
          ? Center(child: Text('No bookmarks available'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: bookmarkedImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageScreen(imageUrl: bookmarkedImages[index]),
              ),
            ),
            child: Image.network(bookmarkedImages[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

