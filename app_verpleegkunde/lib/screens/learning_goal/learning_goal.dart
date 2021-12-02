import 'dart:async';
import 'package:flutter/rendering.dart';
import '../second.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Leerdoel extends StatefulWidget {
  // Iets voor de routes maar wat?
  const Leerdoel({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LeerDoelState createState() => _LeerDoelState(title);
}

class _LeerDoelState extends State<Leerdoel> {
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String error = "";
  String title = "";
  final myController = TextEditingController();

  _LeerDoelState(String newTitle){
    title = newTitle;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year, date.month-1),
      lastDate: DateTime(date.year + 1));
      return picked;
  }
  @override
  Widget build(BuildContext context) {
    DateTime? fl;
    return MaterialApp(
      title: title,
      theme: ThemeData(
        //scaffoldBackgroundColor: const Color(0xFFe3e6e8),
        primarySwatch: Colors.orange,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          //Topheader within the application
          appBar: AppBar(
            title: Text("$title"),
            centerTitle: true,
          ),
          // Body of the application
          body: Column(children: <Widget>[
            //LOGIN BUTTON
            ElevatedButton(
              child:Text("$beginDate"),
              onPressed:  () async => {
                fl = await _selectDate(context, beginDate),
                if (fl != null){
                  setState(() {
                    beginDate = fl!;
                  })
                }
              }
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Leerdoel',
                hintText: 'Vul je leerdoel in',
              ),
              controller: myController
            ),
            ElevatedButton(
              child:Text("$endDate"),
              onPressed:  () async => {
                fl = await _selectDate(context, endDate),
                if (fl != null){
                  setState(() {
                    endDate = fl!;
                  })
                }
              }
            ),
          ]),
        ),
      )
    );
  }
}
