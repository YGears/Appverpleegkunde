// ignore_for_file: camel_case_types

import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logging/log_controller.dart';

class WeekReflectionScreen extends StatefulWidget {
  const WeekReflectionScreen({Key? key, required this.selectedDate})
      : super(key: key);
  final DateTime selectedDate;
  @override
  State<WeekReflectionScreen> createState() =>
      WeekReflectionScreen_State(selectedDate);
}

class WeekReflectionScreen_State extends State<WeekReflectionScreen> {
  var selectedDate = DateTime.now();
  var selectedDay = "";
  String activatedMainTag = "Klik Hier";
  List selectedTags = [];
  List<Row> generatedBody = [];
  List<Row> generatedTagBody = [];
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

  Future<List<String>> getTags() async {
    final prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('leerdoel') ?? [];
    return list;
  }

  gotoTagBody() {
    setState(() {
      activatedPage = 0;
    });
  }

  gotoSubTag(tag) {
    setState(() {
      activatedMainTag = tag;
      activatedPage = 2;
    });
  }

  gotoDailyReflection() {
    setState(() {
      activatedPage = 1;
    });
  }

  addMainTag(tag) {
    setState(() {
      activatedMainTag = tag;
    });
    gotoDailyReflection();
  }

  generateTagBody() async {
    List<String> tags = await getTags();
    // var jtag = json.decode(tags[0])["onderwerp"];
    // print(jtag);
    List<Row> tagBody = [];
    for (String tag in tags) {
      tagBody.add(Row(children: [
        TextButton(
          child: Text(json.decode(tag)["onderwerp"]),
          onPressed: () => {addMainTag(json.decode(tag)["onderwerp"])},
        )
      ]));
    }
    generatedTagBody = tagBody;
  }

  String convertToJSON() {
    var rating = dagRatingController.value.text;
    var freeWrite = freeWriteController.value.text;
    var dateFormat = DateFormat('dd/MM/yyyy');
    var date = dateFormat.format(selectedDate);
    var weekNumber = 5;
    String json = "{";

    json += "\"date\": \"$date\", \"weeknummer\": $weekNumber,";
    if (rating != "") {
      json += " \"rating\": $rating,";
    } else {
      json += " \"rating\": 0,";
    }
    json +=
        " \"leerdoel\": \"$activatedMainTag\", \"vooruitblik\": \"$freeWrite\"}";
    print(json);
    return json;
  }

  Future<void> saveDailyReflection() async {
    log_controller().record("Weekreflectie opgeslagen.");
    final prefs = await SharedPreferences.getInstance();
    List<String>? dailyReflections =
        prefs.getStringList('WeekReflectionScreen');
    dailyReflections ??= [];
    dailyReflections.add(convertToJSON());

    prefs.setStringList('WeekReflectionScreen', dailyReflections);
  }

  addTags() {
    List<Row> tags_to_return = [];
    for (var item in selectedTags) {
      tags_to_return.add(Row(children: [
        TextButton(
          child: Text(item),
          onPressed: () => {gotoSubTag(item)},
        )
      ]));
    }
    return tags_to_return;
  }

  generateBody() {
    log_controller().record("Naar pagina weekreflectie maken gegaan.");
    List<Row> tempBody = [
      Row(
        children: [
          const Text("Reflectie op week (Maandag - Zondag): "),
          ElevatedButton(
              child: Text(selectedDay), onPressed: () => {_selectDate(context)})
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
        children: const [Text("Vooruitblik:")],
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
            child: Text(activatedMainTag),
            onPressed: () => {gotoTagBody()},
          ),
        ],
      ),
    ];

    tempBody.addAll(addTags());

    tempBody.add(
      Row(
        children: [
          ElevatedButton(
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
    generateTagBody();
    generateBody();
    bodies.clear();
    bodies.add(generatedTagBody);
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
