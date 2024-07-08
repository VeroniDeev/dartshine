import 'create_project.dart';

Future<void> main(List<String> args) async {
  if (args[0] == 'create' && args.length == 2) {
    await createProject(args[1]);
  }
}
