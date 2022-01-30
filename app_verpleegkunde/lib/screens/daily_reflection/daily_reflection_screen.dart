import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/log_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/dailyreflect.dart';
import 'package:flutter_application_1/screens/daily_reflection/sub_tags_screen.dart';
import '../../app_colors.dart';
import '../../controllers/list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../daily_reflection/daily_reflection.dart';
import '../../database_connection/syncronisatie.dart';

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
  List<Tag> subtags = [];

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

  String convertToJSON() {
    var rating = double.parse(dagRatingController.value.text);
    var freeWrite = freeWriteController.value.text;
    return daily_reflection(
            selectedDay, rating, freeWrite, selectedTags, subtags)
        .toString();
  }

  Future<void> saveDailyReflection() async {
    log_controller().record("Dagreflectie opgeslagen.");
    final prefs = await SharedPreferences.getInstance();
    List<String>? dailyReflections = prefs.getStringList('daily_reflection');
    dailyReflections ??= [];
    dailyReflections.add(convertToJSON());
    print(convertToJSON());
    prefs.setStringList('dag_reflectie', dailyReflections);
    print(prefs.getStringList('dag_reflectie'));
  }

  addTags() {
    List<Row> tagsToReturn = [];
    for (var item in selectedTags) {
      tagsToReturn.add(Row(children: [
        TextButton(
          child: Text(item),
          onPressed: () =>
              {directToSubTags(context, selectedTags.indexOf(item))},
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
      if (result != null) {
        log_controller().record("Mogelijke Tag geselecteerd.");
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text('Tag geselecteerd! - $result')));
        selectedTags.add('$result');
      }
    });
  }

  void directToSubTags(BuildContext context, int tag) async {
    final subTag = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubTagsScreen()),
    );

    setState(() {
      if (subTag != null) {
        List<String> tagText = [];
        tagText.add("\"$subTag\"");
        if (subtags.asMap().containsKey(tag)) {
          for (String t in subtags[tag].getSubTagList) {
            tagText.add(t);
          }
          subtags[tag] = Tag(tagText);
        } else {
          subtags.add(Tag(tagText));
        }

        log_controller().record("Mogelijke subtag geselecteerd.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // generateTagBody();
    generateBody();
    // generateSubTagBody();
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
