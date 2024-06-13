import 'package:dartshine/src/templates/lexer/token.dart';

class Parser {
  bool error = false;
  List<Map<String, dynamic>> results = [];
  int index = 0;
  List<Token> tokens;

  Parser({required this.tokens});

  void parser() {
    while (index < tokens.length) {
      Token token = tokens[index];
      if (token.token == TokenEnum.openCommandBalise) {
        parseCommand(node: results);
      } else if (token.token == TokenEnum.openVariableBalise) {
        parseVariable(node: results);
      }

      index++;
    }
  }

  void parseCommand({required List<Map<String, dynamic>> node}) {
    index++;
    Token token = tokens[index];

    if (token.token == TokenEnum.ifCommand) {}
  }

  void parseVariable({required List<Map<String, dynamic>> node}) {
    index++;
    Token token = tokens[index];
    Map<String, dynamic> result = {};

    if (token.token == TokenEnum.variableName) {
      result['type'] = 'variable';
      result['name'] = token.value!;
    } else {
      error = true;
      return;
    }

    index++;
    token = tokens[index];

    if(token.token != TokenEnum.closeVariableBalise){
      error = true;
      return;
    }

    node.add(result);
  }

  void parseCondition({required List<Map<String, dynamic>> node}) {}

  void parseFor() {}

  void parseContent() {}
}
