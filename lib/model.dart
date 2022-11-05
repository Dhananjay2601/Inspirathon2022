import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.id,
    required this.slots,
    required this.multiImgs,
    required this.name,
    required this.shortDesc,
    required this.description,
    required this.locality,
    required this.address,
    required this.price,
    required this.img,
    required this.video,
    required this.ratings,
    required this.lattitude,
    required this.longitude,
  });

  String id;
  List<Slot> slots;
  List<MultiImg> multiImgs;
  String name;
  String shortDesc;
  String description;
  String locality;
  String address;
  double price;
  String img;
  String video;
  double ratings;
  dynamic lattitude;
  dynamic longitude;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["id"],
        slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
        multiImgs: List<MultiImg>.from(
            json["multi_imgs"].map((x) => MultiImg.fromJson(x))),
        name: json["name"],
        shortDesc: json["short_desc"],
        description: json["description"],
        locality: json["locality"],
        address: json["address"],
        price: json["price"],
        img: json["img"],
        video: json["video"],
        ratings: json["ratings"],
        lattitude: json["lattitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slots": List<dynamic>.from(slots.map((x) => x.toJson())),
        "multi_imgs": List<dynamic>.from(multiImgs.map((x) => x.toJson())),
        "name": name,
        "short_desc": shortDesc,
        "description": description,
        "locality": locality,
        "address": address,
        "price": price,
        "img": img,
        "video": video,
        "ratings": ratings,
        "lattitude": lattitude,
        "longitude": longitude,
      };
}

class MultiImg {
  MultiImg({
    required this.img,
  });

  String img;

  factory MultiImg.fromJson(Map<String, dynamic> json) => MultiImg(
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
      };
}

class Slot {
  Slot({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  String id;
  String startTime;
  String endTime;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_time": startTime,
        "end_time": endTime,
      };
}
