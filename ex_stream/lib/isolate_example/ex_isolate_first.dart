import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolateExample extends StatefulWidget {
  const IsolateExample({super.key});

  @override
  _IsolateExampleState createState() => _IsolateExampleState();
}

class _IsolateExampleState extends State<IsolateExample> {
  int _result = 0;

  void _calculateInIsolate() async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(_isolateTask, receivePort.sendPort);

    receivePort.listen((dynamic message) {
      if (message is int) {
        setState(() {
          _result = message;
        });
      }
    });

    // Perform other tasks while waiting for the isolate to complete
    // ...

    isolate.kill(priority: Isolate.immediate);
  }

  static void _isolateTask(SendPort sendPort) {
    int sum = 0;
    for (int i = 1; i <= 10; i++) {
      sum += i;
    }

    sendPort.send(sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Result:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_result',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calculateInIsolate,
        child: const Icon(Icons.calculate),
      ),
    );
  }
}
