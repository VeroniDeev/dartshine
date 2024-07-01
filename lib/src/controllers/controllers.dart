import 'package:dartshine/src/controllers/response.dart';
import 'package:dartshine/src/http/serialization/status.dart';

class DartshineController{
  Response get(){
    return Response(status: Status.notFound, response: "");
  }

  Response post(){
    return Response(status: Status.notFound, response: "");
  }

  Response put(){
    return Response(status: Status.notFound, response: "");
  }

  Response delete(){
    return Response(status: Status.notFound, response: "");
  }

  Response patch(){
    return Response(status: Status.notFound, response: "");
  }
}