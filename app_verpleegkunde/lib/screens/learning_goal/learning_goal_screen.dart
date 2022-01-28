import 'dart:async';
import 'package:flutter_application_1/app_colors.dart';
import 'package:flutter_application_1/screens/root_screen.dart';

import '../../controllers/log_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'choose_learning_goal.dart';
import '../../style.dart';

class LearningGoalScreen extends StatefulWidget {
  // Iets voor de routes maar wat?
  const LearningGoalScreen({Key? key}) : super(key: key);

  @override
  _LearningGoalScreenState createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends State<LearningGoalScreen> {
  static DateTime currentTime = DateTime.now();
  DateTime startDate = currentTime;
  DateTime endDate =
      DateTime(currentTime.year, currentTime.month, DateTime.now().day + 7);

  String error = "";
  String selectedLearningGoal = 'Nog geen leerdoel geselecteerd';

  String streefCijfer = '0';

  @override
  void dispose() {
    super.dispose();
  }

  String dateFormating(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> selectStartDate(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(currentTime.year, currentTime.month - 3),
        lastDate: DateTime(currentTime.year, currentTime.month + 3));

    if (picked != null && picked != date) {
      setState(() {
        startDate = picked;
        endDate = DateTime(picked.year, picked.month, picked.day + 7);
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: DateTime(startDate.year, startDate.month + 3));

    if (picked != null && picked != startDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> createLearningGoal() async {
    log_controller().record("Een nieuw leerdoel aangemaakt.");

    String beginDate = dateFormating(startDate);
    String lastDate = dateFormating(endDate);

    if (selectedLearningGoal == 'Nog geen leerdoel geselecteerd') {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Foutmelding'),
                content: Text('Geen leerdoel geselecteerd'),
              ));
    } else {
      String json =
          "{\"begin_datum\": \"$beginDate\",\"eind_datum\": \"$lastDate\",\"onderwerp\": \"$selectedLearningGoal\",\"streefcijfer\":\"$streefCijfer\"}";

      final prefs = await SharedPreferences.getInstance();
      List<String>? leerdoelen = prefs.getStringList('leerdoel') ?? [];
      leerdoelen.add(json);
      prefs.setStringList('leerdoel', leerdoelen);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Leerdoelen()),
    );

    setState(() {
      if ('$result' != 'null') {
        log_controller().record("Mogelijke leerdoel geselecteerd.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text('Nieuw Leerdoel geselecteerd! - $result')));
        selectedLearningGoal = ' $result';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Het zetten van een leerdoel"),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: contentWrapper(context),
    );
  }

  Widget contentWrapper(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          const SizedBox(height: 30),
          chooseLearningGoal(context),
          const SizedBox(height: 30),
          chooseTargetFigure(context),
          const SizedBox(height: 30),
          selectPeriod(context),
          const SizedBox(height: 30),
          createButton(context)
        ]),
      )
    ]);
  }

  //Widget for selecting a period in which that learning goal will be set
  Widget selectPeriod(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        padding: const EdgeInsets.all(20.0),
        decoration: Style().borderStyling(),
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
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.yellow,
                      primary: Colors.red,
                    ),
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
      decoration: Style().borderStyling(),
      child: Column(children: <Widget>[
        const Text(
          "Kies een leerdoel voor de periode",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ListTile(title: Center(child: Text(selectedLearningGoal))),
        ElevatedButton(
          child: const Text("Selecteer leerdoel"),
          onPressed: () => {_navigateAndDisplaySelection(context)},
        ),
      ]),
    );
  }

  Widget chooseTargetFigure(BuildContext context) {
    final myController = TextEditingController();
    return Container(
      margin: const EdgeInsets.only(left: 40.0, right: 40.0),
      padding: const EdgeInsets.all(20.0),
      decoration: Style().borderStyling(),
      child: Column(children: <Widget>[
        const Text(
          "Kies een streefcijfer voor het leerdoel",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ListTile(title: Center(child: Text('$streefCijfer / 10'))),
        ElevatedButton(
          child: const Text("Selecteer streefcijfer"),
          onPressed: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: const Text('Selecteer streefcijfer:'),
                        actions: <Widget>[
                          TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1)
                              ],
                              controller: myController),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Annuleer',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (myController.text.isNotEmpty) {
                                    setState(() {
                                      streefCijfer = myController.text;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(this.context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(const SnackBar(
                                          content: Text('Veld is leeg')));
                                  }
                                },
                                child: const Text(
                                  'Voeg toe',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ]))
          },
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
