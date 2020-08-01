class RegisterResponse{
  int id;
  String name;
  String error;

  RegisterResponse(this.id,this.name);
  RegisterResponse.error(this.error);
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    if(json.containsKey("message")){
      return RegisterResponse.error(json["message"]);
    }else{
      return RegisterResponse(json["id"], json["name"]);
    }
  }
  bool hasError(){
    return error != null && error.length > 0;
  }
}