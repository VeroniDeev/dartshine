import 'package:dartshine/src/templates/lexer/token.dart';

class Render {
  List<Map<String, dynamic>> parserResult;
  Map<String, dynamic> variableList;
  List<String> sources;
  int padding = 0;
  bool error = false;

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

        sources.replaceRange(
            startPosition + padding, endPosition + 1 + padding, data.split(''));

        padding += data.length - (endPosition + 1 - startPosition);
      } else if (map['type'] == 'condition') {
        data = conditionRender(map);

        int startPosition = map['startPosition'];
        int endPosition = map['endPosition'];

        sources.replaceRange(
            startPosition + padding, endPosition + 1 + padding, data.split(''));

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

  String conditionRender(Map<String, dynamic> conditionParserResult) {
    StringBuffer data = StringBuffer();

    bool result =
        parseConditionResult(conditionList: conditionParserResult['condition']);

    List<Map<String, dynamic>> childrenList = [];

    if (result) {
      childrenList = conditionParserResult['trueCondition'];
    } else {
      childrenList = conditionParserResult['falseCondition'];
    }

    for (Map<String, dynamic> children in childrenList) {
      if (children['type'] == 'text') {
        data.write(children['value']);
      } else if (children['type'] == 'variable') {
        String result = variableRender(children['name']);
        data.write(result);
      }
    }

    return data.toString();
  }

  bool parseConditionResult({required List<Token> conditionList}) {
    bool result = false;

    if (conditionList.length < 3) {
      error = true;
      return false;
    }

    if (conditionList[0].token == TokenEnum.variableName ||
        conditionList[0].token == TokenEnum.stringValue) {
      result = parseStringCondition(conditionList: conditionList);
    } else {
      result = parseIntCondition(conditionList: conditionList);
    }

    return result;
  }

  bool parseStringCondition({required List<Token> conditionList}) {
    bool result = false;

    switch (conditionList[1].value) {
      case '==':
        result = conditionList[0].value == conditionList[2].value;
        break;
      case '!=':
        result = conditionList[0].value != conditionList[2].value;
        break;
    }

    return result;
  }

  bool parseIntCondition({required List<Token> conditionList}) {
    bool result = false;

    if (int.tryParse(conditionList[0].value!) == null ||
        int.tryParse(conditionList[2].value!) == null) {
      error = true;
      return false;
    }

    int firstCondition = int.parse(conditionList[0].value!);
    int secondCondition = int.parse(conditionList[2].value!);

    switch (conditionList[1].value) {
      case '==':
        result = firstCondition == secondCondition;
        break;
      case '!=':
        result = firstCondition != secondCondition;
        break;
      case '<=':
        result = firstCondition <= secondCondition;
        break;
      case '>=':
        result = firstCondition >= secondCondition;
        break;
      case '<':
        result = firstCondition < secondCondition;
        break;
      case '>':
        result = firstCondition > secondCondition;
        break;
    }

    return result;
  }
}
