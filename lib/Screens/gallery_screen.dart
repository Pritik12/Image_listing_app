import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bookmark_screen.dart';
import 'full_imagescreen.dart';
import 'bookmark_manager.dart';

class GalleryGridScreen extends StatelessWidget {
  Future<List<String>> fetchImageUrls() async {
    final response = await http.get(Uri.parse('https://api.unsplash.com/photos?client_id=klF3pZbdeGS0m0kzOPg1fqmGqLSZbtBO9WURYMXKyTE'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> imageUrls = [];
      for (var item in data) {
        if (item['urls'] != null && item['urls']['regular'] != null) {
          imageUrls.add(item['urls']['regular']);
        }
      }
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var imageUrls = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageScreen(imageUrl: imageUrls[index]),
                    ),
                  ),
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
                );
              },
            );
          }
        },
      ),
    );
  }
}
