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

        int startPosition = map['startPosition'];
        int endPosition = map['endPosition'];

        sources.replaceRange(
            startPosition + padding, endPosition + 1 + padding, data.split(''));

        padding += data.length - (endPosition + 1 - startPosition);
      } else if (map['type'] == 'for') {
        data = forRender(map);

        int startPosition = map['startPosition'];
        int endPosition = map['endPosition'];

        sources.replaceRange(startPosition + padding, endPosition + 1 + padding, data.split(''));

        padding += data.length - (endPosition + 1 - startPosition);
      }
    }
  }

  String variableRender(String variableName) {
    StringBuffer data = StringBuffer();
    String value = variableList[variableName];

    data.write(value);

    return data.toString();
  }

  String forRender(Map<String, dynamic> forParserResult) {
    StringBuffer data = StringBuffer();
    List<dynamic> values = variableList[forParserResult['collection']];

    for (dynamic value in values) {
      variableList[forParserResult['variable']] = value;

      List<Map<String, dynamic>> childrenList = forParserResult['children'];

      for (Map<String, dynamic> children in childrenList) {
        if (children['type'] == 'text') {
          data.write(children['value']);
        } else if (children['type'] == 'variable') {
          String result = variableRender(children['name']);
          data.write(result);
        }
      }
    }

    return data.toString();
  }
}
