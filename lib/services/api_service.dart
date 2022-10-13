import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants.dart';

class ApiService {
  Future<http.Response?> get(String endpoint, String? token) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + endpoint);
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token!.isNotEmpty ? token  : '',
      };
      return await http.get(url, headers: headers);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<http.Response?> post(String endpoint, String? token, String params) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + endpoint);
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token!.isNotEmpty ? token  : '',
      };
      // var headers = token!.isNotEmpty ? { HttpHeaders.authorizationHeader: token } : null;
      return await http.post(url, headers: headers, body: params);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
