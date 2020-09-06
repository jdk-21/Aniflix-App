import 'dart:convert';

import 'package:aniflix_app/api/objects/Session.dart';
import 'package:aniflix_app/api/objects/RegisterResponse.dart';
import 'package:aniflix_app/api/requests/AniflixRequest.dart';

class LoginRequests {
  static Future<Session> loginRequest(String email, String pw) async {
    var response =
        await AniflixRequest("auth/login", type: AniflixRequestType.No_Login)
            .post(bodyObject: {"email": email, "password": pw});
    return Session.fromJson(jsonDecode(response.body));
    ;
  }

  static Future<RegisterResponse> registerRequest(
    String email,
    String pw,
    String token,
    String username,
  ) async {
    var response =
        await AniflixRequest("user/register", type: AniflixRequestType.No_Login)
            .post(bodyObject: {
      "email": email,
      "password": pw,
      "token": token,
      "username": username
    });

    return RegisterResponse.fromJson(jsonDecode(response.body));
  }
}
