import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String rootLink = "http://127.0.0.1:8000/";

class UserAuth extends ChangeNotifier {
  String? _userName;
  String? _token;
  DateTime? _expiary;
  String? _accessLevel;
  bool _autoLoginTryed = false;

  Timer? _authTimer;

  final storage = const FlutterSecureStorage();

  void _resetToken() {
    _token = null;
    _expiary = null;
    _accessLevel = null;

    _userName = null;

    storage.delete(key: "token");
    storage.delete(key: "expiary");
    notifyListeners();
  }

  String? get username => _userName;

  bool get tryedLogin => _autoLoginTryed;

  get token {
    if (_token == null) {
      return;
    } else if (DateTime.now().isAfter(_expiary!)) {
      return;
    }
    return _token;
  }

  get isAuthenticated {
    if (_token == null) {
      return false;
    } else if (DateTime.now().isAfter(_expiary!)) {
      return false;
    }
    return true;
  }

  get isAuthenticatedAdmin {
    if (_token == null) {
      return false;
    } else if (DateTime.now().isAfter(_expiary!)) {
      return false;
    } else if (_accessLevel != "admin") {
      return false;
    }
    return true;
  }

  get accessLevel {
    if (_accessLevel == "user" && isAuthenticated) {
      return "user";
    } else if (_accessLevel == "admin" && isAuthenticatedAdmin) {
      return "admin";
    }
    return;
  }

  Future<void> loginUser(Map<String, dynamic> data,
      {bool saveCredential = false}) async {
    final url = Uri.parse("$rootLink/token");

    final response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(data));
    final responseData = json.decode(response.body);

    if (!(response.statusCode < 400)) {
      throw responseData["detail"];
    }
    _resetToken();
    _token = responseData["access_token"];

    _userName = data["username"];
    _accessLevel = responseData["access_level"];
    _expiary =
        DateTime.now().add(Duration(minutes: responseData["expiary_min"]));
    await storage.write(key: "token", value: _token!);
    await storage.write(key: "expiary", value: _expiary!.toIso8601String());
    await storage.write(key: "access_level", value: _accessLevel);
    await storage.write(key: "token_user", value: _userName);

    if (saveCredential) {
      await storage.write(key: "username", value: _userName);
      await storage.write(key: "password", value: data["password"]);
    }
    notifyListeners();
    _autoRefreshToken(data);
  }

  Future<void> registerUser(Map<String, dynamic> data) async {
    final url = Uri.parse("$rootLink/sign_up");

    final response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(data));
    final responseData = json.decode(response.body);
    if (!(response.statusCode < 400)) {
      throw responseData["detail"];
    }

    //Map<String, dynamic> loginData = {
    //  "username": data["username"],
    //  "password": data["password"]
    //};
  }

  Future<void> changePassword(Map passwords) async {
    final url = Uri.parse("$rootLink/user/changepasword");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": _token, "token_type": "bearer"},
          "user": passwords
        }));
    final responseData = json.decode(response.body);
    if (!(response.statusCode < 400)) {
      throw responseData["detail"];
    }
    _authTimer?.cancel();

    await loginUser(
        {"username": _userName, "password": passwords["new_password"]});
  }

  Future<void> logOut() async {
    _resetToken();

    await storage.deleteAll();
    _authTimer?.cancel();
  }

  void _autoRefreshToken(Map<String, dynamic> loginData) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToNewLogin = _expiary!
        .difference(DateTime.now().subtract(const Duration(seconds: 30)));
    _authTimer = Timer(timeToNewLogin, () => loginUser(loginData));
  }

  Future<void> withdrawAllUserData(authenticationData) async {
    final url = Uri.parse("$rootLink/user/deleteinfo");
    final response = await http.delete(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": _token, "token_type": "bearer"},
          "user": authenticationData
        }));
    if (!(response.statusCode < 400)) {
      throw json.decode(response.body)["detail"];
    }
    logOut();
  }

  Future<void> tryautoLogIn() async {
    if (_autoLoginTryed) {
      return;
    }
    final userCredentials = await storage.readAll();
    _autoLoginTryed = true;
    if (userCredentials.containsKey("token") ||
        userCredentials.containsKey("username")) {
      if (DateTime.parse(userCredentials["expiary"]!)
          .isBefore(DateTime.now())) {
        _token = userCredentials["token"];
        _accessLevel = userCredentials["access_level"];
        _expiary = DateTime.parse(userCredentials["expiary"]!);
        _userName = userCredentials["token_user"];
        notifyListeners();
        if (userCredentials.containsKey("username")) {
          _autoRefreshToken({
            "username": userCredentials["username"],
            "password": userCredentials["password"]
          });
        } else {
          _authTimer?.cancel();
          _authTimer =
              Timer(_expiary!.difference(DateTime.now()), tryautoLogIn);
        }
        return;
      }
      if (userCredentials.containsKey("username")) {
        await loginUser({
          "username": userCredentials["username"],
          "password": userCredentials["password"]
        });
      }
    }
  }
}
