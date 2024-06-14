import 'package:dartshine/src/templates/lexer/token.dart';

class Lexer {
  List<Token> tokens = [];
  List<String> sources;
  int position = 0;

  Lexer({required this.sources});

  void lexer() {
    String token = '';
    bool? isCommand;
    bool opentext = false;
    bool openbrace = false;

    for (int i = 0; i < sources.length; i++) {
      String source = sources[i];
      if (opentext && !(source == '"' || source == '\'')) {
        token += source;
        continue;
      } else if (opentext && (source == '"' || source == '\'')) {
        tokens.add(Token(
            token: TokenEnum.stringValue,
            value: token));
        tokens
            .add(Token(token: TokenEnum.guillemet));
        opentext = false;
        token = '';
        continue;
      }

      if (openbrace && source != '}') {
        token += source;
        continue;
      } else if (openbrace && source == '}') {
        tokens.add(Token(
            token: TokenEnum.content,
            value: token));
        tokens.add(
            Token(token: TokenEnum.closeBrace));
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
        position = i;
      } else if (token == '<\$') {
        token = '';
        tokens.add(Token(
            token: TokenEnum.openVariableBalise, position: position));
        isCommand = false;
      } else if (token == '<#') {
        token = '';
        tokens.add(Token(
            token: TokenEnum.openCommandBalise, position: position));
        isCommand = true;
      } else if (source == '#' || source == '\$') {
        token = '';
        token += source;
      } else if (token == '#>') {
        position = i;
        token = '';
        tokens.add(Token(
            token: TokenEnum.closeCommandBalise, position: position));
        isCommand = null;
      } else if (token == '\$>') {
        token = '';
        tokens.add(Token(
            token: TokenEnum.closeVariableBalise, position: position));
      } else if (token == '"' || token == '\'') {
        opentext = true;
        tokens
            .add(Token(token: TokenEnum.guillemet));
        token = '';
      } else if (source == '{') {
        openbrace = true;
        tokens
            .add(Token(token: TokenEnum.openBrace));
        token = '';
      } else if (source == ' ') {
        if (token.trim().isNotEmpty) {
          if (isCommand == true) {
            lexeCommand(token);
          } else if (isCommand == false) {
            tokens.add(Token(
                token: TokenEnum.variableName,
                value: token));
          }
        }
        token = '';
      }
    }
  }

  void lexeCommand(String token) {
    if (token == 'for') {
      tokens
          .add(Token(token: TokenEnum.forCommand));
    } else if (token == 'if') {
      tokens.add(Token(token: TokenEnum.ifCommand));
    } else if (token == 'else') {
      tokens
          .add(Token(token: TokenEnum.elseCommand));
    } else if (token == 'in') {
      tokens.add(Token(token: TokenEnum.inCommand));
    } else if (token == 'endif') {
      tokens.add(
          Token(token: TokenEnum.endIfCommand));
    } else if (token == 'endfor') {
      tokens.add(
          Token(token: TokenEnum.endForCommand));
    } else if (token == '==') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '!=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '&&') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '>') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '<') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '<=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (token == '>=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token));
    } else if (int.tryParse(token) != null || double.tryParse(token) != null) {
      tokens.add(Token(
          token: TokenEnum.intValue, value: token));
    } else {
      tokens.add(Token(
          token: TokenEnum.variableName,
          value: token));
    }
  }
}
