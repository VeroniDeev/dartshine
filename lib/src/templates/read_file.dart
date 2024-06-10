import 'dart:io';

Future<List<String>> readFile(String path) async {
  final file = File(path);
  final content = await file.readAsString();

  return content.split('');
}