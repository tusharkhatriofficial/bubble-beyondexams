class UserModel {

  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  //default constructor
  UserModel({this.fullname, this.email, this.profilepic, this.uid});

  //another map type const..
  UserModel.fromMap(Map<String, dynamic> map){
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
  }

  // toMap function
  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic
    };
  }


}