import 'dart:async';
import 'dart:convert';

import 'package:ex_stream/convert_to_stream/model/person.dart';
import 'package:http/http.dart' as http;

class Repository {
  String _baseUrl = 'http://6308255046372013f576f9b5.mockapi.io/person';
  var response;
  var responsse;

  final StreamController<List<Person>> _apiStreamController =
      StreamController<List<Person>>.broadcast();

  getData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        print(response.body);
        Iterable it = jsonDecode(response.body);
        List<Person> person = it.map((e) => Person.fromJson(e)).toList();
        _apiStreamController.add(person);
        return person;
      }
    } catch (e) {
      print('Error in display Data = ' + e.toString());
    }
  }

  // Future<Person?> createData(
  //     String firstName, String lastName, String message) async {
  //   try {
  //     final response = await http.post(Uri.parse(_baseUrl), body: {
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'message': message
  //     });

  //     // if (response.statusCode == 201) {
  //     //   return true;
  //     // } else {
  //     //   return false;
  //     // }
  //   } catch (e) {
  //     print('Error i creation = ' + e.toString());
  //   }
  //   return response;
  // }

  // Future<Person?> updateData(
  //     String id, String firstName, String lastName, String message) async {
  //   try {
  //     final responsse = await http.put(
  //       Uri.parse('${_baseUrl}/${id}'),
  //       body: {
  //         'first_name': firstName,
  //         'last_name': lastName,
  //         'message': message
  //       },
  //     );

  //     // if (responsse.statusCode == 200) {
  //     //   return true;
  //     // } else {
  //     //   return false;
  //     // }
  //   } catch (e) {
  //     print('Error In Updating' + e.toString());
  //   }
  //   return responsse;
  // }

  // Future deleteData(String id) async {
  //   try {
  //     final response = await http.delete(Uri.parse('${_baseUrl}/${id}'));
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error in deletion = $e');
  //   }
  // }
}
