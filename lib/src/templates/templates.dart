import 'package:dartshine/src/templates/lexer/lexer.dart';
import 'package:dartshine/src/templates/parser/parser.dart';
import 'package:dartshine/src/templates/read_file.dart';
import 'package:dartshine/src/templates/render/render.dart';

class Template {
  List<String> sources = [];

  Template({required String path}) {
    sources = readFile(path);
  }

  String render({required Map<String, dynamic> variableList}) {
    final Lexer lexer = Lexer(sources: sources);
    lexer.lexer();

    final Parser parser = Parser(tokens: lexer.tokens);
    parser.parser();

    final Render render = Render(
        parserResult: parser.results,
        variableList: variableList,
        sources: sources);
    render.render();

    return render.sources.join();
  }
}
