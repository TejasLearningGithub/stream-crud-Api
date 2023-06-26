import 'dart:async';
import 'dart:convert';

import 'package:ex_stream/model/posts_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final StreamController<List<Post>> _apiDataStreamController =
      StreamController<List<Post>>.broadcast();

  //Stream<List<Post>> get apiDataStream => _apiDataStreamController.stream;



  
  @override
  void dispose() {
    _apiDataStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  void fetchDataFromAPI() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Post> posts =
            jsonData.map((data) => Post.fromJson(data)).toList();
        _apiDataStreamController.add(posts);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      _apiDataStreamController.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Stream Demo'),
      ),
      body: Center(
        child: StreamBuilder<List<Post>>(
          stream: _apiDataStreamController.stream,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final List<Post> posts = snapshot.data!;
            // Display the data in your UI
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final Post post = posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${post.id}'),
                        Text(post.body),
                      ],
                    ),
                  );
                },
              );
            }
            throw Exception('Error Occured');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchDataFromAPI();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
