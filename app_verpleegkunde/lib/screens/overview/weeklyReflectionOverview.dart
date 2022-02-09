// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../../controllers/log_controller.dart';

class WeeklyReflectionOverview extends StatefulWidget {
  List<String> learningGoal = [];

  WeeklyReflectionOverview(List<String> learninggoal, {Key? key})
      : super(key: key) {
    learningGoal = learninggoal;
  }

  @override
  WeeklyReflectionOverviewState createState() =>
      WeeklyReflectionOverviewState(learningGoal);
}

class WeeklyReflectionOverviewState extends State<WeeklyReflectionOverview> {
  LogController log = LogController();

  List<String> learninggoal = [];
  WeeklyReflectionOverviewState(this.learninggoal);

  List<String> listOfWeeklyReflections = ['a', 'b', 'c', 'd', 'e'];

  @override
  Widget build(BuildContext context) {
    log.record("Is naar de kies leerdoel pagina gegaan.");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekreflecties van leerdoel'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10.0),
                itemCount: listOfWeeklyReflections.length,
                itemBuilder: (context, index) {
                  return buildRowOfWeeklyReflections(
                      listOfWeeklyReflections[index]);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildRowOfWeeklyReflections(String value) {
    return Text(value);
  }
}
