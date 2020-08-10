import 'package:aniflix_app/parser/HosterParser.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';

class StreamTapeParser extends HosterParser {
  StreamTapeParser() : super(21,true);

  Future<String> onParse(Document doc) async {
    var url = "https:" + doc.getElementById("videolink").innerHtml;
    url = url.replaceAll(";", "&");
    final client = http.Client();
    final request = new http.Request('GET', Uri.parse(url))
      ..followRedirects = false;
    final response = await client.send(request);
    url = response.headers['location'];
    print(url);
    return url;
  }
}
