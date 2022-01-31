// ignore_for_file: file_names
import 'package:flutter/material.dart';
import '../../controllers/log_controller.dart';

class weeklyReflectionOverview extends StatefulWidget {
  List<String> learningGoal = [];

  weeklyReflectionOverview(List<String> learninggoal, {Key? key})
      : super(key: key) {
    learningGoal = learninggoal;
  }

  // List<Widget> getLearninggoal(){
  //   return learningGoal;
  // }

  @override
  weeklyReflectionOverviewState createState() =>
      weeklyReflectionOverviewState(learningGoal);
}

class weeklyReflectionOverviewState extends State<weeklyReflectionOverview> {
  log_controller log = log_controller();

  List<String> learninggoal = [];
  weeklyReflectionOverviewState(this.learninggoal);

  List<String> dagreflecties = ['a', 'b', 'c', 'd', 'e'];

  @override
  Widget build(BuildContext context) {
    log.record("Is naar de kies leerdoel pagina gegaan.");
    final myController = TextEditingController();

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
                itemCount: dagreflecties.length,
                itemBuilder: (context, index) {
                  return _buildRow(dagreflecties[index]);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String value) {
    return Text(value);
  }
}
