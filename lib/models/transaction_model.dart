// import 'dart:convert';

// import 'package:fotoc/models/account_model.dart';

// List<TransactionModel> transactionModelFromJson(String str) => List<TransactionModel>.from(
//     json.decode(str).map((x) => TransactionModel.fromJson(x)));

// String transactionModelToJson(List<TransactionModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModel {
  TransactionModel({
    required this.name,
    required this.date,
    required this.amount,
    required this.paid,
    required this.toMe,
  });

  String name;
  String amount;
  String date;
  bool paid;
  bool toMe;
}

// class TransactionModel {
//   TransactionModel({
//     required this.sender,
//     required this.receiver,
//     required this.date,
//     required this.amount,
//   });

//   AccountModel sender;
//   AccountModel receiver;
//   String amount;
//   String date;

//   factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
//     sender: AccountModel.fromJson(json["sender"]),
//     receiver: AccountModel.fromJson(json["receiver"]),
//     date: json["date"],
//     amount: json["amount"],
//   );

//   Map<String, dynamic> toJson() => {
//     "sender": sender.toJson(),
//     "receiver": receiver.toJson(),
//     "date": date,
//     "amount": amount,
//   };
// }
