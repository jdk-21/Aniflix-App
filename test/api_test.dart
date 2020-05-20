import 'package:aniflix_app/api/APIManager.dart';
import 'package:flutter_test/flutter_test.dart';

const String name = "DommisTestUser";
const String email = "test@test.com";
const String pw = "test1234";
void main() {
  test("Test invalid Login",() async {
    await APIManager.loginRequest(email, "wrong_pw");
    expect(APIManager.login, isNotNull);
    expect(APIManager.login.error, "Unauthorized");
  });
  test("Test Login",() async {
    await APIManager.loginRequest(email, pw);
    expect(APIManager.login, isNotNull);
    expect(APIManager.login.error, null);
  });
  test("Test News",() async {
    var news = await APIManager.getNewShows();
    expect(news, isNotNull);
  });
}
