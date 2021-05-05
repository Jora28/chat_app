
class User {
  String id;
  String name;
  String surname;
  String email;
  String profileImage;

  User({
    this.profileImage,
    this.id,
    this.email,
    this.name,
    this.surname,
  });

  factory User.fromJson(json) {
    return User(
     // profileImage: json['profileImage'],
      name: json["name"],
      surname: json["surname"],
      email: json["email"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();

    data["name"] = this.name;
    data['profileImage'] = this.profileImage;
    data["surname"] = this.surname;
    data["email"] = this.email;
    data["id"] = this.id;
    return data;
  }
}
