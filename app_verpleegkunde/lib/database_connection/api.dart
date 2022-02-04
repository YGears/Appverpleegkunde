import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/screens/daily_reflection/daily_reflection.dart';
import 'package:flutter_application_1/screens/learning_goal/learning_goal.dart';
import '../screens/week_reflection/week_reflection_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/log_controller.dart';
import 'package:http/http.dart' as http;

class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var logger = log_controller();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    if ((user == null || user == "") && id != "") {
      Uri apiUrl = Uri.parse(url + "Login?name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key");

      final response = await http.get(
       apiUrl,
      );

      var responseData = jsonDecode(response.body);

      if (responseData['response'] != null) {
        if (responseData['response'] == "Logged in") {
          logger.record("Logged in");
          return true;
        }
      }
      return false;
    }
    return false;
  }
  
  saveDataFromServer(data, prefs, listName){
      if (data[listName] != null) {
        List<String> dataList = [];

        for (Map<String, dynamic> entry in data[listName]) {
          switch (listName) {
            case "daily_reflection":
              dataList.add(daily_reflection.fromJson(entry).toString());
              break;
            case "leerdoel":
              dataList.add(LearningGoal.fromJson(entry).toString());
              break;
            case "week_reflectie":
              dataList.add(WeekReflection.fromJson(entry).toString());
              break;
            default:
          }
        }
        
        prefs.setStringList(listName, dataList);
      }
  }

  Future<bool> getOldInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    Uri apiUrl =  Uri.parse(url + "GetReflecties?=&name=$user&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key");

    final response = await http.get(apiUrl);

    var data = jsonDecode(response.body);

    if (data != null) {
      saveDataFromServer(data, prefs, "daily_reflection");
      saveDataFromServer(data, prefs, "leerdoel");
      saveDataFromServer(data, prefs, "week_reflectie");
      return true;
    }
    return false;
  }

  Future<bool> syncUp(userName, password, data) async {
    Uri apiUrl = Uri.parse(url + "UpdateUser?name=$userName&password=$password&subscription-key=$key");

    final response = await http.post(apiUrl, body: data);
    
    if (response.body != "") {
      var responseText = jsonDecode(response.body);

      if (responseText["response"] == "Log updated") {
        logger.record("Updated reflections");
        return true;
      }
    }

    return false;
  }

  Future<bool> logUp(userName, password, logs) async {
    Uri apiUrl = Uri.parse(url + "UpdateLogs?name=$userName&password=$password&subscription-key=$key");

    final response = await http.post(apiUrl, body: logs);

    var data = jsonDecode(response.body);

    if (data['response'] != null) {
      if (data['response'] == "Log updated") {
        logger.record("Updated log");
        return true;
      }
    }
    return false;
  }
}
