import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_app/modells/service_modell.dart';

const String rootLink = "http://127.0.0.1:8000/";

class Services extends ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, List<Service>> _items = {};

  String? authToken;
  String? accessLevel;

  Services(this.authToken, this.accessLevel, this._items);

  Map<String, List<Service>> get items => {..._items};

  List<Service> get allServices {
    List<Service> allService = [];
    _items.forEach((key, value) {
      allService.addAll(value);
    });

    return allService;
  }

  Future<void> fetchAndSetServices() async {
    final url = Uri.parse("$rootLink/services");
    final response = await http.get(url);

    final Map data = json.decode(response.body);

    for (String key in data.keys) {
      _items[key] = [];
      for (Map<String, dynamic> item in data[key]) {
        _items[key]!.add(Service(
            id: item["id"],
            name: item["name"],
            type: item["service_type"],
            description: item["description"],
            comment: item["comment"],
            price: item["price"],
            duration: item["lenght"]));
      }
    }
  }

  Future<void> addService(Map newService) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";

    final url = Uri.parse("$rootLink/service/create");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "service": newService
        }));

    final Map data = json.decode(response.body);

    if (_items.keys.contains(data["service_type"])) {
      _items[data["service_type"]]!.add(Service(
          id: data["id"],
          name: data["name"],
          type: data["service_type"],
          description: data["description"],
          comment: data["comment"],
          price: data["price"],
          duration: data["lenght"]));
    } else {
      _items[data["service_type"]] = [
        Service(
            id: data["id"],
            name: data["name"],
            type: data["service_type"],
            description: data["description"],
            comment: data["comment"],
            price: data["price"],
            duration: data["lenght"])
      ];
    }
    notifyListeners();
  }

  Future<void> updateService({
    required int id,
    required Map serviceChategory,
    String? serviceName,
    String? description,
    String? comment,
    int? price,
    int? duration,
  }) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    if (accessLevel == null) return;
    if (accessLevel != "admin") return;
    Map pharametersToUpdate = {"id": id};
    final Service loadedProcudct = _items[serviceChategory["old"]]!
        .firstWhere((element) => element.id == id);

    if (serviceName != null) {
      pharametersToUpdate["name"] = serviceName;
    }
    if (serviceChategory["new"] != serviceChategory["old"]) {
      pharametersToUpdate["service_type"] = serviceChategory["new"];
    }
    if (description != null) {
      pharametersToUpdate["description"] = description;
    }
    if (comment != null) {
      pharametersToUpdate["comment"] = comment;
    }
    if (price != null) {
      pharametersToUpdate["price"] = price;
    }
    if (duration != null) {
      pharametersToUpdate["lenght"] = duration;
    }
    if (pharametersToUpdate.keys.length == 1) return;

    final url = Uri.parse("$rootLink/service/update");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "service": pharametersToUpdate
        }));
    if (response.statusCode > 400) return;
    final updatedService = Service(
        id: id,
        name: serviceName ?? loadedProcudct.name,
        type: serviceChategory["new"] ?? serviceChategory["old"],
        description: description ?? loadedProcudct.description,
        comment: comment ?? loadedProcudct.comment,
        price: price ?? loadedProcudct.price,
        duration: duration ?? loadedProcudct.duration);

    if (serviceChategory["old"] == serviceChategory["new"]) {
      _items[serviceChategory["old"]]!.insert(
          _items[serviceChategory["old"]]!.indexOf(loadedProcudct),
          updatedService);
    } else {
      if (_items[serviceChategory["old"]]!.length == 1) {
        _items.remove(loadedProcudct.type);
        _items[updatedService.type] = [updatedService];
      } else {
        _items[serviceChategory["old"]]!
            .removeWhere((element) => element.id == id);
        _items[updatedService.type]!.add(updatedService);
      }
      notifyListeners();
    }
  }

  Future<void> deleteService(int id, String chategory) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    if (accessLevel == null) return;
    if (accessLevel != "admin") return;

    final url = Uri.parse("$rootLink/service/delete");
    final response = await http.delete(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "service": {"id": id}
        }));
    if (response.statusCode > 400) return;
    if (_items[chategory]!.length == 1) {
      _items.remove(chategory);
    } else {
      _items[chategory]!.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }
}
