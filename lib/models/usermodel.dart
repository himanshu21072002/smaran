class UserModel {
  String? uid;
  String? category;
  String? name;
  String? email;
  String? profilepic;
  String? contact;
  Address? address;

  UserModel(
      {this.uid,
        this.category,
        this.name,
        this.email,
        this.profilepic,
        this.contact,
        this.address});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    category = json['category'];
    name = json['name'];
    email = json['email'];
    profilepic = json['profilepic'];
    contact = json['contact'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['category'] = category;
    data['name'] = name;
    data['email'] = email;
    data['profilepic'] = profilepic;
    data['contact'] = contact;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? country;
  String? state;
  String? city;
  String? area;
  String? buildingName;

  Address({this.country, this.state, this.city, this.area, this.buildingName});

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    state = json['state'];
    city = json['city'];
    area = json['area'];
    buildingName = json['building_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['area'] = area;
    data['building_name'] = buildingName;
    return data;
  }
}
