import 'package:dartshine/src/controllers/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';

class DartshineController{
  Response get(){
    return Response(status: Status.methodNotAllowed, body: "");
  }

  Response post(){
    return Response(status: Status.methodNotAllowed, body: "");
  }

  Response put(){
    return Response(status: Status.methodNotAllowed, body: "");
  }

  Response delete(){
    return Response(status: Status.methodNotAllowed, body: "");
  }

  Response patch(){
    return Response(status: Status.methodNotAllowed, body: "");
  }
}