import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepoListScreen extends StatefulWidget {
  @override
  _RepoListScreenState createState() => _RepoListScreenState();
}

class _RepoListScreenState extends State<RepoListScreen> {
  List _repos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRepoData();
  }

  Future<void> fetchRepoData() async {
    final response = await http.get(Uri.parse('https://api.github.com/gists/public'));

    if (response.statusCode == 200) {
      setState(() {
        _repos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load repos');
    }
  }

  void _showOwnerDetails(BuildContext context, var repo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Owner Details'),
          content: Text('Owner: ${repo['owner']['login']}\nProfile: ${repo['owner']['html_url']}'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repo List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _repos.length,
        itemBuilder: (context, index) {
          var repo = _repos[index];

          // Null safety checks for fields
          String description = repo['description'] ?? 'No Description';
          String createdAt = repo['created_at'] ?? 'N/A';
          String updatedAt = repo['updated_at'] ?? 'N/A';
          int comments = repo['comments'] ?? 0;

          return GestureDetector(
            onLongPress: () => _showOwnerDetails(context, repo),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilesListScreen(files: ['File1.txt', 'File2.txt', 'File3.txt']), // Dummy data for now
                ),
              );
            },
            child: ListTile(
              title: Text(description),
              subtitle: Text('Created: $createdAt, Updated: $updatedAt'),
              trailing: Text('Comments: $comments'),
            ),
          );
        },
      ),
    );
  }
}

class FilesListScreen extends StatelessWidget {
  final List<String> files;

  FilesListScreen({required this.files});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files List'),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(files[index]),
          );
        },
      ),
    );
  }
}
