class PostModel {
  String name;
  String uId;
  String image;
  String date;
  String text;
  String postImages;

  PostModel({
    this.image,
    this.name,
    this.uId,
    this.date,
    this.text,
    this.postImages,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    name = json["name"];
    uId = json["uId"];
    date = json["date"];
    text = json["text"];
    postImages = json["postImages"];
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "name": name,
      "uId": uId,
      "date": date,
      "text": text,
      "postImages": postImages,
    };
  }
}
