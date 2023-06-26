import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ex_stream/convert_to_stream/screen/create_data.dart';
import 'package:ex_stream/convert_to_stream/stream.dart';
import 'package:http/http.dart' as http;

import 'package:ex_stream/convert_to_stream/model/person.dart';

import 'package:flutter/material.dart';

class DispData extends StatefulWidget {
  const DispData({super.key});

  @override
  State<DispData> createState() => _DispDataState();
}

class _DispDataState extends State<DispData> {
  
  String baseUrl = 'http://6308255046372013f576f9b5.mockapi.io/person';
  var response;
  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  void fetchDataFromAPI() async {
    try {
      final response = await http
          .get(Uri.parse('http://6308255046372013f576f9b5.mockapi.io/person'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Person> person =
            jsonData.map((data) => Person.fromJson(data)).toList();
        streamPerson.add(person);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      streamPerson.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Display'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Person>>(
              stream: streamPerson.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error = ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return SizedBox(
                    height: 778,
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data?[index].id ?? ''),
                              Text(snapshot.data?[index].message ?? ''),
                              Text(snapshot.data?[index].firstName ?? ''),
                              Text(snapshot.data?[index].lastName ?? ''),
                              const Text(
                                  '===================================='),
                            ],
                          );
                        }),
                  );
                }
                throw Exception('Error Occured');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateData(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  }
