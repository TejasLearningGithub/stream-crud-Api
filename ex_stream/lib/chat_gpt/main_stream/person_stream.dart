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

class PersonService {
  final String baseUrl = 'http://6308255046372013f576f9b5.mockapi.io/person';

  Stream<List<Person>> getPerson() async* {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Person> myPerson =
          data.map((person) => Person.fromJson(person)).toList();
      yield myPerson;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Stream<Person> createPerson(Person person) async* {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(person.toJson()),
    );
    if (response.statusCode == 201) {
      final createdPerson = Person.fromJson(json.decode(response.body));
      yield createdPerson;
    } else {
      throw Exception('Failed to create post');
    }
  }

  Stream<Person> updatePerson(Person person) async* {
    final url = Uri.parse('$baseUrl/${person.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(person.toJson()),
    );
    if (response.statusCode == 200) {
      final updatedPerson = Person.fromJson(json.decode(response.body));
      yield updatedPerson;
    } else {
      throw Exception('Failed to update post');
    }
  }

  deletePerson(String id) async {
    final url =
        Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return true;
      // throw Exception('Failed to delete post');
    } else {
      return false;
    }
  }
}

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PersonService personService = PersonService();
  late Stream<List<Person>> personStream;
  late StreamSubscription<List<Person>> personSubscription;
  List<Person> persons = [];

  @override
  void initState() {
    super.initState();
    personStream = personService.getPerson();
    personSubscription = personStream.listen((List<Person> newPosts) {
      setState(() {
        persons = newPosts;
      });
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $error')),
      );
    });
  }

  @override
  void dispose() {
    personSubscription.cancel();
    super.dispose();
  }

  void createPost() {
    final person = Person(
      id: '0',
      firstName: 'New Post Title',
      lastName: 'New Post Body',
    );

    personService.createPerson(person).listen((createdPost) {
      setState(() {
        persons.add(createdPost);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully')),
      );
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $error')),
      );
    });
  }

  void updatePerson(Person person) {
    final updatedPerson = Person(
      id: person.id,
      firstName: 'First New Post Title - updated',
      lastName: ' First New Post Body - updated',
    );
    personService.updatePerson(updatedPerson).listen((updatedPerson) {
      setState(() {
        final index = persons.indexWhere((p) => p.id == updatedPerson.id);
        if (index >= 0) {
          persons[index] = updatedPerson;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated successfully')),
      );
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post: $error')),
      );
    });
  }

  void deletePerson(String id, index) {
    personService.deletePerson(persons[index!].id.toString()).listen((_) {
      setState(() {
        persons.removeWhere((post) => post.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
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
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            title: Text(person.firstName ?? ''),
            subtitle: Text(person.lastName ?? ''),
            onTap: () {
              // Simulating an update when tapping on a post
              final updatedPerson = Person(
                id: person.id,
                firstName: person.firstName,
                lastName: person.lastName,
              );
              updatePerson(updatedPerson);
            },
            onLongPress: () {
              // Simulating a deletion when long-pressing a post
              deletePerson(persons[index].id.toString(), index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createPost,
        child: Icon(Icons.add),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PostsScreen(),
//   ));
// }
