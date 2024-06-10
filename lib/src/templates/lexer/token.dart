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
  separator,
  content,
  operator,
  intValue,
  guillemet,
  stringValue
}

class Token {
  TokenEnum token;
  String? value;

  Token({required this.token, this.value});
}
