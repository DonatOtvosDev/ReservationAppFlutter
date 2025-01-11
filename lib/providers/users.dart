import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_app/modells/user_info_modell.dart';

const String rootLink = "http://127.0.0.1:8000/";

class UsersProvider extends ChangeNotifier {
  UserInfo? _myData;
  List<UserData> _items = [];

  String? authToken;
  String? accessLevel;

  UsersProvider(this._myData, this.authToken, this.accessLevel);

  UserInfo? get myData => _myData;
  List<UserData> get items => _items;

  Future<void> fetchAndSetUsers({String? filter}) async {
    if (accessLevel != "admin") return;
    final url = filter == null
        ? Uri.parse("$rootLink/users")
        : Uri.parse("$rootLink/users?filter=$filter");
    final response = await http.get(url, headers: {"token": authToken!});

    final responseData = json.decode(response.body);
    _items = [];
    for (Map user in responseData) {
      _items.add(UserData(
          userName: user["username"],
          email: user["email"],
          phoneNumber: user["phone_number"],
          firstName: user["first_name"],
          sirName: user["sir_name"],
          id: user["id"],
          status: user["access_level"]));
    }
    notifyListeners();
  }

  Future<void> loadMoreUsers({int limit = 10, String? filter}) async {
    if (accessLevel != "admin") return;
    final url = filter == null
        ? Uri.parse("$rootLink/users?limit=$limit&skip=${_items.length}")
        : Uri.parse(
            "$rootLink/users?limit=$limit&skip=${_items.length}&filter=$filter");
    final response = await http.get(url, headers: {"token": authToken!});

    final responseData = json.decode(response.body);

    for (Map user in responseData) {
      _items.add(UserData(
          userName: user["username"],
          email: user["email"],
          phoneNumber: user["phone_number"],
          firstName: user["first_name"],
          sirName: user["sir_name"],
          id: user["id"],
          status: user["access_level"]));
    }
    notifyListeners();
  }

  Future<void> bannUser(userId, filter) async {
    if (accessLevel != "admin") return;
    final url = Uri.parse("$rootLink/user/ban");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "user": {"id": userId}
        }));
    if (response.statusCode == 202) {
      final index = _items.indexWhere((element) => element.id == userId);
      if (filter != null && filter != "banneduser") {
        _items.removeAt(index);
      } else {
        _items[index] = UserData(
            userName: _items[index].userName,
            email: _items[index].email,
            phoneNumber: _items[index].phoneNumber,
            firstName: _items[index].firstName,
            sirName: _items[index].sirName,
            id: _items[index].id,
            status: "banneduser");
      }
      notifyListeners();
    }
  }

  Future<void> allowUser(userId, filter) async {
    if (accessLevel != "admin") return;
    final url = Uri.parse("$rootLink/user/add");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "user": {"id": userId}
        }));
    if (response.statusCode == 202) {
      final index = _items.indexWhere((element) => element.id == userId);
      if (filter != null && filter != "user") {
        _items.removeAt(index);
      } else {
        _items[index] = UserData(
            userName: _items[index].userName,
            email: _items[index].email,
            phoneNumber: _items[index].phoneNumber,
            firstName: _items[index].firstName,
            sirName: _items[index].sirName,
            id: _items[index].id,
            status: "user");
      }
      notifyListeners();
    }
  }

  Future<void> loadMyUser() async {
    final url = Uri.parse("$rootLink/me");
    final response = await http.get(url, headers: {"token": authToken!});

    final responseData = json.decode(response.body);

    _myData = UserInfo(
        userName: responseData["username"],
        email: responseData["email"],
        phoneNumber: responseData["phone_number"],
        firstName: responseData["first_name"],
        sirName: responseData["sir_name"],
        id: responseData["id"]);
    notifyListeners();
  }

  Future<void> updateUserInfo(Map dataToUpdate) async {
    final url = Uri.parse("$rootLink/user/update");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "user": dataToUpdate
        }));

    final responseData = json.decode(response.body);

    if (!(response.statusCode < 400)) {
      throw responseData["detail"];
    }

    _myData = UserInfo(
        userName: responseData["username"],
        email: responseData["email"],
        phoneNumber: responseData["phone_number"],
        firstName: responseData["first_name"],
        sirName: responseData["sir_name"],
        id: responseData["id"]);

    notifyListeners();
  }
}
