import 'package:dartshine/dartshine.dart';
import 'package:dartshine/init/root_controller.dart';

class Routes extends DartshineRoute {
  @override
  List<Map<String, dynamic>> get urls => [
        {
          'path': '/',
          'controller': RootController(),
          'method': ['GET', 'POST', 'OPTION']
        }
      ];
}
