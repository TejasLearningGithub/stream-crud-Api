import 'dart:convert';
import 'package:ex_stream/chat_gpt/post_model.dart';
import 'package:http/http.dart' as http;

class PostService {
  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      body: jsonEncode({
        'title': post.title,
        'body': post.body,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final dynamic data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<Post> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/${post.id}'),
      body: jsonEncode({
        'title': post.title,
        'body': post.body,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int postId) async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
