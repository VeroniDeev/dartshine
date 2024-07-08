import '../serialization/status.dart';

class HttpResponse {
  final String httpVersion;
  final Status status;
  final Map<String, String> headers;
  late String response;
  final String body;

  HttpResponse(
      {this.httpVersion = 'HTTP/1.1',
      required this.status,
      required this.headers,
      this.body = ''});

  void createResponse() {
    response = "$httpVersion ${statusToString(status)}\r\n";

    headers.forEach((key, value) => response += "$key: $value\r\n");

    response += "\r\n";

    response += body;
  }
}
