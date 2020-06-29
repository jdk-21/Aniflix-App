import 'package:aniflix_app/parser/GoUnlimitedParser.dart';
import 'package:aniflix_app/parser/StreamTapeParser.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

abstract class HosterParser {
  int hosterID;
  static Map<int, HosterParser> parser = new Map<int, HosterParser>();

  HosterParser(this.hosterID) {
    parser[hosterID] = this;
  }

  static initParser(){
    new GoUnlimitedParser();
    new StreamTapeParser();
  }

  Future<String> parseHoster(String url) async {
    var response = await http.get(url);
    var doc = parse(response.body);
    return await onParse(doc);
  }

  @protected
  Future<String> onParse(Document doc);
}
