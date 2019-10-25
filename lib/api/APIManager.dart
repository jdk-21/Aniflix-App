import 'dart:convert';

import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:http/http.dart' as http;

class APIManager {
  static Future<List<SliderElement>> getAirings() async {
    List<SliderElement> airings = [];
    var response = await _getRequest("show/airing/0");

    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      for(var entry in json){
        airings.add(SliderElement(name: entry["season"]["show"]["name"], description: "Heute",image: "https://www2.aniflix.tv/storage/" + entry["season"]["show"]["cover_landscape"]));
      }
    }

    return airings;
  }

  static Future<http.Response> _getRequest(String query) {
    return http.get('https://www2.aniflix.tv/api/' + query);
  }

  static Future<http.Response> _postRequest(String query) {
    return http.post('https://www2.aniflix.tv/api/' + query);
  }
}
