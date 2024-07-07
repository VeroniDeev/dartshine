import 'dart:io';

List<String> readFile(String path) {
  final File file = File(path);
  final String content = file.readAsStringSync();

  return content.split('');
}