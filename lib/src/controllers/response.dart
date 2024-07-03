import 'package:dartshine/src/http/serialization/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';

class Response{
  Status status;
  String body;
  Map<String, String> headers = {};
  late HttpResponse response;

  Response({required this.status, required this.body}){
    response = HttpResponse(status: status, headers: headers, body: body);
  }
}