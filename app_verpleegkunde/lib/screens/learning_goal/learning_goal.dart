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
  DateTime currentDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime now = DateTime.now();

  String error = "";
  String _geselecteerdLeerdoel = 'Nog geen leerdoel geselecteerd';
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String dateFormating(DateTime date) {
    // Function to change the formating of dates within the application
    if (date == null) {
      return "Error";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  //firstDate: DateTime(date.year, date.month - 1),

  bool dateIsEmpty(DateTime date) {
    bool valdate = date.isBefore(currentDate);
    return valdate;
  }

  Future<void> selectStartDate(BuildContext context, DateTime date) async {
    // Function to select a date
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(now.year, now.month - 3),
        lastDate: DateTime(now.year, now.month + 3));

    if (picked != null && picked != date) {
      // If date picked and date isn't the date picked than
      // CurrentDate becomes the selected date
      setState(() {
        currentDate = picked;
        endDate = DateTime(picked.year, picked.month, picked.day + 7);
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    // Function to select a date
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(now.year, now.month + 3));

    if (picked != null && picked != currentDate) {
      // If date picked and date isn't the date picked than
      // CurrentDate becomes the selected date
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //scaffoldBackgroundColor: const Color(0xFFe3e6e8),
          primarySwatch: Colors.orange,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            //Topheader within the application
            appBar: AppBar(
              centerTitle: true,
            ),
            // Body of the application
            body: Column(children: <Widget>[
              //Date selection
              ElevatedButton(
                  child: Text(dateFormating(currentDate)),
                  onPressed: () async => selectStartDate(context, currentDate)),
              ElevatedButton(
                  child: Text(dateFormating(endDate)),
                  onPressed: () async => selectEndDate(context)),
              TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Leerdoel',
                    hintText: 'Selecteer een Leerdoel',
                  ),
                  controller: myController),
              ListTile(title: Center(child: Text(_geselecteerdLeerdoel))),
              ElevatedButton(
                child: const Text("selecteer leerdoel"),
                onPressed: () => {_navigateAndDisplaySelection(context)},
              ),
              ElevatedButton(
                child: const Text("Maak Leerdoel aan"),
                onPressed: () => {null},
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
