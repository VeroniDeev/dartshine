import 'package:dartshine/src/templates/lexer/token.dart';

class Lexer {
  List<Token> tokens = [];
  List<String> sources;

  Lexer({required this.sources});

  void lexer() {
    String token = '';
    bool? isCommand;
    bool openbrace = false;

    for (String source in sources) {
      if(openbrace && !(source == '"' || source == '\'')){
        token += source;
        continue;
      }else if(openbrace && (source == '"' || source == '\'')){
        tokens.add(Token(token: TokenEnum.stringValue, value: token));
        tokens.add(Token(token: TokenEnum.guillemet));
        openbrace = false;
        token = '';
        continue;
      }

      if (source != ' ') {
        token += source;
      }

      if (source == '<') {
        token = '';
        token += source;
      } else if (token == '<\$') {
        token = '';
        tokens.add(Token(token: TokenEnum.openVariableBalise));
        isCommand = false;
      } else if (token == '<#') {
        token = '';
        tokens.add(Token(token: TokenEnum.openCommandBalise));
        isCommand = true;
      } else if (source == '#' || source == '\$') {
        token = '';
        token += source;
      } else if (token == '#>') {
        token = '';
        tokens.add(Token(token: TokenEnum.closeCommandBalise));
        isCommand = null;
      } else if (token == '\$>') {
        token = '';
        tokens.add(Token(token: TokenEnum.closeVariableBalise));
      } else if(token == '"' || token == '\''){
        openbrace = true;
        tokens.add(Token(token: TokenEnum.guillemet));
        token = '';
      }else if (source == ' ') {
        if (token.trim().isNotEmpty) {
          if (isCommand == true) {
            lexeCommand(token);
          } else if (isCommand == false) {
            tokens.add(Token(token: TokenEnum.variableName, value: token));
          }
        }
        token = '';
      }
    }
  }

  void lexeCommand(String token) {
    if (token == 'for') {
      tokens.add(Token(token: TokenEnum.forCommand));
    } else if (token == 'if') {
      tokens.add(Token(token: TokenEnum.ifCommand));
    } else if (token == 'else') {
      tokens.add(Token(token: TokenEnum.elseCommand));
    } else if (token == 'in') {
      tokens.add(Token(token: TokenEnum.inCommand));
    } else if (token == 'endif') {
      tokens.add(Token(token: TokenEnum.endIfCommand));
    } else if (token == 'endfor') {
      tokens.add(Token(token: TokenEnum.endForCommand));
    } else if (token == '==') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '!=') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '&&') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '>') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '<') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '<=') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (token == '>=') {
      tokens.add(Token(token: TokenEnum.operator, value: token));
    } else if (int.tryParse(token) != null || double.tryParse(token) != null) {
      tokens.add(Token(token: TokenEnum.intValue, value: token));
    } else {
      tokens.add(Token(token: TokenEnum.variableName, value: token));
    }
  }
}
