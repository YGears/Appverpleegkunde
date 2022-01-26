import 'dart:async';
import 'dart:convert';
import 'image_cover.dart';
import '../content.dart';
import '../../functions/Api.dart';
import '../week_reflectie/week_reflectie.dart';
import '../../functions/syncronisatie.dart';
import '../../functions/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

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

class loginScreen extends StatefulWidget {
  // Iets voor de routes maar wat?
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

// ignore: camel_case_types
class _loginScreenState extends State<loginScreen> {
  late Future<Album> futureAlbum;
  String error = "";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void redirect_if_app_already_has_a_user() async{
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if(user != null){
      await Syncronisation.login(myController.text, "KoekjesZijnGemaaktVanDeeg");
      print("you should be seeing something....");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const mainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    redirect_if_app_already_has_a_user();


    return Scaffold(
      //Topheader within the application
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      // Body of the application
      body: Column(children: <Widget>[
        //IMAGE
        const ImageCover("assets/images/front_page_img_holder.jpg"),
        //ERROR MSG
        Container(
          height: 30,
          child: Center(
            child: Text(error,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
        //INPUTFIELD
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.orange[200],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.orange[900],
                  ),
                  hintText: 'Inlogcode',
                  border: InputBorder.none,
                ),
                controller: myController)),
        ElevatedButton(
        child: const Text("Login"),
        onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => week_reflectie(selectedDate: DateTime.now())));
                }),
        loginButton(context),
      ]),
    );
  }

  login(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const mainPage()));
  }

  Widget loginButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      width: 200,
      child: ElevatedButton(
        child: const Text("Login"),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber[700],
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontStyle: FontStyle.italic),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
               onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const mainPage()));
          Api api = Api();
          var loggedIn =
              await api.login(myController.text, "KoekjesZijnGemaaktVanDeeg");
          if (loggedIn) {
            await Syncronisation.login(
                myController.text, "KoekjesZijnGemaaktVanDeeg");
            print("you should be seeing something....");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const mainPage()));
          } else {
            setState(() {
              error = "Inloggen mislukt";
            });
          }
        },
      ),
    );
  }
}
