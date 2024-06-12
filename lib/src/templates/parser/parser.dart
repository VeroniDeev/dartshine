import 'package:dartshine/src/templates/lexer/token.dart';

class Parser {
  bool error = false;
  Map<String, dynamic> result = {};
  int index = 0;
  List<Token> tokens;

  Parser({required this.tokens});

  void parser() {
    while (index < tokens.length) {
      Token token = tokens[index];
      if (token.token == TokenEnum.openCommandBalise) {
        parseCommand(node: result);
      } else if (token.token == TokenEnum.openVariableBalise) {
        parseVariable(node: result);
      }

      index++;
    }
  }

  void parseCommand({required Map<String, dynamic> node}) {
    index++;
    Token token = tokens[index];

    if(token.token == TokenEnum.ifCommand){}
  }

  void parseVariable({required Map<String, dynamic> node}) {}

  void parseCondition({required Map<String, dynamic> node}) {}

  void parseFor() {}

  void parseContent() {}
}
