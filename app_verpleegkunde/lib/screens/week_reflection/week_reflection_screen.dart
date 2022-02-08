import 'dart:collection';
import 'dart:convert';
import 'package:flutter_application_1/controllers/list_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/log_controller.dart';
import '../root_screen.dart';

class WeekReflectionScreen extends StatefulWidget {
  const WeekReflectionScreen({Key? key, required this.selectedDate})
      : super(key: key);

  final DateTime selectedDate;

  @override
  State<WeekReflectionScreen> createState() => WeekReflectionScreen_State(selectedDate);
}

class WeekReflectionScreen_State extends State<WeekReflectionScreen> {
  var selectedDate = DateTime.now();
  var selectedDay = "";
  String learningGoal = "Klik Hier";
  List selectedTags = [];
  List<Row> generatedBody = [];
  List<Row> generatedLearningGoalBody = [];
  List<Row> generatedSubTagBody = [];
  Map subtags = HashMap<String, List<String>>();
  List<List<Row>> bodies = [];
  int activatedPage = 1;
  final dagRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  WeekReflectionScreen_State(this.selectedDate) {
    selectedDay = selectedDate.year.toString() +
        "/" +
        selectedDate.month.toString() +
        "/" +
        selectedDate.day.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    dagRatingController.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        selectedDay = selectedDate.year.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.day.toString();
      });
    }
  }

  Future<List<String>> getLearningGoals() async {
    return await list_controller("leerdoel").getList as List<String>;
  }

  gotoSelectLearningGoalScreen() {
    setState(() {
      activatedPage = 0;
    });
  }

  gotoWeeklyReflection() {
    setState(() {
      activatedPage = 1;
    });
  }

  selectLearningGoal(selectedLearningGoal) {
    setState(() {
      learningGoal = selectedLearningGoal;
    });
    gotoWeeklyReflection();
  }

  generateLearningGoalBody() async {
    List<String> learningGoals = await getLearningGoals();
    List<Row> tagBody = [];

    for (String goal in learningGoals) {
      tagBody.add(Row(children: [
        TextButton(
          child: Text(json.decode(goal)["onderwerp"]),
          onPressed: () => {selectLearningGoal(json.decode(goal)["onderwerp"])},
        )
      ]));
    }
    generatedLearningGoalBody = tagBody;
  }

  String convertToJSON() {
    var rating = dagRatingController.value.text;
    var freeWrite = freeWriteController.value.text;
    var dateFormat = DateFormat('dd/MM/yyyy');
    var date = dateFormat.format(selectedDate);
    var weekNumber = 5;
    String json = "{";

    json += "\"datum\": \"$date\", \"weeknummer\": $weekNumber,";

    if (rating != "") {
      json += " \"rating\": $rating,";
    } else {
      json += " \"rating\": 0,";
    }

    json +=
        " \"leerdoel\": \"$learningGoal\", \"vooruitblik\": \"$freeWrite\"}";

    return json;
  }

  Future<void> saveDailyReflection() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dailyReflections = prefs.getStringList('week_reflectie');

    dailyReflections ??= [];

    if (dagRatingController.value.text == '') {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Foutmelding'),
                content: Text('Geen Rating gegeven'),
              ));
    } else {
      dailyReflections.add(convertToJSON());

      prefs.setStringList('week_reflectie', dailyReflections);
      LogController().record("Weekreflectie opgeslagen.");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    }
  }

  generateBody() {
    LogController().record("Naar pagina weekreflectie maken gegaan.");
    List<Row> tempBody = [
      Row(children: const [
        Text(""),
      ]),
      Row(
        children: [
          const Text("Reflectie op week (Maandag - Zondag): "),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.orange,
              ),
              child: Text(selectedDay),
              onPressed: () => {_selectDate(context)})
        ],
      ),
      Row(
        children: [
          const Text("Rating van dag: "),
          Flexible(
            child: TextField(
                decoration: const InputDecoration(labelText: ""),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1)
                ],
                controller: dagRatingController),
          ),
        ],
      ),
      Row(
        children: const [Text("Terugblik:")],
      ),
      Row(
        children: [
          Flexible(
            child: TextField(maxLines: 8, controller: freeWriteController),
          )
        ],
      ),
      Row(
        children: [
          const Text("Select tag"),
          TextButton(
            child: Text(learningGoal),
            onPressed: () => {gotoSelectLearningGoalScreen()},
          ),
        ],
      ),
    ];

    tempBody.add(
      Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.orange,
              ),
              child: const Text("Reflectie Opslaan"),
              onPressed: () => {saveDailyReflection()})
        ],
      ),
    );

    setState(() {
      generatedBody = tempBody;
    });
  }

  @override
  Widget build(BuildContext context) {
    generateLearningGoalBody();
    generateBody();
    bodies.clear();
    bodies.add(generatedLearningGoalBody);
    bodies.add(generatedBody);
    bodies.add(generatedSubTagBody);
    
    return Scaffold(
      //Topheader within the application
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      // Body of the application
      body: Column(children: bodies[activatedPage]),
    );
  }
}
