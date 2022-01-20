import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/functions/api.dart';
// import "list_controller.dart";
import 'package:app_verpleegkunde/functions/api.dart';

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Syncronisation {

  static Future<bool> syncUp() async {
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();
    var name = prefs.getString('user');

    var password = prefs.getString('password');
    var reflectie_json = prefs.getStringList('daily_reflection') ?? [];
    var leerdoel_json = prefs.getStringList('leerdoel') ?? [];
    var week_reflectie_json = prefs.getStringList('week_reflectie') ?? [];

    print("JSON");
    print(name);
    print(password);
    print(reflectie_json);
    print(leerdoel_json);
    print(week_reflectie_json);

    // if(await api.syncUp(name, password, reflectie_json, leerdoel_json, week_reflectie_json)){
    //   return true;
    // }
    return false;
  }

  static Future<bool> login(String user_name, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // String? user = prefs.getString('user');
    // if(user == null){

    prefs.setString('user', user_name);
    prefs.setString('password', password);
    //   print("user $user_name logged in");
    //   return true;
    // }
    return false;
  }
}
