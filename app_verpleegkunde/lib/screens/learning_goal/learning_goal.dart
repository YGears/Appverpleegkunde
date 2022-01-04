import 'dart:async';
import 'package:flutter/rendering.dart';
import 'overview.dart';
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
  // startDate can't be null so will be current date
  DateTime startDate = DateTime.now();
  // endDate can't be null so will be one week later than startDate by default
  DateTime endDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);
  // Record of current Time that can't be changed
  static DateTime now = DateTime.now();

  String error = "";
  String _geselecteerdLeerdoel = 'Nog geen leerdoel geselecteerd';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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

  Future<void> selectStartDate(BuildContext context, DateTime date) async {
    // Function to select a date
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(now.year, now.month - 3),
        lastDate: DateTime(now.year, now.month + 3));

    if (picked != null && picked != date) {
      // If date picked and date isn't the date picked than
      // startDate becomes the selected date
      setState(() {
        startDate = picked;
        endDate = DateTime(picked.year, picked.month, picked.day + 7);
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    // Function to select a date
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(startDate.year, startDate.month + 3));

    if (picked != null && picked != startDate) {
      // If date picked and date isn't the date picked than
      // startDate becomes the selected date
      setState(() {
        endDate = picked;
      });
    }
  }

  //TODO CREATE FUNCTION TO SAVE LEARNING GOALS make validation check before posting
  Future<void> createLearningGoal() async {
    //Set dateTimes to Database format using dateFormating
    String beginDate = dateFormating(startDate);
    String lastDate = dateFormating(endDate);
    //if selected learning goal - default value
    if (_geselecteerdLeerdoel == 'Nog geen leerdoel geselecteerd') {
      //POP UP THAT NO LEARNING GOAL HAS BEEN SELECETED
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Foutmelding'),
                content: Text('Geen leerdoel geselecteerd'),
              ));
    } else {
      String json =
          "{beginDate: \"$beginDate\",endDate: \"$lastDate\",tag: \"$_geselecteerdLeerdoel\"}";
      print(json);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leerdoel"),
        centerTitle: true,
      ),
      // Body of the application
      body: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Column(children: <Widget>[
            const Text("Startdatum"),
            ElevatedButton(
                child: Text(dateFormating(startDate)),
                onPressed: () async => selectStartDate(context, startDate))
          ]),
          Column(children: <Widget>[
            const Text("Einddatum"),
            ElevatedButton(
                child: Text(dateFormating(endDate)),
                onPressed: () async => selectEndDate(context))
          ]),
        ]),
        ListTile(title: Center(child: Text(_geselecteerdLeerdoel))),
        ElevatedButton(
          child: const Text("selecteer leerdoel"),
          onPressed: () => {_navigateAndDisplaySelection(context)},
        ),
        ElevatedButton(
          child: const Text("Maak Leerdoel aan"),
          onPressed: () => {createLearningGoal()},
        ),
        ElevatedButton(
          child: const Text("Overzicht van leerdoelen"),
          onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => learninGoalOverview()))},
        ),
      ]),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Leerdoelen()),
    );

    setState(() {
      if ('$result' != 'null') {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text('Nieuw Leerdoel geselecteerd!')));
        _geselecteerdLeerdoel = ' $result';
      }
    });
  }
}
