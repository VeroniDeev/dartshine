import 'dart:io';
import 'package:path/path.dart' as p;
import 'dart:isolate';

Future<String> readFile(String path) async {
  var resolvedUri =
      await Isolate.resolvePackageUri(Uri.parse('package:dartshine/$path'));
  var filePath = p.fromUri(resolvedUri);
  var file = File(filePath);
  return await file.readAsString();
}

Future<void> createProject(String name) async {
  String currentPath = Directory.current.path;
  String projectPath = p.join(currentPath, name);
  Directory newProjectDir = await Directory(projectPath).create();

  await Directory(p.join(projectPath, 'lib')).create();
  await Directory(p.join(projectPath, 'lib/routes')).create();
  await Directory(p.join(projectPath, 'lib/controllers')).create();
  await Directory(p.join(projectPath, 'lib/orm')).create();
  await Directory(p.join(projectPath, 'assets')).create();

  String indexFileContent = await readFile('init/assets/index.html');
  String styleFileContent = await readFile('init/assets/style.css');
  String controllerFileContent = await readFile('init/root_controller.dart');
  String routesFileContent = await readFile('init/routes.dart');
  String mainFileContent = await readFile('init/main.dart');
  String pubsecFileContent = await readFile('init/pubsec.yaml');
  String analysisFileContent = await readFile('init/analysis_options.yaml');
  String userFileContent = await readFile('init/user.dart');
  String ormsFileContent = await readFile('init/orms.dart');

  controllerFileContent = controllerFileContent.replaceAll('{}', name);
  routesFileContent = routesFileContent.replaceAll('{}', name);
  mainFileContent = mainFileContent.replaceAll('{}', name);
  pubsecFileContent = pubsecFileContent.replaceAll('{}', name);

  File indexFile = File(p.join(projectPath, 'assets/index.html'));
  File mainFile = File(p.join(projectPath, 'lib/main.dart'));
  File controllerFile = File(p.join(projectPath, 'lib/controllers/root_controller.dart'));
  File routesFile = File(p.join(projectPath, 'lib/routes/routes.dart'));
  File pubsecFile = File(p.join(projectPath, 'pubsec.yaml'));
  File analysisFile = File(p.join(projectPath, 'analysis_options.yaml'));
  File userFile = File(p.join(projectPath, 'lib/orm/user.dart'));
  File ormsFile = File(p.join(projectPath, 'lib/orm/orms.dart'));
  File styleFile = File(p.join(projectPath, 'assets/style.css'));

  await indexFile.create();
  await styleFile.create();
  await mainFile.create();
  await controllerFile.create();
  await routesFile.create();
  await pubsecFile.create();
  await analysisFile.create();
  await userFile.create();
  await ormsFile.create();

  await indexFile.writeAsString(indexFileContent);
  await styleFile.writeAsString(styleFileContent);
  await mainFile.writeAsString(mainFileContent);
  await controllerFile.writeAsString(controllerFileContent);
  await routesFile.writeAsString(routesFileContent);
  await pubsecFile.writeAsString(pubsecFileContent);
  await analysisFile.writeAsString(analysisFileContent);
  await userFile.writeAsString(userFileContent);
  await ormsFile.writeAsString(ormsFileContent);
}