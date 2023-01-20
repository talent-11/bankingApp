class ApiConstants {
  static String baseUrl = 'http://api.fotocbank.org';
  // static String baseUrl = 'https://5a87-104-223-87-12.ngrok.io';
  static String account = '/account';
  static String login = '/account/login';
  static String signup = '/account/register';
  static String reVerify = '/account/re-verify';
  static String profile = '/account/update';
  static String statement = '/account/statement';
  static String transaction = '/transaction';
  static String pay = '/transaction/pay';
  static String upload = '/service/upload';
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
