import 'dart:async';
import 'package:flutter/rendering.dart';
import '../second.dart';
import 'package:flutter/material.dart';
import 'choose_learning_goal.dart';
import 'package:http/http.dart' as http;

class Leerdoel extends StatefulWidget {
  // Iets voor de routes maar wat?
  const Leerdoel({Key? key}) : super(key: key);

  @override
  _LeerDoelState createState() => _LeerDoelState();
}

class _LeerDoelState extends State<Leerdoel> {
  DateTime beginDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String error = "";
  String title = "";
  String _geselecteerdLeerdoel = 'Nog geen leerdoel geselecteerd';

  final myController = TextEditingController();

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
        firstDate: DateTime(date.year, date.month - 1),
        lastDate: DateTime(date.year + 1));
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? fl;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                  child: Text("$beginDate"),
                  onPressed: () async => {
                        fl = await _selectDate(context, beginDate),
                        if (fl != null)
                          {
                            setState(() {
                              beginDate = fl!;
                            })
                          }
                      }),
              TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Leerdoel',
                    hintText: 'Vul je leerdoel in',
                  ),
                  controller: myController),
              ElevatedButton(
                  child: Text("$endDate"),
                  onPressed: () async => {
                        fl = await _selectDate(context, endDate),
                        if (fl != null)
                          {
                            setState(() {
                              endDate = fl!;
                            })
                          }
                      }),
              ListTile(title: Center(child: Text(_geselecteerdLeerdoel))),

              ElevatedButton(
                child: const Text("selecteer leerdoel"),
                onPressed: () => {_navigateAndDisplaySelection(context)},
              ),
            ]),
          ),
        ));
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Leerdoelen()),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Nieuw Leerdoel geselecteerd!')));
    setState(() {
      if ('$result' != 'null') {
        _geselecteerdLeerdoel = ' $result';
      }
    });
  }
}