import 'dart:convert';

List<AccountModel> userModelFromJson(String str) => List<AccountModel>.from(json.decode(str).map((x) => AccountModel.fromJson(x)));

String userModelToJson(List<AccountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    this.gender,
    this.birth,
    this.marital,
    this.fundMatched,
    this.bank,
    this.business,
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
  String? gender;
  String? birth;
  String? marital;
  bool? fundMatched;
  Bank? bank = Bank(checking: 0, saving: 0);
  BusinessModel? business;

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
    gender: json["gender"],
    birth: json["birth"],
    marital: json["marital"],
    fundMatched: json["fund_matched"],
    bank: json["bank"] != null
      ? Bank.fromJson(json["bank"])
      : null,
    business: json["business"] != null
      ? BusinessModel.fromJson(json["business"])
      : null,
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
    checking: json["checking"] is int ? json["checking"].toDouble() : double.parse(json["checking"]),
    saving: json["saving"] is int ? json["saving"].toDouble() : double.parse(json["saving"]),
  );

  Map<String, dynamic> toJson() => {
    "checking": checking,
    "saving": saving,
  };
}

class BusinessModel {
  BusinessModel({
    this.id,
    this.name,
    this.email,
    this.taxId,
    this.phone,
    this.verifiedId,
    this.verified,
    this.suite,
    this.city,
    this.state,
    this.country,
    this.doo,
    this.type,
    this.boi,
    this.fundMatched,
    this.bank
  });

  int? id;
  String? name;
  String? email;
  String? taxId;
  String? phone;
  String? verifiedId;
  bool? verified;
  String? suite;
  String? city;
  String? state;
  String? country;
  String? doo;
  String? type;
  String? boi;
  bool? fundMatched;
  Bank? bank = Bank(checking: 0, saving: 0);

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    taxId: json["tax_id"],
    phone: json["phone"],
    verifiedId: json["verified_id"],
    verified: json["verified"],
    suite: json["suite"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    doo: json["doo"],
    type: json["type"],
    boi: json["boi"],
    fundMatched: json["fund_matched"],
    bank: Bank.fromJson(json["bank"]),
  );
}
