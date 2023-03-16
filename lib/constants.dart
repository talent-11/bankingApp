import 'package:intl/intl.dart';

class ApiConstants {
  static String baseUrl = 'http://api.fotocbank.org';
  // static String baseUrl = 'https://5a87-104-223-87-12.ngrok.io';
  static String account = '/account';
  static String me = '/account/me';
  static String login = '/account/login';
  static String signup = '/account/register';
  static String businessSignup = '/account/business/register';
  static String businessUpdate = '/account/business/update';
  static String resendEmail = '/account/resend-email';
  static String businessResendEmail = '/account/business/resend-email';
  static String profile = '/account/update';
  static String changePassword = '/account/change-password';
  static String upgrade = '/account/upgrade';
  static String statement = '/account/statement';
  static String transaction = '/transaction';
  static String pay = '/transaction/pay';
  static String upload = '/service/upload';
  static String ocrStatement = '/service/ocr/statement';
  static String ocrIdCard = '/service/ocr/card';
  static String notifications = '/service/notifications';
}

class Notifications {
  static String transaction = "transaction";
}

class Folders {
  static String idCard = 'cards/id';
  static String dlCard = 'cards/dl';
  static String ptCard = 'cards/pt';
  static String statements = 'statements';
  static String profiles = 'profiles';
}

class Ext {
  static NumberFormat formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
  static String individual = "Individual";
  static String business = "Business";
  static String male = "Male";
  static String female = "Female";
  static List<String> businessType = ["Corp", "LLC", "Sole Proprietor"];
  static List<String> businessOrIndustry = ["Restaurant", "Construction", "Software developer", "Shipping"];
}

class Error {
  static String id = "id";
  static String phone = "phone";
  static String email = "email";
}

class CardType {
  static String idFull = "I.D.";
  static String dlFull = "Driver License";
  static String ptFull = "Passport";
  static String id = "id";
  static String dl = "dl";
  static String pt = "pt";
}
