import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String repoCacheKey = 'repo_cache';
  static const String imageCacheKey = 'image_cache';

  // API URLs
  static const String githubApiUrl = 'https://api.github.com/gists/public';
  static const String unsplashApiUrl =
      'https://api.unsplash.com/photos?client_id=YOUR_ACCESS_KEY';


  static Future<List<dynamic>> fetchRepoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if cached data exists
    String? cachedData = prefs.getString(repoCacheKey);
    if (cachedData != null) {
      print('Loading from cache');
      return json.decode(cachedData);
    } else {
      print('Fetching from API');
      return await fetchFromApi(
          githubApiUrl, repoCacheKey);
    }
  }


  static Future<List<dynamic>> fetchImageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    String? cachedData = prefs.getString(imageCacheKey);
    if (cachedData != null) {
      print('Loading images from cache');
      return json.decode(cachedData);
    } else {
      print('Fetching images from API');
      return await fetchFromApi(
          unsplashApiUrl, imageCacheKey);
    }
  }


  static Future<List<dynamic>> fetchFromApi(
      String apiUrl, String cacheKey) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(cacheKey, response.body);


      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  static Future<void> refreshCache() async {
    await fetchRepoData();
    await fetchImageData();
  }


  static Future<void> clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(repoCacheKey);
    prefs.remove(imageCacheKey);
  }
}
