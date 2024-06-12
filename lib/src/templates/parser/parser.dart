import 'package:dartshine/src/templates/lexer/token.dart';
import 'package:dartshine/src/templates/parser/ast.dart';

class Parser {
  RootNode node = RootNode();
  List<Token> tokens;
  int index = 0;
  bool _error = false;

  Parser({required this.tokens});

  void parser() {
    while (index < tokens.length) {
      if (tokens[index].token == TokenEnum.openCommandBalise) {
        parseCommand(node: node);
      } else if (tokens[index].token == TokenEnum.openVariableBalise) {
        parseVariable(node: node);
      }

      if (_error) {
        return;
      }

      index++;
    }
  }

  void parseVariable({required dynamic node, bool? condition}) {
    index++;
    Token token = tokens[index];

    if (token.token == TokenEnum.variableName) {
      VariableNode variableNode = VariableNode();
      variableNode.addVariableName(token.value!);
      pushNode(node: node, newNode: variableNode);
    } else {
      _error = true;
      return;
    }

    index++;
    token = tokens[index];

    if (token.token != TokenEnum.closeVariableBalise) {
      _error = true;
    }
    return;
  }

  void parseCommand({required dynamic node, bool? condition}) {
    index++;
    Token token = tokens[index];

    if (token.token == TokenEnum.forCommand) {
      parseFor(node);
    } else if (token.token == TokenEnum.ifCommand) {
      parseCondition(node: node, condition: true);
    } else if (token.token == TokenEnum.elseCommand) {
      parseCondition(node: node, condition: false);
    } else {
      _error = true;
      return;
    }
  }

  void parseFor(dynamic node) {
    index++;
    Token token = tokens[index];
    ForNode forNode = ForNode();

    if (token.token == TokenEnum.variableName) {
      forNode.addVariableName(token.value!);
    } else {
      _error = true;
      return;
    }

    index++;
    token = tokens[index];

    if (token.token != TokenEnum.inCommand) {
      _error = true;
      return;
    }

    index++;
    token = tokens[index];

    if (token.token == TokenEnum.variableName) {
      forNode.addCollectionName(token.value!);
    } else {
      _error = true;
      return;
    }

    index++;
    token = tokens[index];

    if (token.token != TokenEnum.closeCommandBalise) {
      _error = true;
      return;
    }

    while (true) {
      index++;
      token = tokens[index];

      if (token.token == TokenEnum.openBrace) {
        parseContent(node: forNode);
      } else if (token.token == TokenEnum.openCommandBalise &&
          tokens[index + 1].token == TokenEnum.endForCommand) {
        pushNode(node: node, newNode: forNode);
        break;
      } else if (token.token == TokenEnum.openCommandBalise &&
          tokens[index + 1].token != TokenEnum.endForCommand) {
        parseCommand(node: forNode);
      } else if (token.token == TokenEnum.openVariableBalise) {
        parseVariable(node: forNode);
      } else {
        _error = true;
        return;
      }
    }
  }

  void parseCondition({required dynamic node, required bool condition}) {
    index++;
    Token token = tokens[index];
    ConditionNode conditionNode = ConditionNode();
    List<Token> tokenList = [];

    if (token.token == TokenEnum.variableName) {
      tokenList.add(token);
    }

    index++;
    token = tokens[index];

    if (token.token == TokenEnum.operator) {
      tokenList.add(token);
    }

    index++;
    token = tokens[index];

    if (token.token == TokenEnum.variableName) {
      tokenList.add(token);
    }

    index++;
    token = tokens[index];

    if (token.token != TokenEnum.closeCommandBalise) {
      _error = true;
      return;
    }

    conditionNode.addCondition(tokenList);

    while (true) {
      index++;
      token = tokens[index];

      if (token.token == TokenEnum.openBrace) {
        parseContent(node: conditionNode, condition: condition);
      } else if (token.token == TokenEnum.openCommandBalise &&
          tokens[index + 1].token == TokenEnum.endIfCommand) {
        break;
      } else if (token.token == TokenEnum.openCommandBalise) {
        parseCommand(node: conditionNode);
      } else if (token.token == TokenEnum.openVariableBalise) {
        parseVariable(node: conditionNode);
      }
    }

    pushNode(node: node, newNode: conditionNode, condition: condition);
  }

  void parseContent({dynamic node, bool? condition}) {
    TextNode textNode = TextNode();

    while (true) {
      index++;
      Token token = tokens[index];

      if (token.token == TokenEnum.content) {
        textNode.addContent(token.value!);
      } else if (token.token == TokenEnum.closeBrace) {
        break;
      } else {
        _error = true;
        return;
      }
    }

    pushNode(node: node, newNode: textNode, condition: condition);
  }

  void pushNode(
      {dynamic node, dynamic newNode, Token? token, bool? condition}) {
    if (node is RootNode) {
      node.addChild(newNode);
    } else if (node is ForNode) {
      node.addChild(newNode);
    } else if (node is ConditionNode) {
      if (condition!) {
        node.addChildTrue(newNode);
      } else {
        node.addChildFalse(newNode);
      }
    }
  }
}
