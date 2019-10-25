import 'dart:convert';
import 'dart:developer';
import 'package:aniflix_app/api/objects/Episode.dart';
import 'package:aniflix_app/components/slider/SliderElement.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class APIManager {


  static Future<List<SliderElement>> getAirings() async {
    List<SliderElement> airings = [];
    var response = await _getRequest("show/airing/0");

    if(response.statusCode == 200){
      var json = jsonDecode(response.body) as List;
      for(var entry in json){
        var ep = Episode.fromJson(entry);
        airings.add(SliderElement(name: ep.season.show.name, description: ep.updated_at,image: "https://www2.aniflix.tv/storage/" + ep.season.show.cover_landscape));
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
