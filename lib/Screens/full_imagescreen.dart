import 'package:flutter/material.dart';
import 'package:image_listing_app/Screens/bookmark_manager.dart';

class FullScreenImageScreen extends StatefulWidget {
  final String imageUrl;

  FullScreenImageScreen({required this.imageUrl});

  @override
  _FullScreenImageScreenState createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  bool isBookmarked = false;
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    if (isBookmarked) {
      BookmarkManager.addBookmark(widget.imageUrl);
    } else {
      BookmarkManager.removeBookmark(widget.imageUrl);
    }
  }

  void handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(2.0);
    }
  }

  void showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: handleDoubleTap,
              onLongPress: () => showImagePopup(context),
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: toggleBookmark,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
