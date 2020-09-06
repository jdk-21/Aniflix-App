class Session{
  String access_token;
  String token_type;
  int expires_in;
  String error;

  Session(this.access_token,this.token_type,this.expires_in);
  Session.error(this.error);
  factory Session.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("error")){
      return Session.error(json["error"]);
    }else{
      return Session(json["access_token"], json["token_type"], json["expires_in"]);
    }
  }
  bool hasError(){
    return error != null && error.length > 0;
  }
}