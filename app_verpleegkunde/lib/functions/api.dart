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

class Api{
  Future<bool> login(id, password) async {
    final response = await http.post(
      Uri.parse('https://iabamun.nl/game/lab-andre/api/index.php/login'),
      body: jsonEncode(<String, String>{
        "name": id,
        "password": password,
      }),
    );
    var data = jsonDecode(response.body);

    if (data['response'] != null) {
      if (data['response'] == "Logged in") {
        return true;
      }
    }
    return false;
  }
}