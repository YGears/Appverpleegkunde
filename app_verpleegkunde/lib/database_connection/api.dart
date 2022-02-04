import 'dart:async';
import 'dart:convert';
import '../screens/learning_goal/learning_goal.dart';
import '../screens/week_reflection/week_reflection_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/log_controller.dart';
import 'package:http/http.dart' as http;
import '../screens/daily_reflection/daily_reflection.dart';
import 'response.dart';

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var logger = log_controller();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    if ((user == null || user == "") && id != "") {
      var groupApi = url + "Login?name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

      final response = await http.get(
        Uri.parse(groupApi),
      );

      var data = jsonDecode(response.body);

      if (data['response'] != null) {
        if (data['response'] == "Logged in") {
          logger.record("Logged in");
          return true;
        }
      }
      return false;
    }
    return false;
  }
  fill_with_data_if_empty(data, prefs, list_to_access){
      if (data[list_to_access] != null) {
        List<String> data_list = [];

        for (Map<String, dynamic> weekly_reflection in data[list_to_access]) {
          data_list.add(WeekReflection.fromJson(weekly_reflection).toString());
        }
        
        prefs.setStringList(list_to_access, data_list);
      }
  }

  Future<bool> getOldInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');

    var groupApi = url + "GetReflecties?=&name=$user&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";

    final response = await http.get(
      Uri.parse(groupApi),
    );

    var data = jsonDecode(response.body);

    if (data != null) {
      fill_with_data_if_empty(data, prefs, "daily_reflection");
      fill_with_data_if_empty(data, prefs, "leerdoel");
      fill_with_data_if_empty(data, prefs, "week_reflectie");
      return true;
    }
    return false;
  }

  Future<bool> syncUp(user_name, password, data) async {
    var groupApi = url + "UpdateUser?name=$user_name&password=$password&subscription-key=$key";

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

  Future<bool> logUp(user_name, password, logs) async {
    var groupApi = url + "UpdateLogs?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(Uri.parse(groupApi), body: logs);
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
