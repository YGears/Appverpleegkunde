// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class dailyReflectionPage extends StatefulWidget {
  const dailyReflectionPage({Key? key}) : super(key: key);
  @override
  State<dailyReflectionPage> createState() => _dailyReflectionPageState();
}

class _dailyReflectionPageState extends State<dailyReflectionPage> {
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
