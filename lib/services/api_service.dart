import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  static var client = http.Client();

  static getBasicAuthSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? basicAuth = prefs.getString('BasicAuth');
    return basicAuth;
  }

  static Future<http.Response> validateCredentials(
      String email, String password) async {
    String apiUrl =
        "http://desarrollo.segursat.com:8000/web/api/users/get_basic_current_user_information/";
    Map<String, String> headers = {};
    String basicAuth = base64Encode(utf8.encode('$email:$password'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('BasicAuth', basicAuth);
    headers["Authorization"] = 'Basic $basicAuth';
    http.Response res;

    try {
      res = await client.get(Uri.parse(apiUrl), headers: headers);
      return res;
    } on SocketException {
      // ignore: avoid_print
      print('No Internet connection 😑');
      return http.Response('Not Found', 404);
    }
  }

  static Future<http.Response> getGeolocation(latitude, longitude) async {
    Map<String, String> headers = {};
    var token = await getBasicAuthSF();
    headers["Authorization"] = 'Basic $token';
    http.Response res;

    try {
      res = await client.get(
          Uri.parse(
              'http://desarrollo.segursat.com:8000/web/api/checkpoint/validate-position/$latitude/$longitude/'),
          headers: headers);
      return res;
    } on SocketException {
      // ignore: avoid_print
      print('No Internet connection 😑');
      return http.Response('Not Found', 404);
    }
  }

  static Future<http.Response> getControlSets() async {
    Map<String, String> headers = {};
    var token = await getBasicAuthSF();
    headers["Authorization"] = 'Basic $token';
    http.Response res;

    try {
      res = await client.get(
          Uri.parse(
              'http://desarrollo.segursat.com:8000/web/api/checkpoint/get-control-sets/'),
          headers: headers);
      return res;
    } on SocketException {
      // ignore: avoid_print
      print('No Internet connection 😑');
      return http.Response('Not Found', 404);
    }
  }

  static Future<http.Response> getControlSetById(id) async {
    Map<String, String> headers = {};
    var token = await getBasicAuthSF();
    headers["Authorization"] = 'Basic $token';
    http.Response res;

    try {
      res = await client.get(
          Uri.parse(
              'http://desarrollo.segursat.com:8000/web/api/checkpoint/get-control-set/$id/'),
          headers: headers);
      return res;
    } on SocketException {
      // ignore: avoid_print
      print('No Internet connection 😑');
      return http.Response('Not Found', 404);
    }
  }
}
