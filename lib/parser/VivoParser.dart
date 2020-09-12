import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:html/dom.dart';

class VivoParser extends HosterParser{
  VivoParser():super(4,true, canParse: false);

  //TODO
  Future<String> onParse(Document doc) async{
    var src = doc.getElementsByTagName("body").first.innerHtml;
    return src;
  }


}