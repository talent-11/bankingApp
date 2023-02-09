import 'package:intl/intl.dart';

class ApiConstants {
  static String baseUrl = 'http://api.fotocbank.org';
  // static String baseUrl = 'https://5a87-104-223-87-12.ngrok.io';
  static String account = '/account';
  static String me = '/account/me';
  static String login = '/account/login';
  static String signup = '/account/register';
  static String businessSignup = '/account/business/register';
  static String reVerify = '/account/re-verify';
  static String businessReVerify = '/account/business/re-verify';
  static String profile = '/account/update';
  static String upgrade = '/account/upgrade';
  static String statement = '/account/statement';
  static String transaction = '/transaction';
  static String pay = '/transaction/pay';
  static String upload = '/service/upload';
  static String ocrStatement = '/service/ocr/statement';
  static String ocrIdCard = '/service/ocr/master';
}

class Notifications {
  static String transaction = "transaction";
}

class Folders {
  static String masterCards = 'cards/master';
  static String slaveCards = 'cards/slave';
  static String statements = 'statements';
  static String profiles = 'profiles';
}

class Ext {
  static NumberFormat formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");
  static String individual = "Individual";
  static String business = "Business";
  static List<String> businessType = ["Corp", "LLC", "Sole Proprietor"];
  static List<String> businessOrIndustry = ["Restaurant", "Construction", "Software developer", "Shipping"];
}
