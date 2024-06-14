class Render {
  List<Map<String, dynamic>> parserResult;
  Map<String, dynamic> variableList;
  List<String> sources;
  int padding = 0;

  Render(
      {required this.parserResult,
      required this.variableList,
      required this.sources});

  void render() {
    for (Map<String, dynamic> map in parserResult) {
      String data = '';

      if (map['type'] == 'variable') {
        data = variableRender(map['name']);
        sources.replaceRange(map['startPosition'] + padding,
            map['endPosition'] + 1 + padding, data.split(''));

        int startPosition = map['startPosition'];
        int endPosition = map['endPosition'];

        padding += data.length - (endPosition + 1 - startPosition);
      }
    }
  }

  String variableRender(String variableName) {
    String data = '';
    String value = variableList[variableName];

    data += value;

    return data;
  }
}
