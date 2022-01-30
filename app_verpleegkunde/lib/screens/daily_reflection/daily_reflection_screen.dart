import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/log_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/dailyreflect.dart';
import 'package:flutter_application_1/screens/daily_reflection/sub_tags_screen.dart';
import '../../app_colors.dart';
import '../../controllers/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class dailyReflectionPage extends StatefulWidget {
  const dailyReflectionPage({Key? key, required this.selectedDate})
      : super(key: key);
  final DateTime selectedDate;
  @override
  State<dailyReflectionPage> createState() =>
      // ignore: no_logic_in_create_state
      _dailyReflectionPageState(selectedDate);
}

class _dailyReflectionPageState extends State<dailyReflectionPage> {
  var selectedDate = DateTime.now();
  var selectedDay = "";
  String activatedMainTag = "";
  List selectedTags = [];
  List<Row> generatedBody = [];
  List<Row> generatedTagBody = [];
  List<Row> generatedSubTagBody = [];
  Map subtags = HashMap<String, List<String>>();

  List<List<Row>> bodies = [];
  int activatedPage = 1;
  final dagRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  //MARK
  list_controller tagController = list_controller('tag');
  List listOfTags = [];
  list_controller subtagController = list_controller('subtag');
  List listOfSubtags = [];

  Future<void> update() async {
    List savedTags = await tagController.getList;
    List savedSubtags = await subtagController.getList;
    setState(() {
      listOfTags = savedTags;
      listOfSubtags = savedSubtags;
    });
  }

  _dailyReflectionPageState(this.selectedDate) {
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

  gotoDailyReflection() {
    setState(() {
      activatedPage = 1;
    });
  }

  addSubTag(String tag) {
    if (!subtags.containsKey(activatedMainTag)) {
      setState(() {
        subtags[activatedMainTag] = [tag];
      });
    }

    List<String> tempList = subtags[activatedMainTag];
    if (subtags[activatedMainTag][0] == "") {
      tempList = [];
    }

    if (!tempList.contains(tag)) {
      setState(() {
        tempList.add(tag);
        subtags[activatedMainTag] = tempList;
      });
    }

    generateSubTagBody();
  }

  addMainTag(tag) {
    setState(() {
      if (!selectedTags.contains(tag)) {
        selectedTags.add(tag);
        activatedMainTag = tag;
        subtags[activatedMainTag] = [""];
      }
    });
    gotoDailyReflection();
  }

  generateSubTagBody() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => update());
    List<Row> subTagBody = [
      Row(children: [
        TextButton(
            onPressed: () => {gotoDailyReflection()},
            child: const Text("Ga Terug"))
      ])
    ];
    for (String tag in listOfSubtags) {
      subTagBody.add(Row(children: [
        TextButton(
          child: Text(tag),
          onPressed: () => {addSubTag(tag)},
        )
      ]));
    }
    if (subtags[activatedMainTag] != null) {
      if (subtags[activatedMainTag][0].toString() != "") {
        for (String subTag in subtags[activatedMainTag]) {
          subTagBody.add(Row(children: [
            Text(subTag),
          ]));
        }
      }
    }
    generatedSubTagBody = subTagBody;
  }

  generateTagBody() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => update());
    List<Row> tagBody = [];
    for (String tag in listOfTags) {
      tagBody.add(Row(children: [
        TextButton(
          child: Text(tag),
          onPressed: () => {addMainTag(tag)},
        )
      ]));
    }
    generatedTagBody = tagBody;
  }

  String convertToJSON() {
    var rating = dagRatingController.value.text;
    var freeWrite = freeWriteController.value.text;
    bool tagged = false;
    String json = "{";

    json += "\"datum\": \"$selectedDate\",";
    if (rating != "") {
      json += "\"rating\": $rating,";
    } else {
      json += "\"rating\": 0,";
    }
    json += "\"opmerking\": \"$freeWrite\",\"tag\": [";
    for (String tag in selectedTags) {
      tagged = true;
      json += "\"$tag\",";
    }
    if (tagged) {
      json = json.substring(0, json.length - 1);
    }

    json += "],\"all_sub_tags\": [";

    for (String mainTag in selectedTags) {
      tagged = false;
      json += "{\"sub_tags\": [";
      for (String subTag in subtags[mainTag]) {
        if (subTag != "") {
          json += "\"$subTag\",";
          tagged = true;
        }
      }
      if (tagged) {
        json = json.substring(0, json.length - 1);
      }
      json += "]},";
    }
    json += "]}";
    print(json);
    return json;
  }

  Future<void> saveDailyReflection() async {
    log_controller().record("Dagreflectie opgeslagen.");
    print("A");
    final prefs = await SharedPreferences.getInstance();
    print("B, Wat moet deze lijst ophalen?");
    List<String>? dailyReflections = prefs.getStringList('daily_reflection');
    print("C, Als ie er niet is dan leeg inizailzeren");
    dailyReflections ??= [];
    //print("D, Voeg format toe aan deze kuhst");
    print(convertToJSON());
    //dailyReflections.add(convertToJSON());
    //print("E, geen idee");
    //prefs.setStringList('dag_reflectie', dailyReflections);
    print("Done");
  }

  addTags() {
    List<Row> tagsToReturn = [];
    for (var item in selectedTags) {
      tagsToReturn.add(Row(children: [
        TextButton(
          child: Text(item),
          onPressed: () => {directToSubTags(context)},
        )
      ]));
    }
    return tagsToReturn;
  }

  generateBody() {
    List<Row> screenForm = [
      Row(
        children: [
          const Text("Reflectie op dag: "),
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
        children: const [Text("Vrij Schrijven")],
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
          TextButton(
            child: const Text("Selecteer een Tag"),
            onPressed: () => {
              _navigateAndDisplaySelection(context),
            },
          ),
        ],
      ),
    ];
    //MARK hier kijken
    screenForm.addAll(addTags());

    screenForm.add(
      Row(
        children: [
          ElevatedButton(
              child: const Text("Sla reflectie op"),
              onPressed: () => {saveDailyReflection()})
        ],
      ),
    );

    setState(() {
      generatedBody = screenForm;
    });
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DailyReflections()),
    );

    setState(() {
      print(result);
      if (result != null) {
        log_controller().record("Mogelijke Tag geselecteerd.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text('Tag geselecteerd! - $result')));
        selectedTags.add('$result');
        print(selectedTags);
      }
    });
  }

  void directToSubTags(BuildContext context) async {
    final subTag = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubTagsScreen()),
    );

    setState(() {
      if (subTag != null) {
        log_controller().record("Mogelijke subtag geselecteerd.");
        //hoe voeg ik het toe aan de hasmap
        //https://stackoverflow.com/questions/53908405/how-to-add-a-new-pair-to-map-in-dart
        print(selectedTags);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    generateTagBody();
    generateBody();
    generateSubTagBody();
    bodies.clear();
    bodies.add(generatedTagBody);
    bodies.add(generatedBody);
    bodies.add(generatedSubTagBody);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      // Body of the application
      body: ListView(children: [Column(children: bodies[activatedPage])]),
    );
  }
}
