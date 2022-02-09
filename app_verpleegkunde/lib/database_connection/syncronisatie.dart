import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:intl/intl.dart';
import '../screens/week_reflection/week_reflection_class.dart';
import '../screens/learning_goal/learning_goal.dart';
import '../controllers/list_controller.dart';
import '../controllers/log_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

class Syncronisation {
  static Future<bool> login(String userName, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', userName);
    prefs.setString('password', password);
    return true;
  }

  static Future<bool> sendLogData() async {
    final prefs = await SharedPreferences.getInstance();
    Api api = Api();

    LogController logControl = LogController();

    var data = await logControl.get();
    var name = prefs.getString('user');
    var password = prefs.getString('password');
    return api.logUp(name, password, data.toString());
  }

  static Future<bool> syncUp() async {
    final prefs = await SharedPreferences.getInstance();
    var syncCheck = prefs.getString("syncCheck");

    int timeDiff = 1;

    if (syncCheck != null) {
      timeDiff = DateTime.now()
          .difference(
              DateTime.parse(jsonDecode(syncCheck.toString())["timestamp"]))
          .inHours;
    }

    if (timeDiff > 0) {
      Api api = Api();
      var time = DateTime.now();
      var today = DateFormat('yyyy-MM-dd kk:mm:ss').format(time).toString();

      var name = prefs.getString('user');
      var password = prefs.getString('password');
      var reflectieJson = await ListController("daily_reflection").getList;
      List<DailyReflection> reflections = [];
      for (String i in reflectieJson) {
        reflections.add(DailyReflection.fromJson(jsonDecode(i)));
      }
      var leerdoelJson = await ListController("leerdoel").getList;
      List<LearningGoal> leerdoel = [];
      for (String i in leerdoelJson) {
        leerdoel.add(LearningGoal.fromJson(jsonDecode(i)));
      }
      var weekReflectieJson = await ListController("week_reflectie").getList;
      List<WeekReflection> weekreflecties = [];
      for (String i in weekReflectieJson) {
        weekreflecties.add(WeekReflection.fromJson(jsonDecode(i)));
      }

      var data = "{";
      data += "\"reflectie\":[";
      for (DailyReflection i in reflections) {
        data += i.toString();
        if (i != reflections.last) {
          data += ",";
        }
      }

      data += "], \"leerdoel\":[";
      for (LearningGoal i in leerdoel) {
        data += i.toString();
        if (i != leerdoel.last) {
          data += ",";
        }
      }

      data += "], \"weekreflectie\":[";
      for (WeekReflection i in weekreflecties) {
        data += i.toString();
        if (i != weekreflecties.last) {
          data += ",";
        }
      }
      data += "]}";

      if (await api.syncUp(name, password, data.toString())) {
        if (await sendLogData()) {
          prefs.setString("syncCheck", "{\"timestamp\":\"$today\"}");
          prefs.setStringList("log", [
            "{\"timestamp\": \"" +
                time.year.toString() +
                "-" +
                time.month.toString() +
                "-" +
                time.day.toString() +
                "T" +
                time.hour.toString() +
                ":" +
                time.minute.toString() +
                ":" +
                time.second.toString() +
                "\", \"action\": \"syncronised with DB\"}"
          ]);
          return true;
        }
      }
    }
    return false;
  }
}
