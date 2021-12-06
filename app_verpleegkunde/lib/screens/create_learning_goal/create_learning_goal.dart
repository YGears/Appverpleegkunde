// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class createLearningGoalPage extends StatefulWidget {
  const createLearningGoalPage({Key? key}) : super(key: key);
  @override
  State<createLearningGoalPage> createState() => _createLearningGoalPageState();
}

class _createLearningGoalPageState extends State<createLearningGoalPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hanze - Verpleegkunde',
        theme: ThemeData(
          //scaffoldBackgroundColor: const Color(0xFFe3e6e8),
          primarySwatch: Colors.orange,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            //Topheader within the application
            appBar: AppBar(
              title: const Text('Hanze Verpleegkunde'),
              centerTitle: true,
            ),
            // Body of the application
            body: Column(children: const <Widget>[
              Text("REFLECTEREN OP DAG"),
            ]),
          ),
        ));
  }
}
