import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Person {
  String? firstName;
  String? lastName;
  String? message;
  String? id;

  Person({this.firstName, this.lastName, this.message, this.id});

  Person.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['message'] = message;
    data['id'] = id;
    return data;
  }

  factory Person.fromPersonJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      message: json['message'],
    );
  }
}

class PostService {
  final String baseUrl = 'http://6308255046372013f576f9b5.mockapi.io/person';

  Stream<List<Person>> getPosts() async* {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Person> posts =
          data.map((person) => Person.fromJson(person)).toList();
      yield posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Stream<Person> createPost(Person post) async* {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    if (response.statusCode == 201) {
      final createdPost = Person.fromJson(json.decode(response.body));
      yield createdPost;
    } else {
      throw Exception('Failed to create post');
    }
  }

  Stream<Person> updatePost(Person post) async* {
    final url = Uri.parse('$baseUrl/${post.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    if (response.statusCode == 200) {
      final updatedPost = Person.fromJson(json.decode(response.body));
      yield updatedPost;
    } else {
      throw Exception('Failed to update post');
    }
  }

  Stream<void> deletePost(String id) async* {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      yield null; // Emit a value to signify successful deletion
    } else {
      throw Exception('Failed to delete post');
    }
  }
}

class PostsScreenWithStream extends StatefulWidget {
  const PostsScreenWithStream({super.key});

  @override
  _PostsScreenWithStreamState createState() => _PostsScreenWithStreamState();
}

class _PostsScreenWithStreamState extends State<PostsScreenWithStream> {
  final PostService postService = PostService();
  late Stream<List<Person>> postsStream;
  late StreamSubscription<List<Person>> postsSubscription;
  List<Person> posts = [];

  @override
  void initState() {
    super.initState();
    postsStream = postService.getPosts();
    postsSubscription = postsStream.listen((List<Person> newPosts) {
      setState(() {
        posts = newPosts;
      });
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $error')),
      );
    });
  }

  @override
  void dispose() {
    postsSubscription.cancel();
    super.dispose();
  }

  void createPost() {
    final post = Person(
      id: '0',
      firstName: 'My Data - 1',
      lastName: 'My Data - 1.1',
    );

    postService.createPost(post).listen((createdPost) {
      setState(() {
        posts.add(createdPost);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $error')),
      );
    });
  }

  void updatePost(Person post) {
    postService.updatePost(post).listen((updatedPost) {
      setState(() {
        final index = posts.indexWhere((p) => p.id == updatedPost.id);
        if (index >= 0) {
          posts[index] = updatedPost;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post: $error')),
      );
    });
  }

  void deletePost(String id) {
    postService.deletePost(id).listen((_) {
      setState(() {
        posts.removeWhere((post) => post.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.firstName ?? ''),
            subtitle: Text(post.lastName ?? ''),
            onTap: () {
              // Simulating an update when tapping on a post

              setState(() {
                final updatedPost = Person(
                  id: post.id,
                  firstName: 'My Updated Data - 1',
                  lastName: 'My Updated Data - 2',
                );

                updatePost(updatedPost);
              });
            },
            onLongPress: () {
              // Simulating a deletion when long-pressing a post
              deletePost(post.id!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
