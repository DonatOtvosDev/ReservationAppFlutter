import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_app/modells/month_modell.dart';
import 'package:reservation_app/modells/day_modell.dart';

const String rootLink = "http://127.0.0.1:8000/";

class Months with ChangeNotifier {
  List<Month> _items = [];

  String? authToken;
  String? accessLevel;

  Months(this.authToken, this.accessLevel, this._items);

  get items {
    return _items;
  }

  List<Month> get awailableMonths {
    List<Month> monthsAvailable = [];
    for (Month month in _items) {
      if (month.toDate.isAfter(DateTime.now())) {
        monthsAvailable.add(month);
      }
    }
    return monthsAvailable;
  }

  Future<void> inacialiseMonth(int monthNumber, int yearNumber) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    Map requestData = {
      "token": {"access_token": authToken, "token_type": "bearer"},
      "month": {
        "year": yearNumber,
        "month_number": monthNumber,
        "return_days": false,
      }
    };
    final url = Uri.parse("$rootLink/month/get");
    try {
      final response = await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(requestData));
      if (response.statusCode != 200) {
        throw json.decode(response.body)["detail"];
      }
    } catch (error) {
      if (error != "Month with this year and month number did not found") {
        rethrow;
      }
      requestData["month"]["create_month"] = true;
      await http.post(url,
          headers: {"Content-type": "application/json"},
          body: json.encode(requestData));
    }
  }

  Future<Month> getMonth(int monthId) async {
    if (authToken == null) throw "UnAuthorised";
    final url = Uri.parse("$rootLink/month/$monthId");
    final response = await http.get(url, headers: {"token": authToken!});

    final loadedData = json.decode(response.body);
    Month loadedMonth = _items.where((month) => month.id == monthId).first;

    for (Map<String, dynamic> day in loadedData["days"]) {
      loadedMonth.days.add(Day(
          id: day["id"],
          date: DateTime.parse("${day["date"]} 00:00:00.000"),
          isWorkingDay: day["working_day"],
          monthId: monthId));
    }
    return loadedMonth;
  }

  Future<void> fetchAndSetMonths() async {
    if (authToken == null) throw "UnAuthorised";
    if (authToken == null) return;
    final url = Uri.parse("$rootLink/months");
    final response = await http.get(url, headers: {"token": authToken!});

    final List data = json.decode(response.body);

    List<Month> loadedProducts = [];
    for (Map<String, dynamic> item in data) {
      var toDate = DateTime.parse("${item["to_date"]} 00:00:00.000");
      var fromDate = DateTime.parse("${item["from_date"]} 00:00:00.000");
      loadedProducts.add(Month(
          id: item["id"],
          name: item["month_name"],
          toDate: toDate,
          fromDate: fromDate,
          days: []));
    }
    _items = loadedProducts;
  }
}
