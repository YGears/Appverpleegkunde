import 'package:intl/intl.dart';

class LearningGoal {
  String beginDate;
  String endDate;
  String subject;
  int targetmark;

  LearningGoal(this.beginDate, this.endDate, this.subject, this.targetmark);

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
    return '{ "begin_datum": "$beginDate", "eind_datum": "$endDate", "onderwerp": "$subject", "streefcijfer": "$targetmark"}';
  }

  DateTime get getBeginingDate {
    List<String> gesplitst = beginDate.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }
    return DateFormat("dd/MM/yyyy").parse(beginDate);
  }

  DateTime get getEndingDate {
    List<String> gesplitst = endDate.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    return DateFormat("dd/MM/yyyy").parse(endDate);
  }

  String get getSubject {
    return subject;
  }

  double get getTargetGrade {
    return targetmark.toDouble();
  }
}
