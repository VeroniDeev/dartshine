import 'package:dartshine/src/http/serialization/status.dart';

class Response{
  Status status;
  String response;

  Response({required this.status, required this.response});
}