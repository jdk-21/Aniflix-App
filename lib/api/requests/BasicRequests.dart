import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class BasicRequests {
  String query;
  Map<String, String> headers;

  BasicRequests(this.query, {this.headers});

  Future<http.Response> get() {
    return http.get(query, headers: headers);
  }

  Future<http.Response> post({bodyObject = const {}}) {
    return http.post(query, body: bodyObject, headers: headers);
  }

  Future<http.Response> patch({bodyObject = const {}}) {
    return http.patch(query, body: bodyObject, headers: headers);
  }

  Future<http.Response> delete() {
    return http.delete(query, headers: headers);
  }

  Future<Response> multipartFilePost(String key, String path) async {
    var dio = new Dio(BaseOptions(headers: headers));
    var formData = FormData.fromMap({key: MultipartFile.fromFileSync(path)});
    return dio.post(query, data: formData);
  }
}
