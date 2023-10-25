class MemoryModel {
  String? image;
  String? title;
  String? audio;

  MemoryModel({this.image, this.title, this.audio});

  MemoryModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['audio'] = audio;
    return data;
  }
}
