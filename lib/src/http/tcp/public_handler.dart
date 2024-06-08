import 'dart:io';
import 'dart:typed_data';
import '../serialization/response.dart';
import '../serialization/status.dart';
import '../serialization/request.dart';
import 'package:mime/mime.dart';

class PublicHandler {
  final Socket _client;
  final HttpRequest request;

  const PublicHandler(this._client, this.request);

  void sendHtml(String file, Status status, Map<String, String> headers) {
    headers['Content-Type'] = 'text/html';
    headers['Content-Length'] = '${file.length}';

    HttpResponse response =
        HttpResponse(status: status, headers: headers, body: file);
    response.createResponse();

    _client.write(response.response);
    _client.close();
  }

  void sendCss(String file, Status status, Map<String, String> headers){
    headers['Content-Type'] = 'text/css';
    headers['Content-Length'] = '${file.length}';

    HttpResponse response =
        HttpResponse(status: status, headers: headers, body: file);
    response.createResponse();

    _client.write(response.response);
    _client.close();
  }

  void sendJavascript(String file, Status status, Map<String, String> headers){
    headers['Content-Type'] = 'application/javascript';
    headers['Content-Length'] = '${file.length}';

    HttpResponse response =
        HttpResponse(status: status, headers: headers, body: file);
    response.createResponse();

    _client.write(response.response);
    _client.close();
  }

  void sendJson(String file, Status status, Map<String, String> headers) {
    headers['Content-Type'] = 'application/json';
    headers['Content-Length'] = '${file.length}';

    HttpResponse response =
        HttpResponse(status: status, headers: headers, body: file);
    response.createResponse();

    _client.write(response.response);
    _client.close();
  }

  Future<void> sendMedia(File file, Status status, Map<String, String> headers) async {
    Uint8List data = await file.readAsBytes();

    headers['Content-Type'] = lookupMimeType(file.path)!;
    headers['Content-Length'] = '${data.length}';

    HttpResponse response =
        HttpResponse(status: status, headers: headers);
    response.createResponse();

    _client.write(response.response);
    _client.add(data);
    _client.close();
  }
}
