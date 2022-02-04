import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:flutter_application_1/screens/learning_goal/choose_learning_goal.dart';
import 'package:intl/intl.dart';
import '../screens/week_reflection/week_reflection_class.dart';
import '../screens/learning_goal/learning_goal.dart';
import '../controllers/list_controller.dart';
import '../controllers/log_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';
// import "list_controller.dart";

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Syncronisation {
  static Future<bool> login(String user_name, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user_name);
    prefs.setString('password', password);
    return true;
  }

  static Future<bool> send_log_data() async {
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();

    LogController log_control = LogController();

    var data = await log_control.get();
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
    var time_diff = 1;

    if (syncCheck != null) {
      time_diff = DateTime.now()
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
      var reflectie_json = await list_controller("daily_reflection").getList;
      List<daily_reflection> reflections = [];
      for (String i in reflectie_json) {
        reflections.add(daily_reflection.fromJson(jsonDecode(i)));
      }
      var leerdoel_json = await list_controller("leerdoel").getList;
      List<LearningGoal> leerdoel = [];
      for (String i in leerdoel_json) {
        leerdoel.add(LearningGoal.fromJson(jsonDecode(i)));
      }
      var week_reflectie_json = await list_controller("week_reflectie").getList;
      List<WeekReflection> weekreflecties = [];
      for (String i in week_reflectie_json) {
        weekreflecties.add(WeekReflection.fromJson(jsonDecode(i)));
      }

      var data = "{";
      data += "\"reflectie\":[";
      for (daily_reflection i in reflections) {
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
          print(list_controller("log").getList);
          return true;
        }
      }
    }
    return false;
  }
}
