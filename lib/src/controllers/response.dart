import 'package:dartshine/src/http/serialization/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';

class Response {
  final Status status;
  final String body;
  final Map<String, String> headers = {};
  late HttpResponse response;

  Response({required this.status, this.body = ''}) {
    response = HttpResponse(status: status, headers: headers, body: body);
  }
}
