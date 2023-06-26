import 'package:ex_stream/chat_gpt/person_api/person_api.dart';
import 'package:ex_stream/chat_gpt/person_api/person_modal.dart';

import 'package:flutter/material.dart';

class PostWidget extends StatefulWidget {
  Person? myPerson = Person();

  PostWidget({
    super.key,
    this.myPerson,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PersonService personService = PersonService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: StreamBuilder<List<Person>>(
        stream: Stream.fromFuture(personService.getPersons()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Person> person = snapshot.data!;
            return ListView.builder(
              itemCount: person.length,
              itemBuilder: (context, index) {
                final personData = person[index];
                return ListTile(
                  title: Text(
                    personData.firstName ?? 'Error',
                  ),
                  subtitle: Text(
                    personData.lastName ?? 'Error',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        personService
                            .deletePerson(person[index].id.toString())
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post deleted')),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to delete post')),
                          );
                        });
                      });
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading posts'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            final person = Person(
                firstName: 'First Name',
                lastName: 'Last NAME',
                message: 'MESSAGE',
                id: '112233');
            //personService.createPerson(person);
            personService.createPerson(person).then((createdPost) {
              // The createdPost object will contain the newly created post with its assigned ID
              // You can perform any necessary actions with the created post, such as displaying a success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Person created successfully')),
              );
            }).catchError((error) {
              // Handle any errors that occurred during the creation process
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
