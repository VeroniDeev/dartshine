import 'dart:io';

List<String> readFile(String path) {
  final file = File(path);
  final content = file.readAsStringSync();

  return content.split('');
}