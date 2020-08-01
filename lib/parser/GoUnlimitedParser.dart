import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:html/dom.dart';

class GoUnlimitedParser extends HosterParser {
  GoUnlimitedParser() : super(6,false);

  _getMP4(String prefix, String id) {
    return "https://fs"+prefix+".gounlimited.to/" + id + "/v.mp4";
  }

  Future<String> onParse(Document doc) async{
    var elements = doc.getElementsByTagName("script");
    var script = elements[elements.length-2];
    var step1 = script.innerHtml.split(RegExp("\\|type\\|"))[1];
    var step2 = step1.split(RegExp("\\|fs"));
    var id = step2[0];
    var prefix = step2[1].split(RegExp("\\'\\.split"))[0];
    var url = _getMP4(prefix,id);
    print(url);
    return url;
  }

  
}
