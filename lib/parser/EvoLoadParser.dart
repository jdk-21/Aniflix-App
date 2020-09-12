import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:html/dom.dart';

class EvoLoadParser extends HosterParser {
  EvoLoadParser() : super(24, false, canParse: false);

  Future<String> onParse(Document doc) async {
    return "";
  }
}