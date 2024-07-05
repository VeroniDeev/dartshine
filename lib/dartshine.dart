library dartshine;

export 'src/controllers/controllers.dart';
export 'src/controllers/response.dart';
export 'src/orm/orm.dart';
export 'src/orm/types.dart';
export 'src/orm/db_type.dart';
export 'src/routes/routes.dart';
export 'src/templates/templates.dart';
export 'src/http/serialization/status.dart';


import 'package:dartshine/src/controllers/controllers.dart';
import 'package:dartshine/src/controllers/response.dart';
import 'package:dartshine/src/http/serialization/request.dart';
import 'package:dartshine/src/http/serialization/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';
import 'package:dartshine/src/http/serialization/struct.dart';
import 'package:dartshine/src/http/tcp/public_handler.dart';
import 'package:dartshine/src/http/tcp/server.dart';
import 'package:dartshine/src/routes/routes.dart';

class Server {
  int port;
  DartshineRoute routes;
  bool debug;

  Server({this.port = 8000, required this.routes, this.debug = true});

  void run() {
    ServerMaker server = ServerMaker(port);
    server.addOnRequest(onRequest);

    if(debug){
      print('Server run in port $port');
      print('Link: http://localhost:$port');
      print('to quit the server you must do CTRL + C');
    }

    server.run();
  }

  Future<void> onRequest(PublicHandler handler) async {
    HttpRequest request = handler.request;
    String uri = request.uri;

    if (uri.contains('.css') || uri.contains('.js') || uri.contains(RegExp(r'\.(png|jpg|jpeg|gif)$')) ) {
    } else {
      HttpResponse response = findRoutes(request);
      handler.sendHtml(response.body, response.status, response.headers);
    }
  }

  HttpResponse findRoutes(HttpRequest request) {
    Map<String, dynamic> route = routes.findUrl(request.uri);

    if (route.isEmpty) {
      return HttpResponse(status: Status.notFound, headers: {});
    }

    String methodString = methodToString(request.method);
    List<String> methodList = route['method'];

    if (!methodList.contains(methodString)) {
      return HttpResponse(status: Status.methodNotAllowed, headers: {});
    }

    DartshineController controller = route['controller'];
    Response response = Response(status: Status.internalServerError);

    switch (request.method) {
      case Method.get:
        response = controller.get();
        break;
      case Method.post:
        response = controller.post();
        break;
      case Method.patch:
        response = controller.patch();
        break;
      case Method.put:
        response = controller.put();
        break;
      case Method.delete:
        response = controller.delete();
        break;
      default:
    }

    return HttpResponse(status: response.status, headers: response.headers, body: response.body);
  }
}
