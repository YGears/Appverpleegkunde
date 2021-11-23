import 'dart:async';
import 'dart:convert';

import 'package:flutter/rendering.dart';

import '../second.dart';
//import '../secondScreen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// OUT OF APP SCOPE ESTABLISHING CONNECTION TO DB FOR LOGIN
Future<Album> fetchAlbum(title, context) async {
  final response = await http.post(
    Uri.parse('https://iabamun.nl/game/lab-andre/api/index.php/login'),
    body: jsonEncode(<String, String>{
      "name": title.toString(),
      "password": "KoekjesZijnGemaaktVanDeeg",
    }),
  );
  var data = jsonDecode(response.body);

  if (data['response'] != null) {
    if (data['response'] == "Logged in") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'wat')));
    }
  }

  return Album.fromJson(jsonDecode(response.body));
}

class Album {
  final String response;

  Album({
    required this.response,
  });

  getResponse() {
    return response;
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      response: json['response'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  String error = "";

  // @override
  // void initState() {
  //   super.initState();
  //   futureAlbum = fetchAlbum("");
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hanze Verpleeg App',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFe3e6e8),
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Nurse - IT'),
            ),
            body: Center(child: buildColumn(context)),
          ),
        ));
  }

  Table buildColumn(BuildContext context) {
    final myController = TextEditingController();

    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myController.dispose();
      super.dispose();
    }

    return Table(columnWidths: {
      0: FlexColumnWidth(8),
      1: FlexColumnWidth(6)
    }, children: [
      TableRow(children: [
        Text(error,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        Text("")
      ]),
      TableRow(children: [
        TextField(
          decoration: InputDecoration(fillColor: Colors.white, filled: true),
          controller: myController,
        ),
        Container(
            child: TextButton(
          onPressed: () {
            futureAlbum = fetchAlbum(myController.text, context);
            setState(() {
              error = "Failed to login";
            });
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.all(25), backgroundColor: Colors.blue),
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.black),
          ),
        )),
      ])
    ]);
  }

  login(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'wat')));
  }
}
