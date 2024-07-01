import 'package:dartshine/src/controllers/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';

class DartshineController{
  Response get(){
    return Response(status: Status.methodNotAllowed, response: "");
  }

  Response post(){
    return Response(status: Status.methodNotAllowed, response: "");
  }

  Response put(){
    return Response(status: Status.methodNotAllowed, response: "");
  }

  Response delete(){
    return Response(status: Status.methodNotAllowed, response: "");
  }

  Response patch(){
    return Response(status: Status.methodNotAllowed, response: "");
  }
}