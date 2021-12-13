import 'dart:async';
import 'dart:convert';
import 'image_cover.dart';
import 'package:flutter/rendering.dart';
import '../second.dart';
import '../learning_goal/learning_goal.dart';
import '../../functions/Api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  // Iets voor de routes maar wat?
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;
  String error = "";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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
            body: Column(children: <Widget>[
              //IMAGE
              ImageCover("../img/front_page_img_holder.jpg"),
              //ERROR MSG
              Text(error,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              Text(""),
              //INPUTFIELD
              TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Inlogcode',
                    hintText: 'Vul je inlogcode in',
                  ),
                  controller: myController),
              //LOGIN BUTTON
              ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    Api api = Api();
                    var loggedIn = await api.login(
                        myController.text, "KoekjesZijnGemaaktVanDeeg");
                    if (loggedIn) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MyHomePage(title: 'wat')));
                    } else {
                      setState(() {
                        error = "Failed to login";
                      });
                    }
                  }),
            ]),
          ),
        ));
  }

  login(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'wat')));
  }
}

//MSG SHOULDNT ALWAYS APPEAR