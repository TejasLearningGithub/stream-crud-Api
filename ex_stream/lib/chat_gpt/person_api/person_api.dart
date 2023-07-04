import 'dart:convert';
import 'dart:developer';

import 'package:ex_stream/chat_gpt/person_api/person_modal.dart';
import 'package:ex_stream/chat_gpt/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonService {
  // var response;

  Future<List<Person>> getPersons() async {
    final response = await http
        .get(Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Persons');
    }
  }

  Future createPerson(Person person, {BuildContext? context}) async {
    try {
      final response = await http.post(
        Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person'),
        // body: jsonEncode({
        //   'title': Person.firstName,
        //   'body': Person.lastName,
        // }),
        body: {
          'first_name': person.firstName,
          'last_name': person.lastName,
          'message': person.message,
          'id': person.id
        },
        // headers: {'Content-Type': 'application/json'},
      );
      // if (response.statusCode == 201) {
      //   final dynamic data = jsonDecode(response.body);
      //   return Person.fromJson(data);
      // } else {
      //   throw Exception('Failed to create Person');
      // }
      // Navigator.push(
      //     context!,
      //     MaterialPageRoute(
      //       builder: (context) => PostWidget(
      //         myPerson: Person(
      //           firstName: 'first_name',
      //           lastName: 'last_name',
      //           message: 'message',
      //           id: 'id',
      //         ),
      //       ),
      //     ));
      return response;
    } catch (e) {
      log('Error In Create Data = $e');
    }
  }
  // Future<Person> updatePerson(Person Person) async {
  //   final response = await http.put(
  //     Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person'),
  //     body: jsonEncode({
  //       'title': Person.firstName,
  //       'body': Person.lastName,
  //     }),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //   if (response.statusCode == 200) {
  //     final dynamic data = jsonDecode(response.body);
  //     return Person.fromPersonJson(data);
  //   } else {
  //     throw Exception('Failed to update Person');
  //   }
  // }

  deletePerson(String personId) async {
    try {
      final response = await http.delete(
          Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person/$personId'));
      if (response.statusCode != 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(
        'Error In Delete = ${e.toString()}',
      );
    }
  }
}
