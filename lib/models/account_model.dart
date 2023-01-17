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
    this.username,
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
    this.bank,
    // required this.website,
    // required this.company,
  });

  int? id;
  String? name;
  String? email;
  String? username;
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
  Bank? bank = Bank(checking: 0, saving: 0);

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    username: json["username"],
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
    bank: Bank.fromJson(json["bank"]),
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
    "bank": bank!.toJson(),
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

class Bank {
  Bank({
    required this.checking,
    required this.saving,
  });

  double checking;
  double saving;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    // checking: double.parse(json["checking"]),
    // saving: double.parse(json["saving"]),
    checking: json["checking"].toDouble(),
    saving: json["saving"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "checking": checking,
    "saving": saving,
  };
}
