import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int task1() {
    int value = 0;
    for (int i = 0; i < 1000000000; i++) {
      value++;
    }
    return value;
  }

  Future<int> task2() async {
    int value = 0;
    for (int i = 0; i < 1000000000; i++) {
      value++;
    }
    return value;
  }

  Future<int> task3() async {
    return await compute((_) {
      int value = 0;
      for (int i = 0; i < 1000000000; i++) {
        value++;
      }
      return value;
    }, 'message');
  }

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            ElevatedButton(
              child: const Text('Normal - Task 1'),
              onPressed: () {
                int v = task1();
                print("normal: $v");
              },
            ),
            ElevatedButton(
              child: const Text('Future - Task 2'),
              onPressed: () async {
                int v = await task2();
                print("future: $v");
              },
            ),
            ElevatedButton(
              child: const Text('Compute - Task 3'),
              onPressed: () async {
                int v = await task3();
                print("compute: $v");
              },
            ),
            ElevatedButton(
              child: const Text('Isolate - spawn - Task 4'),
              onPressed: () async {
                //isolate method must be outside the widget class
                await task4();
                // print("isolate: $v");
              },
            ),
            ElevatedButton(
              child: const Text('Isolate - run - Task 5'),
              onPressed: () async {
                //isolate method must be outside the widget class
                int v = await task5();
                print("isolate run: $v");
              },
            ),
            ElevatedButton(
              child: const Text('Isolate - spawnUri - Task 6'),
              onPressed: () async {
                //isolate method must be outside the widget class
                await task6();
                // print("isolate spawnUri: $v");
              },
            ),
          ],
        ),
      ),
    );
  }
}

void complexTask(SendPort sendPort) {
  int value = 0;
  for (int i = 0; i < 1000000000; i++) {
    value++;
  }

  sendPort.send(value);
}

Future<void> task4() async {
  final receivePort = ReceivePort();
  await Isolate.spawn(complexTask, receivePort.sendPort);
  receivePort.listen((v) {
    print("isolate: $v");
  });
}

Future<int> task5() async {
  int v = await Isolate.run(() {
    int value = 0;
    for (int i = 0; i < 1000000000; i++) {
      value++;
    }
    return value;
  });

  return v;
}

Future<void> task6() async {
  // create a local package and call main method
  String path = './dart_script.dart';
  final receivePort = ReceivePort();
  try {
    final uri = Uri.parse(path);
    await Isolate.spawnUri(uri, ["a"], receivePort.sendPort);
  } catch (err) {
    //
  }
}
