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
            value: token,
            position: position));
        tokens
            .add(Token(token: TokenEnum.guillemet, position: position));
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
            value: token,
            position: position));
        tokens.add(
            Token(token: TokenEnum.closeBrace, position: position));
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
            .add(Token(token: TokenEnum.guillemet, position: position));
        token = '';
      } else if (source == '{') {
        openbrace = true;
        tokens
            .add(Token(token: TokenEnum.openBrace, position: position));
        token = '';
      } else if (source == ' ') {
        if (token.trim().isNotEmpty) {
          if (isCommand == true) {
            lexeCommand(token);
          } else if (isCommand == false) {
            tokens.add(Token(
                token: TokenEnum.variableName,
                value: token,
                position: position));
          }
        }
        token = '';
      }

      position++;
    }
  }

  void lexeCommand(String token) {
    if (token == 'for') {
      tokens
          .add(Token(token: TokenEnum.forCommand, position: position));
    } else if (token == 'if') {
      tokens.add(Token(token: TokenEnum.ifCommand, position: position));
    } else if (token == 'else') {
      tokens
          .add(Token(token: TokenEnum.elseCommand, position: position));
    } else if (token == 'in') {
      tokens.add(Token(token: TokenEnum.inCommand, position: position));
    } else if (token == 'endif') {
      tokens.add(
          Token(token: TokenEnum.endIfCommand, position: position));
    } else if (token == 'endfor') {
      tokens.add(
          Token(token: TokenEnum.endForCommand, position: position));
    } else if (token == '==') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '!=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '&&') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '>') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '<') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '<=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (token == '>=') {
      tokens.add(Token(
          token: TokenEnum.operator, value: token, position: position));
    } else if (int.tryParse(token) != null || double.tryParse(token) != null) {
      tokens.add(Token(
          token: TokenEnum.intValue, value: token, position: position));
    } else {
      tokens.add(Token(
          token: TokenEnum.variableName,
          value: token,
          position: position));
    }
  }
}
