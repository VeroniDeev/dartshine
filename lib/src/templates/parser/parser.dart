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

    if (token.token == TokenEnum.ifCommand) {
      parseCondition(node: node, condition: true);
    } else if (token.token == TokenEnum.elseCommand) {
      parseCondition(node: node, condition: false);
    } else if (token.token == TokenEnum.forCommand) {
      parseFor(node: node);
    }
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

    if (token.token != TokenEnum.closeVariableBalise) {
      error = true;
      return;
    }

    node.add(result);
  }

  void parseIfCondition({required List<Map<String, dynamic>> node}) {
    List<Token> tokenList = [];

    while (true) {
      index++;
      Token token = tokens[index];

      if (token.token == TokenEnum.closeCommandBalise) {
        node.add({'condition': tokenList});
        break;
      } else if (token.token == TokenEnum.variableName ||
          token.token == TokenEnum.operator) {
        tokenList.add(token);
      } else {
        error = true;
        return;
      }
    }
  }

  void parseCondition(
      {required List<Map<String, dynamic>> node, required bool condition}) {
    Token token = tokens[index];

    if (condition) {
      parseIfCondition(node: node);

      if (error) {
        return;
      }
    } else {
      index++;
      token = tokens[index];

      if (token.token != TokenEnum.closeCommandBalise) {
        error = true;
        return;
      }
    }

    List<Map<String, dynamic>> children = [];

    while (true) {
      token = tokens[index];

      if (token.token == TokenEnum.openCommandBalise &&
          tokens[index + 1].token == TokenEnum.endIfCommand) {
        break;
      } else if (token.token == TokenEnum.openCommandBalise &&
          tokens[index + 1].token == TokenEnum.elseCommand) {
        parseCondition(node: node, condition: false);
        break;
      } else if (token.token == TokenEnum.openVariableBalise) {
        parseVariable(node: children);
      } else if (token.token == TokenEnum.openCommandBalise) {
        parseCommand(node: children);
      } else if (token.token == TokenEnum.openBrace) {
        index++;
        token = tokens[index];

        if (token.token == TokenEnum.content &&
            tokens[index + 1].token == TokenEnum.closeBrace) {
          children.add({'type': 'text', 'value': token.value});
        } else {
          error = true;
          return;
        }
      }

      index++;
    }

    if (condition) {
      node.add({'trueCondition': children});
    } else {
      node.add({'falseCondition': children});
    }
  }

  void parseFor({required List<Map<String, dynamic>> node}) {}

  void parseContent() {}
}
