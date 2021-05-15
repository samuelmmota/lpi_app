class User{
 final String uid;
 String name;
 String email;
 DateTime birthday;
 int height;

 User({this.uid, this.name, this.email, this.birthday, this.height});

 factory User.fromJson(Map<String, dynamic> json){
  return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      birthday: json['birthday'],
      height: json['height'],);
 }
 Map<String,dynamic> toMap(){
  return {
   'uid': uid,
   'name':name,
   'email':email,
   'birthday':birthday,
   'height': height
  };
 }
}
