class LoginResponse{
  String access_token;
  String token_type;
  int expires_in;
  String error;

  LoginResponse(this.access_token,this.token_type,this.expires_in);
  LoginResponse.error(this.error);
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("error")){
      return LoginResponse.error(json["error"]);
    }else{
      return LoginResponse(json["access_token"], json["token_type"], json["expires_in"]);
    }
  }
  bool hasError(){
    return error != null && error.length > 0;
  }
}