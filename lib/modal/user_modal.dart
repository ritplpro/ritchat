class UserModal{
  String? userid;
  String? name;
  String? email;
  String? mobNo;
  String? gender;
  String? createdAt;
  bool? isOnline=false;
  int? status=1;
  String? profilePic="";
  int? profileStatus=1;

  UserModal(
      {this.userid,
      this.name,
      this.email,
      this.mobNo,
      this.createdAt,
      this.gender,
      this.isOnline,
      this.profilePic,
      this.profileStatus,
      this.status});



  factory UserModal.fromMap(Map<String,dynamic> map){
    return UserModal(
        userid: map["userid"],
        name: map["name"],
        email: map["email"],
        mobNo: map["mobNo"],
        createdAt: map["createdAt"],
        gender: map["gender"],
        isOnline: map["isOnline"],
        profilePic: map["profilePic"],
        profileStatus: map["profileStatus"],
        status: map["status"]
    );
  }

  Map<String,dynamic>toMap(){
    return{
      "userid":userid,
     "name": name,
      "email": email,
      "mobNo": mobNo,
      "createdAt": createdAt,
      "gender": gender,
      "isOnline": isOnline,
      "profilePic": profilePic,
      "profileStatus":profileStatus,
      "status": status

    };
  }




}