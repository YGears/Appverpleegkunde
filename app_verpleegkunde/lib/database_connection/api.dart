import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Logging/log_controller.dart';
import 'package:http/http.dart' as http;

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

// in order to use the group api, replace privateApi with groupApi on line 30,
// comment out line 32
class Api {
  var key = "77375a9effb64452bf5d2952cf76ee80";
  var log = log_controller();
  var url = "https://nurseitapi.azure-api.net/";

  Future<bool> login(id, password) async {
    // return true;
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if((user == null || user == "" ) && id != ""){
      var groupApi = url + "Login?name=$id&password=KoekjesZijnGemaaktVanDeeg&subscription-key=$key";
      
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

  Future<bool> syncUp(user_name, password, data) async{
    var groupApi = url + "UpdateUser?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(
      Uri.parse(groupApi),
      body:data
    );
    
    var responseText = jsonDecode(response.body); 
    
    if(responseText["response"] == "Log updated"){
      return true; 
    }else{
      return false;
    }
  }

  Future<bool> logUp(user_name, password, logs) async{
    var groupApi = url + "UpdateLogs?name=$user_name&password=$password&subscription-key=$key";

    final response = await http.post(
      Uri.parse(groupApi),
      body: logs
    );
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
