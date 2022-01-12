import 'dart:async';
import 'dart:convert';
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
  Future<bool> login(id, password) async {
    var privateApi = "https://iabamun.nl/game/lab-andre/api/index.php/login";
    final response = await http.post(
      Uri.parse(privateApi),
      headers:{'Ocp-Apim-Subscription-Key': 'KEY' },
      body: jsonEncode(<String, String>{"name": id, "password": password, }),
    );
    
    //azure api
    // var groupApi = "https://nurse-it-api.azure-api.net/Nurse-IT/Login?=&name=$id&password=KoekjesZijnGemaaktVanDeeg";
    // final response = await http.post(
    //   Uri.parse(groupApi),
    //   headers:{'Ocp-Apim-Subscription-Key': 'KEY' },
    //   body: jsonEncode(<String, String>{"name": id, "password": password, }),
    // );

    var data = jsonDecode(response.body);

    if (data['response'] != null) {
      if (data['response'] == "Logged in") {
        return true;
      }
    }
    return false;
  }
}
