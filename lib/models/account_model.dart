import 'dart:convert';

List<AccountModel> userModelFromJson(String str) =>
    List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));

String userModelToJson(List<AccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    this.verifiedId,
    this.referralId,
    this.friendId,
    this.address,
    // required this.website,
    // required this.company,
  });

  int id;
  String name;
  String email;
  String phone;
  String token;
  String? verifiedId;
  String? referralId;
  String? friendId;
  Address? address;
  // String website;
  // Company company;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        address: Address.fromJson(json["address"]),
        phone: json["phone"],
        token: json["token"],
        verifiedId: json["verifiedId"],
        referralId: json["referralId"],
        friendId: json["friendId"],
        // website: json["website"],
        // company: Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "address": address!.toJson(),
        "phone": phone,
        "verifiedId": verifiedId,
        "referralId": referralId,
        "friendId": friendId,
        // "website": website,
        // "company": company.toJson(),
      };
}

class Address {
  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        suite: json["suite"],
        city: json["city"],
        zipcode: json["zipcode"],
        geo: Geo.fromJson(json["geo"]),
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "suite": suite,
        "city": city,
        "zipcode": zipcode,
        "geo": geo.toJson(),
      };
}

class Geo {
  Geo({
    required this.lat,
    required this.lng,
  });

  String lat;
  String lng;

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Company {
  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  String name;
  String catchPhrase;
  String bs;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json["name"],
        catchPhrase: json["catchPhrase"],
        bs: json["bs"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "catchPhrase": catchPhrase,
        "bs": bs,
      };
}