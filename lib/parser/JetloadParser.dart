import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:html/dom.dart';

class JetloadParser extends HosterParser {
  JetloadParser() : super(13, false, canParse: false);

  Future<String> onParse(Document doc) async {
    return "";
  }
}
