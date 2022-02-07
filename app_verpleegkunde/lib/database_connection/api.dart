import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/log_controller.dart';
import 'package:http/http.dart' as http;
import '../screens/daily_reflection/daily_reflection.dart';

class Response {
  final String response;

  Response({
    required this.response,
  });

  getResponse() {
    return response;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      response: json['response'],
    );
  }
}

class LearningGoal {
  String startDate;
  String endDate;
  String subject;
  int targetFigure;
  LearningGoal(
      this.startDate, this.endDate, this.subject, this.targetFigure);
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
    return '{ "begin_datum": "$startDate", "eind_datum": "$endDate", "onderwerp": "$subject", "streefcijfer": "$targetFigure"}';
  }

  DateTime get getBeginingDate {
    List<String> splittedDate = startDate.split('/');
    if (splittedDate[1].length < 2) {
      splittedDate[1] = '0' + splittedDate[1];
    }
    if (splittedDate[0].length < 2) {
      splittedDate[0] = '0' + splittedDate[0];
    }
    return DateFormat("dd/MM/yyyy").parse(startDate);
  }

  DateTime get getEndingDate {
    List<String> splittedDate = endDate.split('/');
    if (splittedDate[1].length < 2) {
      splittedDate[1] = '0' + splittedDate[1];
    }
    if (splittedDate[0].length < 2) {
      splittedDate[0] = '0' + splittedDate[0];
    }
    return DateFormat("dd/MM/yyyy").parse(endDate);
  }

  String get getSubject {
    return subject;
  }

  double get getTargetGrade {
    return targetFigure.toDouble();
  }
}

class WeekReflection {
  String date;
  int weeknumber;
  double rating;
  String learningGoal;
  String preview;
  WeekReflection(this.date, this.weeknumber, this.rating, this.learningGoal,
      this.preview);
  factory WeekReflection.fromJson(Map<String, dynamic> parsedJson) {
    return WeekReflection(
        parsedJson['datum'],
        parsedJson['weeknummer'],
        parsedJson['rating'].toDouble(),
        parsedJson['leerdoel'],
        parsedJson['vooruitblik']);
  }
  @override
  String toString() {
    return '{"datum": "$date", "rating": $weeknumber, "rating": ${rating.toInt()}, "leerdoel": "$learningGoal", "vooruitblik": "$preview"}';
  }

  DateTime get getDate {
    List<String> gesplitst = date.split('/');
    if (gesplitst[1].length < 2) {
      gesplitst[1] = '0' + gesplitst[1];
    }
    if (gesplitst[0].length < 2) {
      gesplitst[0] = '0' + gesplitst[0];
    }

    String reassemble = gesplitst[2] + gesplitst[1] + gesplitst[0];
    DateTime result = DateTime.parse(reassemble);
    return result;
  }

  int get getWeekNumber {
    return weeknumber;
  }

  double get getsubject {
    return rating;
  }

  String get getLearningGoal {
    return learningGoal;
  }

  String get getPreview {
    return preview;
  }
}

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var log = LogController();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if ((user == null || user == "") && id != "") {
      var groupApi = url +
          "Login?name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

      final response = await http.get(
        Uri.parse(groupApi),
      );

      var data = jsonDecode(response.body);

      if (data['response'] != null) {
        if (data['response'] == "Logged in") {
          log.record("Logged in");
          return true;
        }
      }
      return false;
    }
    return false;
  }

  Future<bool> getOldInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    var groupApi = url +
        "GetReflecties?=&name=$user&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

    final response = await http.get(
      Uri.parse(groupApi),
    );

    var data = jsonDecode(response.body);

    if (data != null) {

      if (data['reflecties'] != null) {
        List<String> reflecties = [];
        for (Map<String, dynamic> r in data['reflecties']) {
          DailyReflection re = DailyReflection.fromJson(r);
          reflecties.add(re.toString());
        }
        prefs.setStringList('daily_reflection', reflecties);
      }
      if (data['leerdoel'] != null) {
        List<String> learningGoal = [];
        for (Map<String, dynamic> l in data['leerdoel']) {
          LearningGoal le = LearningGoal.fromJson(l);
          learningGoal.add(le.toString());
        }
        prefs.setStringList('leerdoel', learningGoal);
      }
      if (data['week_reflectie'] != null) {
        List<String> weekReflectie = [];
        for (Map<String, dynamic> w in data['week_reflectie']) {
          WeekReflection we = WeekReflection.fromJson(w);
          weekReflectie.add(we.toString());
        }
        prefs.setStringList('week_reflectie', weekReflectie);
      }
      return true;
    }
    return false;
  }

  Future<bool> syncUp(userName, password, data) async {
    var groupApi = url +
        "UpdateUser?name=$userName&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: data);
    if (response.body != "") {
      var responseText = jsonDecode(response.body);

      if (responseText["response"] == "Log updated") {
        return true;
      } else {
        return false;
      }
    }

    return true;
  }

  Future<bool> logUp(userName, password, logs) async {
    var groupApi = url +
        "UpdateLogs?name=$userName&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: logs);
    var data = jsonDecode(response.body);

    if (data['response'] != null) {
      if (data['response'] == "Log updated") {
        log.record("Updated log");
        return true;
      }
    }
    return false;
  }
}
