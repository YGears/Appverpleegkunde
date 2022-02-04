import 'package:intl/intl.dart';

class LearningGoal {
  String begin_datum;
  String eind_datum;
  String onderwerp;
  int streefcijfer;
  
  LearningGoal(
      this.begin_datum, this.eind_datum, this.onderwerp, this.streefcijfer);

  factory LearningGoal.fromJson(Map<String, dynamic> parsedJson) {
    int grade;
    if (parsedJson['streefcijfer'].runtimeType == String) {
      grade = int.parse(parsedJson['streefcijfer']);
    } else {
      grade = parsedJson['streefcijfer'];
    }
    return LearningGoal(parsedJson['begin_datum'], parsedJson['eind_datum'],
        parsedJson['onderwerp'], grade);
  }
  @override
  String toString() {
    return '{ "begin_datum": "$begin_datum", "eind_datum": "$eind_datum", "onderwerp": "$onderwerp", "streefcijfer": "$streefcijfer"}';
  }

  DateTime get getBeginingDate {
    List<String> gesplitst = begin_datum.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
    // DateTime result = DateTime.parse(reassemble);
    return DateFormat("dd/MM/yyyy").parse(begin_datum);
  }

  DateTime get getEndingDate {
    List<String> gesplitst = eind_datum.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
    // DateTime result = DateTime.parse(reassemble);
    return DateFormat("dd/MM/yyyy").parse(eind_datum);
  }

  String get getSubject {
    return onderwerp;
  }

  double get getTargetGrade {
    return streefcijfer.toDouble();
  }
}
