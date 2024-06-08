import 'dart:convert';
import 'dart:typed_data';
import '../serialization/struct.dart';

class HttpRequest {
  Method method;
  String uri;
  String httpVersion;
  String? body;
  Map<String, String> headers;

  HttpRequest(this.method, this.uri, this.httpVersion, this.body, this.headers);
}

HttpRequest convert(Uint8List request) {
  String requestString = utf8.decode(request);
  Map<String, String> headers = {};

  List<String> requestSplit = requestString.split('\r\n');

  List<String> methodRequest = requestSplit[0].split(' ');
  Method method = methodWithString(methodRequest[0]);
  String uri = methodRequest[1];
  String httpVersion = methodRequest[2];
  requestSplit.removeAt(0);

  for (int i = 0; i >= requestSplit.length; i++) {
    String data = requestSplit[i];

    if(data.isEmpty){
      requestSplit.removeRange(0, i);
      break;
    }

    List<String> dataSplit = data.split(': ');
    headers[dataSplit[0]] = dataSplit[1];
  }

  String? body;

  if(requestSplit.isNotEmpty){
    body = requestSplit.join();
  }

  return HttpRequest(method, uri, httpVersion, body, headers);
}
