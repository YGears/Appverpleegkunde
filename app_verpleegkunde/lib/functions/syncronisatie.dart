import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/functions/log_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/functions/api.dart';
// import "list_controller.dart";


// in order to use the group api, replace privateApi with groupApi on line 30, 
// comment out line 32
class Syncronisation {

  static Future<bool> login(String user_name, String password) async{
    final prefs = await SharedPreferences.getInstance();      
    prefs.setString('user', user_name);
    prefs.setString('password', password);
    return true;
  }

  static Future<bool> send_log_data()async{
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();
  
    log_controller log_control = log_controller();

    var data = await log_control.get();

    var json_data = "[";
    for(var log in data){
      json_data += log + ",";
    }
    json_data += "]";
    

    // var name =  prefs.getString('user');
    // var password = prefs.getString('password');

    print(json_data);
    return true;
    // return api.logUp(name, password, json_data);
  }
  
  static Future<bool> syncUp() async{
    // var log_save_controller = list_controller("syncronisation");
    final prefs = await SharedPreferences.getInstance();
    Api api = new Api();

    

    var name =  prefs.getString('user');
    var password = prefs.getString('password');
    var reflectie_json = prefs.getStringList('daily_reflection') ?? [];
    var leerdoel_json = prefs.getStringList('leerdoel') ?? [];
    var week_reflectie_json = prefs.getStringList('week_reflectie') ?? [];
    

    // if(await api.syncUp(name, password, reflectie_json, leerdoel_json, week_reflectie_json)){
      if(await send_log_data()){
          return true;
        }
      // }
    return false;
  }
}
