import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:reservation_app/modells/home_screen_modell.dart';
import 'package:reservation_app/modells/about_me_screen_modell.dart';

const String rootLink = "http://127.0.0.1:8000/";

class ScreenProvider with ChangeNotifier {
  AboutMeScreenData? _aboutMeScreen;
  HomeScreenData? _homeScreen;
  String addvertisement = "Advertisement";

  String? authToken;
  String? accessLevel;

  ScreenProvider(
      this.authToken, this.accessLevel, this._aboutMeScreen, this._homeScreen);

  AboutMeScreenData? get aboutMeScreen {
    return _aboutMeScreen;
  }

  HomeScreenData? get homeScreen {
    return _homeScreen;
  }

  Future<void> getHomeScreen() async {
    final url = Uri.parse("$rootLink/homescreen");
    final response = await http.get(url);
    final data = json.decode(response.body);
    _homeScreen = HomeScreenData(
        title: data["title"],
        subtitle: data["subtitle"],
        slogan: data["slogan"],
        intro: data["intro"],
        news: data["news"],
        description: data["description"],
        country: data["country"],
        county: data["county"],
        city: data["city"],
        housenum: data["housenum"],
        advertisement: data["advertisement"],
        phoneNumber: data["phone_number"],
        emailAdress: data["email_adress"],
        street: data["street"],
        postcode: data["postcode"]);

    notifyListeners();
  }

  Future<void> getAboutMeScreen() async {
    final url = Uri.parse("$rootLink/aboutmescreen");
    final response = await http.get(url);
    final data = json.decode(response.body);
    _aboutMeScreen = AboutMeScreenData(
        name: data["name"],
        briefDescription: data["brief_description"],
        longerDescription: data["longer_description"],
        educations: data["educations"],
        myVision: data["my_vision"]);
    notifyListeners();
  }

  Future<void> updateHomeScreen(Map dataToUpdate) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    final url = Uri.parse("$rootLink/homescreen/update");
    http.Response? response;
    for (String key in dataToUpdate.keys) {
      response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode({
            "token": {"access_token": authToken, "token_type": "bearer"},
            "data": {"key": key, "content": dataToUpdate[key]}
          }));
    }
    if (response != null) {
      final data = json.decode(response.body);
      _homeScreen = HomeScreenData(
          title: data["title"],
          subtitle: data["subtitle"],
          slogan: data["slogan"],
          intro: data["intro"],
          news: data["news"],
          description: data["description"],
          country: data["country"],
          county: data["county"],
          city: data["city"],
          housenum: data["housenum"],
          advertisement: data["advertisement"],
          phoneNumber: data["phone_number"],
          emailAdress: data["email_adress"],
          street: data["street"],
          postcode: data["postcode"]);
    }
    notifyListeners();
  }

  Future<void> updateAboutMeScreen(Map dataToUpdate) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    final url = Uri.parse("$rootLink/aboutmescreen/update");
    http.Response? response;
    for (String key in dataToUpdate.keys) {
      response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode({
            "token": {"access_token": authToken, "token_type": "bearer"},
            "data": {"key": key, "content": dataToUpdate[key]}
          }));
    }
    if (response != null) {
      final data = json.decode(response.body);
      _aboutMeScreen = AboutMeScreenData(
          name: data["name"],
          briefDescription: data["brief_description"],
          longerDescription: data["longer_description"],
          educations: data["educations"],
          myVision: data["my_vision"]);
    }
    notifyListeners();
  }

  Future<void> uploadNewPicture(String screen, File image) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";

    final url = Uri.parse("$rootLink/$screen/picture");

    final request = http.MultipartRequest('POST', url);
    request.headers['Content-Type'] = "multipart/form-data";
    request.headers['token'] = authToken!;
    final imageSend = await http.MultipartFile.fromPath('file', image.path);
    request.files.add(imageSend);
    final response = await request.send();
    if (response.statusCode > 400) {
      throw "Error occured";
    }
  }
}
