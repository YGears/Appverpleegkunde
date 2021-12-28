import 'dart:async';
import 'package:flutter/material.dart';
import 'choose_learning_goal.dart';

class learninggoalPage extends StatefulWidget {
  // Iets voor de routes maar wat?
  const learninggoalPage({Key? key}) : super(key: key);

  @override
  _learninggoalPageState createState() => _learninggoalPageState();
}

class _learninggoalPageState extends State<learninggoalPage> {
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

  //TEST
  BoxDecoration borderStyling() {
    return BoxDecoration(
      color: Colors.orange[50],
      border: Border.all(width: 3.0),
      borderRadius: const BorderRadius.all(
          Radius.circular(10.0) //                 <--- border radius here
          ),
    );
  }

  @override
  // Widget that builds the scaffold that holds all the widgets that this screen consists off
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Het zetten van een leerdoel"),
        centerTitle: true,
      ),
      // Body of the application
      body: contentWrapper(context),
    );
  }

  // Wrapps all widgets in to one single widget
  Widget contentWrapper(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        const SizedBox(
          height: 75,
        ),
        selectPeriod(context),
        const SizedBox(
          height: 30,
        ),
        chooseLearningGoal(context),
        const SizedBox(
          height: 40,
        ),
        createButton(context)
      ]),
    );
  }

  //Widget for selecting a period in which that learning goal will be set
  Widget selectPeriod(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        padding: const EdgeInsets.all(20.0),
        decoration: borderStyling(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Periode van het leerdoel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Creates spacing between items inside of the column
            const SizedBox(
              height: 8,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Column(children: <Widget>[
                const Text("Startdatum"),
                ElevatedButton(
                    child: Text(dateFormating(startDate)),
                    onPressed: () async => selectStartDate(context, startDate))
              ]),
              const SizedBox(
                width: 20,
              ),
              Column(children: <Widget>[
                const Text("Einddatum"),
                ElevatedButton(
                    child: Text(dateFormating(endDate)),
                    onPressed: () async => selectEndDate(context))
              ]),
            ]),
          ],
        ));
  }

  Widget chooseLearningGoal(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40.0, right: 40.0),
      padding: const EdgeInsets.all(20.0),
      decoration: borderStyling(),
      child: Column(children: <Widget>[
        const Text(
          "Kies een leerdoel voor de periode",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ListTile(title: Center(child: Text(_geselecteerdLeerdoel))),
        ElevatedButton(
          child: const Text("Selecteer leerdoel"),
          onPressed: () => {_navigateAndDisplaySelection(context)},
        ),
      ]),
    );
  }

  Widget createButton(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        child: const Text("Maak het leerdoel aan"),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber[700],
          textStyle: const TextStyle(
              color: Colors.black, fontSize: 24, fontStyle: FontStyle.italic),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () => {createLearningGoal()},
      ),
    );
  }
}
