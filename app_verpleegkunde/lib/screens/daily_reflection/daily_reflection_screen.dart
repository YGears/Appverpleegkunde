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
import '../root_screen.dart';

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
  List<Map<String, dynamic>> subtags = [];

  List<List<Row>> bodies = [];
  int activatedPage = 1;
  final dagRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  list_controller dailyList = list_controller('daily_reflection');
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
    List<Tag> temp = [];
    for (Map<String, dynamic> i in subtags) {
      temp.add(Tag.fromJson(i));
    }
    return daily_reflection(selectedDay, rating, freeWrite, selectedTags, temp)
        .toString();
  }

  Future<void> saveDailyReflection() async {
    LogController().record("Dagreflectie opgeslagen.");
    if (dagRatingController.value.text == '') {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Foutmelding'),
                content: Text('Geen Rating gegeven'),
              ));
    } else {
      dailyList.add(convertToJSON());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    }
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
      Row(children: const [
        Text(""),
      ]),
      Row(
        children: [
          const Text("Reflectie op dag: "),
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
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.orange,
              ),
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
        LogController().record("Mogelijke Tag geselecteerd.");
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
      List<String> tagText = [];
      if (subTag != null) {
        if (subtags.isEmpty) {
          // print("----Filled----");
          Map<String, List<String>> map = {'sub_tags': []};
          subtags.add(map);
        }
        for (int toAdd = tag - (subtags.length - 1); toAdd > 0; toAdd--) {
          // print(toAdd);
          // print("added map--------------------------");
          Map<String, List<String>> map = {'sub_tags': []};
          subtags.add(map);
        }
        // tagText.add("$subTag");
        if (subtags.asMap().containsKey(tag)) {
          for (List<String> t in subtags[tag].values) {
            tagText = t;
          }
          tagText.add(subTag);
          subtags[tag].update('sub_tags', (dynamic) => tagText);
          // subtags[tag] = Tag.fromJson(map);
        } else {
          // if (subtags.length - 1 >= tag) {
          //   tagText.add(subTag.toString());
          //   Map<String, dynamic> map = {'sub_tags': tagText};
          //   subtags.add(map);
          // } else {

          // }
          // print(subtags.length);
          // print('error - TAGS ---> :(');
        }
        LogController().record("Mogelijke subtag geselecteerd.");
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
