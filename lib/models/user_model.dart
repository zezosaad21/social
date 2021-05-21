class UserModel {
  String name;
  String uId;
  String email;
  String cover;
  String dio;
  String phone;
  String image;

  UserModel({
    this.email,
    this.image,
    this.name,
    this.phone,
    this.cover,
    this.dio,
    this.uId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    image = json["image"];
    name = json["name"];
    dio = json["dio"];
    cover = json["cover"];
    uId = json["uId"];
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "image": image,
      "dio": dio,
      "cover": cover,
      "name": name,
      "uId": uId,
      "phone": phone,
    };
  }
}
