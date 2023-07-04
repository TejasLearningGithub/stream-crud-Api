import 'package:ex_stream/chat_gpt/main_stream/person_stream.dart';
import 'package:ex_stream/chat_gpt/main_stream/person_stream_second.dart';
import 'package:ex_stream/chat_gpt/post_widget.dart';
import 'package:ex_stream/convert_to_stream/screen/disp_data.dart';
import 'package:ex_stream/isolate_example/ex_isolate_first.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PostsScreenWithStream(),
    );
  }
}
