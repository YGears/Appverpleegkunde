import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/controllers/log_controller.dart';
import 'package:flutter_application_1/screens/daily_reflection/tag_screen.dart';
import 'package:flutter_application_1/screens/daily_reflection/sub_tags_screen.dart';
import '../../app_colors.dart';
import '../../controllers/list_controller.dart';
import '../daily_reflection/daily_reflection.dart';
import '../root_screen.dart';
import 'tag.dart';

class DailyReflectionScreen extends StatefulWidget {
  const DailyReflectionScreen({Key? key, required this.selectedDate})
      : super(key: key);
  final DateTime selectedDate;
  @override
  State<DailyReflectionScreen> createState() =>
      DailyReflectionScreenState(selectedDate);
}

class DailyReflectionScreenState extends State<DailyReflectionScreen> {
  DateTime selectedDate = DateTime.now();
  var selectedDay = "";
  String activatedMainTag = "";

  List<Row> listOfBodyComponents = [];
  List<Map<String, dynamic>> subtags = [];

  List<List<Row>> body = [];
  int activatedPage = 1;
  final dailyRatingController = TextEditingController();
  TextEditingController freeWriteController = TextEditingController();

  ListController dailyReflectionController = ListController('daily_reflection');
  ListController tagController = ListController('tag');
  ListController subtagController = ListController('subtag');

  List selectedTags = [];
  List listOfTags = [];
  List listOfSubtags = [];

  Future<void> updateListController() async {
    List localTags = await tagController.getList;
    List localSubtags = await subtagController.getList;
    setState(() {
      listOfTags = localTags;
      listOfSubtags = localSubtags;
    });
  }

  DailyReflectionScreenState(this.selectedDate) {
    selectedDay = selectedDate.year.toString() +
        "/" +
        selectedDate.month.toString() +
        "/" +
        selectedDate.day.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    dailyRatingController.dispose();
    super.dispose();
  }

  selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        selectedDay = selectedDate.year.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.day.toString();
      });
    }
  }

  String convertToJSON() {
    // Covert all values that are needed voor a daily reflection to as String in the JSON format
    double rating = double.parse(dailyRatingController.value.text);
    String freeWrite = freeWriteController.value.text;
    List<Tag> listOfSubTags = [];

    for (Map<String, dynamic> subtag in subtags) {
      listOfSubTags.add(Tag.fromJson(subtag));
    }

    return DailyReflection(
            selectedDay, rating, freeWrite, selectedTags, listOfSubTags)
        .toString();
  }

  Future<void> saveDailyReflection() async {
    LogController().record("Dagreflectie opgeslagen.");
    if (dailyRatingController.value.text == '') {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text('Foutmelding'),
                content: Text('Geen Rating gegeven'),
              ));
    } else {
      dailyReflectionController.add(convertToJSON());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    }
  }

  convertSelectedTagsToRows() {
    List<Row> rowsOfSelectedTags = [];
    for (String tag in selectedTags) {
      rowsOfSelectedTags.add(Row(children: [
        TextButton(
          child: Text(tag),
          onPressed: () => {
            navigateAndSelectSubTagScreen(context, selectedTags.indexOf(tag))
          },
        )
      ]));
    }
    return rowsOfSelectedTags;
  }

  generateDailyReflectionScreen() {
    List<Row> screenContent = [
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
              onPressed: () => {selectDate(context)})
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
                controller: dailyRatingController),
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
              navigateAndSelectTagScreen(context),
            },
          ),
        ],
      ),
    ];

    screenContent.addAll(convertSelectedTagsToRows());
    screenContent.add(
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
      listOfBodyComponents = screenContent;
    });
  }

  void navigateAndSelectTagScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TagScreen()),
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

  void navigateAndSelectSubTagScreen(
      BuildContext context, int maintagIndex) async {
    final subTag = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubTagsScreen()),
    );

    setState(() {
      List<String> tagText = [];
      if (subTag != null) {
        if (subtags.isEmpty) {
          Map<String, List<String>> mapOfSubTags = {'sub_tags': []};
          subtags.add(mapOfSubTags);
        }
        for (int toAdd = maintagIndex - (subtags.length - 1);
            toAdd > 0;
            toAdd--) {
          Map<String, List<String>> mapOfSubTags = {'sub_tags': []};
          subtags.add(mapOfSubTags);
        }
        if (subtags.asMap().containsKey(maintagIndex)) {
          for (List<String> tag in subtags[maintagIndex].values) {
            tagText = tag;
          }
          tagText.add(subTag);
          subtags[maintagIndex].update('sub_tags', (dynamic) => tagText);
        }
        LogController().record("Mogelijke subtag geselecteerd.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    generateDailyReflectionScreen();
    body.clear();
    body.add(listOfBodyComponents);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanze Verpleegkunde'),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: ListView(children: [Column(children: body[0])]),
    );
  }
}
