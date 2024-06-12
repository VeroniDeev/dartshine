import 'package:dartshine/src/templates/lexer/token.dart';

class RootNode {
  List<dynamic> children = [];

  void addChild(dynamic child) {
    children.add(child);
  }
}

class ForNode {
  String variableName = '';
  String collectionName = '';
  List<dynamic> children = [];

  void addVariableName(String name) {
    variableName = name;
  }

  void addCollectionName(String name) {
    collectionName = name;
  }

  void addChild(dynamic child) {
    children.add(child);
  }
}

class TextNode {
  String content = '';

  void addContent(String value) {
    content = value;
  }
}

class ConditionNode {
  List<dynamic> childrenTrue = [];
  List<dynamic> childrenFalse = [];
  List<Token> condition = [];

  void addChildTrue(dynamic child) {
    childrenTrue.add(child);
  }

  void addChildFalse(dynamic child) {
    childrenFalse.add(child);
  }

  void addCondition(List<Token> conditionList) {
    condition = conditionList;
  }
}

class VariableNode {
  String variableName = '';

  void addVariableName(String name) {
    variableName = name;
  }
}
