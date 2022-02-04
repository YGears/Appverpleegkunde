
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
