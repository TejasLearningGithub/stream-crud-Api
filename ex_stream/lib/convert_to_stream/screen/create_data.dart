import 'dart:async';
import 'dart:developer';
import 'package:ex_stream/convert_to_stream/model/person.dart';
import 'package:ex_stream/convert_to_stream/screen/disp_data.dart';
import 'package:ex_stream/convert_to_stream/stream.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateData extends StatefulWidget {
  const CreateData({super.key});

  @override
  State<CreateData> createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> {
  var _formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var message = TextEditingController();
  var d = const DispData();
  String baseUrl = 'http://6308255046372013f576f9b5.mockapi.io/person';
  var response;
  var myResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Data'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter value';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: lastName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter value';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: message,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter value';
                  } else {
                    return null;
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    myResult = addData(
                      firstName: firstName.text,
                      lastName: lastName.text,
                      message: message.text,
                    );

                    // Provider.of<GetProvider>(context, listen: false).getData();
                  }

                  Navigator.pop(context, myResult);
                },
                child: Text(
                  'Create Data',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addData({
    required String firstName,
    required String lastName,
    required String message,
  }) async {
    try {
      response = await http.post(Uri.parse(baseUrl), body: {
        'first_name': firstName,
        'last_name': lastName,
        'message': message,
      });
      // streamPerson.add(response.body);
    } catch (e) {
      log('Error in posting data = ${e.toString()}');
    }
    return response;
  }
}
