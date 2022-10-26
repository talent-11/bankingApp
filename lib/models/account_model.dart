import 'dart:convert';

List<AccountModel> userModelFromJson(String str) => List<AccountModel>.from(
    json.decode(str).map((x) => AccountModel.fromJson(x)));

String userModelToJson(List<AccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  AccountModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.token,
    this.verifiedId,
    this.referralId,
    this.friendId,
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.state,
    this.country,
    // required this.website,
    // required this.company,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? token;
  String? verifiedId;
  String? referralId;
  String? friendId;
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  String? state;
  String? country;
  // String website;
  // Company company;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    token: json["token"],
    verifiedId: json["verified_id"],
    referralId: json["referral_id"],
    friendId: json["friend_id"],
    street: json["street"],
    suite: json["suite"],
    city: json["city"],
    zipcode: json["zipcode"],
    state: json["state"],
    country: json["country"],
    // website: json["website"],
    // company: Company.fromJson(json["company"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "verifiedId": verifiedId,
    "referralId": referralId,
    "friendId": friendId,
    "street": street,
    "suite": suite,
    "city": city,
    "zipcode": zipcode,
    "state": state,
    "country": country,
    // "website": website,
    // "company": company.toJson(),
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
