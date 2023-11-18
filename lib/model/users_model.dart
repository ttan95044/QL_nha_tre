class UserModel{
  String? uid;
  String? email;
  String? fullname;
  String? address;
  String? position;
  UserModel({this.uid,this.email,this.fullname,this.address,this.position});

  factory UserModel.fromMap(map)
  {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullname: map['fullname'],
      address: map['address'],
      position: map['position'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'address': address,
      'position': position,
    };
  }
}