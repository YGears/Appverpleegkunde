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

class WeekReflection {
  String datum;
  int weeknummer;
  double rating;
  String leerdoel;
  String vooruitblik;
  WeekReflection(this.datum, this.weeknummer, this.rating, this.leerdoel,
      this.vooruitblik);
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
    return '{"datum": "$datum", "rating": $weeknummer, "rating": ${rating.toInt()}, "leerdoel": "$leerdoel", "vooruitblik": "$vooruitblik"}';
  }

  DateTime get getDate {
    List<String> gesplitst = datum.split('/');
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
    return weeknummer;
  }

  double get getsubject {
    return rating;
  }

  String get getLearningGoal {
    return leerdoel;
  }

  String get getPreview {
    return vooruitblik;
  }
}

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var log = LogController();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    // return true;
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
    // return true;
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    var groupApi = url +
        "GetReflecties?=&name=$user&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

    final response = await http.get(
      Uri.parse(groupApi),
    );

    var data = jsonDecode(response.body);

    if (data != null) {
      print(response.body);

      if (data['reflecties'] != null) {
        List<String> reflecties = [];
        for (Map<String, dynamic> r in data['reflecties']) {
          DailyReflection re = DailyReflection.fromJson(r);
          reflecties.add(re.toString());
        }
        print(reflecties.toString());
        prefs.setStringList('daily_reflection', reflecties);
      }
      if (data['leerdoel'] != null) {
        List<String> leerdoel = [];
        for (Map<String, dynamic> l in data['leerdoel']) {
          LearningGoal le = LearningGoal.fromJson(l);
          leerdoel.add(le.toString());
        }
        // print(leerdoel.toString());
        prefs.setStringList('leerdoel', leerdoel);
      }
      if (data['week_reflectie'] != null) {
        List<String> week_reflectie = [];
        for (Map<String, dynamic> w in data['week_reflectie']) {
          WeekReflection we = WeekReflection.fromJson(w);
          week_reflectie.add(we.toString());
        }
        // print(week_reflectie.toString());
        prefs.setStringList('week_reflectie', week_reflectie);
      }
      print("Update completed");
      print(prefs.get("daily_reflection"));
      print(prefs.get("leerdoel"));
      print(prefs.get("week_reflectie"));
      return true;
    }
    return false;
  }

  Future<bool> syncUp(user_name, password, data) async {
    var groupApi = url +
        "UpdateUser?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: data);
    print(response.body);
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

  Future<bool> logUp(user_name, password, logs) async {
    var groupApi = url +
        "UpdateLogs?name=$user_name&password=$password&subscription-key=$key";

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
