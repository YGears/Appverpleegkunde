import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:flutter_application_1/screens/learning_goal/choose_learning_goal.dart';
import 'package:intl/intl.dart';
import '../controllers/list_controller.dart';
import '../controllers/log_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
// import "list_controller.dart";

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Syncronisation {
  static Future<bool> login(String userName, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', userName);
    prefs.setString('password', password);
    return true;
  }

  static Future<bool> send_log_data() async {
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();

    log_controller logControl = log_controller();

    var data = await logControl.get();
    // print(data);
    // var json_data = "[";
    // for(var log in data){
    //   json_data += log + ",";
    // }
    // json_data += "]";
    // print("0");
    // print(json_data);

    // return true;
    var name = prefs.getString('user');
    var password = prefs.getString('password');
    return api.logUp(name, password, data.toString());
  }

  static Future<bool> syncUp() async {
    final prefs = await SharedPreferences.getInstance();
    var syncCheck = prefs.getString("syncCheck");
    var timeDiff = 1;

    if (syncCheck != null) {
      timeDiff = DateTime.now()
          .difference(
              DateTime.parse(jsonDecode(syncCheck.toString())["timestamp"]))
          .inHours;
    }

    // if (time_diff > 0) {
    if (true) {
      Api api = new Api();
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

      print("Data: " + data);

      if (await api.syncUp(name, password, data.toString())) {
        if (await send_log_data()) {
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
