import 'package:aniflix_app/parser/EvoLoadParser.dart';
import 'package:aniflix_app/parser/GoUnlimitedParser.dart';
import 'package:aniflix_app/parser/JetloadParser.dart';
import 'package:aniflix_app/parser/StreamTapeParser.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

abstract class HosterParser {
  int hosterID;
  bool canDownload;
  bool canParse;
  String url;
  static Map<int, HosterParser> parser = new Map<int, HosterParser>();

  HosterParser(this.hosterID,this.canDownload,{this.canParse = true}) {
    parser[hosterID] = this;
  }

  static initParser(){
    new GoUnlimitedParser();
    new StreamTapeParser();
    new JetloadParser();
    new EvoLoadParser();
  }

  Future<String> parseHoster(String url) async {
    this.url = url;
    if(canParse){
      var response = await http.get(url);
      var doc = parse(response.body);
      return await onParse(doc);
    }
    return url;
  }

  @protected
  Future<String> onParse(Document doc);
}
