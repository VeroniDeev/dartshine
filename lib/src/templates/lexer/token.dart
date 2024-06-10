enum TokenEnum {
  openVariableBalise,
  closeVariableBalise,
  openCommandBalise,
  closeCommandBalise,
  variableName,
  forCommand,
  inCommand,
  endForCommand,
  ifCommand,
  elseCommand,
  endIfCommand,
  content,
  operator,
  intValue,
  guillemet,
  stringValue,
  openBrace,
  closeBrace
}

class Token {
  TokenEnum token;
  String? value;

  Token({required this.token, this.value});
}
