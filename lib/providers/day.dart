import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:reservation_app/modells/day_modell.dart';
import 'package:reservation_app/modells/appointment_modells.dart';
import 'package:reservation_app/modells/reservation_modell.dart';
import 'package:reservation_app/modells/service_modell.dart';

const String rootLink = "http://127.0.0.1:8000/";

class DayProvider with ChangeNotifier {
  int? _id;
  DateTime? _date;
  bool? _isWorkingDay;
  int? _monthId;
  String? _name;
  List<Appointment> _appointments = [];
  List<Reservation> _myreservations = [];
  List<Day> _workingDays = [];

  String? authToken;
  String? accessLevel;

  DayProvider(this.authToken, this.accessLevel);

  LoadedDay? get dayLoaded {
    if (_id == null) return null;
    return LoadedDay(
        id: _id!,
        date: _date!,
        isWorkingDay: _isWorkingDay!,
        name: _name!,
        monthId: _monthId!,
        appointments: _appointments);
  }

  List<Day> get workingDays {
    return _workingDays;
  }

  List<Reservation> get myreservation {
    return _myreservations;
  }

  void resetDay() {
    _id = null;
    _date = null;
    _isWorkingDay = null;
    _monthId = null;
    _name = null;
    _appointments = [];
    _myreservations = [];
  }

  Reservation reservationByApointmentId(int appointmentId) {
    return _myreservations
        .firstWhere((res) => res.appointmentId == appointmentId);
  }

  Future<Reservation> loadReservationByAppointmentId(int appointmentId) async {
    if (authToken == null) throw "UnAuthorised";
    final url = Uri.parse("$rootLink/appointment/$appointmentId");
    final response = await http.get(url, headers: {"token": authToken!});
    final responseData = json.decode(response.body)["reservations"][0];

    return Reservation(
        id: responseData["id"],
        userId: responseData["user_id"],
        appointmentId: responseData["appointment_id"],
        submited: DateTime.parse(responseData["submitted"]),
        data: Service(
          id: responseData["reservation_data"]["id"],
          name: responseData["reservation_data"]["name"],
          type: responseData["reservation_data"]["service_type"],
          description: responseData["reservation_data"]["description"],
          comment: responseData["reservation_data"]["comment"],
          price: responseData["reservation_data"]["price"],
          duration: responseData["reservation_data"]["lenght"],
        ));
  }

  Future<Appointment> loadAppointment(int appointmentId) async {
    if (authToken == null) throw "UnAuthorised";
    final url = Uri.parse("$rootLink/appointment/$appointmentId");
    final response = await http.get(url, headers: {"token": authToken!});

    final responseData = json.decode(response.body);

    return Appointment(
        id: appointmentId,
        starts: DateTime.parse(responseData["starts"]),
        ends: DateTime.parse(responseData["ends"]),
        status: "reserved",
        dayId: responseData["day_id"],
        isMyReservation: true);
  }

  Future<void> deleteAppointment(int appointmentId) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    final url = Uri.parse("$rootLink/appointment/delete");
    final response = await http.delete(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "appointment": {"appointment_id": appointmentId}
        }));
    if (response.statusCode > 400) return;
    _appointments.removeWhere((appoint) => appoint.id == appointmentId);
    if (_appointments.isEmpty) {
      _isWorkingDay = false;
      _workingDays.removeWhere((d) => d.id == _id);
    }
    notifyListeners();
  }

  Future<void> addAppointment(TimeOfDay starts, TimeOfDay ends) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    DateTime startsDate = DateTime(
        _date!.year, _date!.month, _date!.day, starts.hour, starts.minute);
    DateTime endsDate =
        DateTime(_date!.year, _date!.month, _date!.day, ends.hour, ends.minute);
    final Map appointmentData = {
      "starts": startsDate.toIso8601String(),
      "ends": endsDate.toIso8601String(),
      "day_id": _id
    };

    if (_appointments
        .where((appointment) =>
            appointment.starts.isAfter(startsDate) &&
            appointment.starts.isBefore(endsDate))
        .isNotEmpty) throw "invalidtime";
    if (_appointments
        .where((appointment) =>
            appointment.starts.isBefore(startsDate) &&
            appointment.ends.isAfter(startsDate))
        .isNotEmpty) throw "invalidtime";

    final url = Uri.parse("$rootLink/appointment/create");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "appointment": appointmentData
        }));

    final responseData = json.decode(response.body);
    _isWorkingDay = true;
    if (_workingDays.where((element) => element.id == _id).isEmpty) {
      final index = _workingDays.indexWhere((e) => (e.date.isAfter(_date!) &&
          (_workingDays.indexOf(e) == 0 ||
              _workingDays[_workingDays.indexOf(e) - 1]
                  .date
                  .isBefore(_date!))));

      if (index < 0) {
        _workingDays.add(Day(
            id: _id!,
            date: _date!,
            isWorkingDay: _isWorkingDay!,
            monthId: _monthId!,
            name: _name));
      } else {
        _workingDays.insert(
            index,
            Day(
                id: _id!,
                date: _date!,
                isWorkingDay: _isWorkingDay!,
                monthId: _monthId!,
                name: _name));
      }
    }

    _appointments.add(Appointment(
        id: responseData["id"],
        starts: DateTime.parse(responseData["starts"]),
        ends: DateTime.parse(responseData["ends"]),
        status: responseData["status"],
        dayId: _id!,
        isMyReservation: false));
    _appointments.sort(((a, b) {
      return a.starts.compareTo(b.starts);
    }));
    notifyListeners();
  }

  Future<void> fetchAndSetWorkingDays() async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    _workingDays = [];
    final url = Uri.parse("$rootLink/getworkingdays");
    final response = await http.get(url, headers: {"token": authToken!});

    final List loadedData = json.decode(response.body);

    for (Map<String, dynamic> day in loadedData) {
      _workingDays.add(Day(
          id: day["id"],
          date: DateTime.parse(day["date"]),
          isWorkingDay: true,
          monthId: day["month_id"],
          name: day["day_name"]));
    }
    notifyListeners();
  }

  Future<void> loadMyReservations() async {
    if (authToken == null) throw "UnAuthorised";
    if (accessLevel == "admin") return;
    final url = Uri.parse("$rootLink/reservations/me");
    final response = await http.get(url, headers: {"token": authToken!});

    final List loadedData = json.decode(response.body) as List;

    _myreservations = [];
    for (Map<String, dynamic> reservation in loadedData) {
      _myreservations.add(Reservation(
          id: reservation["id"],
          userId: reservation["user_id"],
          appointmentId: reservation["appointment_id"],
          submited: DateTime.parse(reservation["submitted"]),
          data: Service(
            id: reservation["reservation_data"]["id"],
            name: reservation["reservation_data"]["name"],
            type: reservation["reservation_data"]["service_type"],
            description: reservation["reservation_data"]["description"],
            comment: reservation["reservation_data"]["comment"],
            price: reservation["reservation_data"]["price"],
            duration: reservation["reservation_data"]["lenght"],
          )));
    }
    notifyListeners();
  }

  Future<void> submitReservation(int appointmentId, Service serviceData) async {
    if (authToken == null || accessLevel == "admin") throw "UnAuthorised";
    final reservationData = {
      "name": serviceData.name,
      "service_type": serviceData.type,
      "description": serviceData.description,
      "comment": serviceData.comment,
      "price": serviceData.price,
      "lenght": serviceData.duration,
      "id": serviceData.id
    };
    final url = Uri.parse("$rootLink/reservation/create");
    final response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "reservation": {
            "appointment_id": appointmentId,
            "reservation_data": reservationData
          }
        }));

    final reservation = json.decode(response.body);

    final Appointment oldAppointment =
        _appointments.firstWhere((appoint) => appoint.id == appointmentId);

    _appointments.insert(
        _appointments.indexOf(oldAppointment),
        Appointment(
            id: appointmentId,
            starts: oldAppointment.starts,
            ends: oldAppointment.ends,
            status: "reserved",
            dayId: _id!,
            isMyReservation: true));
    _appointments.remove(oldAppointment);

    _myreservations.add(Reservation(
        id: reservation["id"],
        userId: reservation["user_id"],
        appointmentId: reservation["appointment_id"],
        submited: DateTime.parse(reservation["submitted"]),
        data: Service(
          id: reservation["reservation_data"]["id"],
          name: reservation["reservation_data"]["name"],
          type: reservation["reservation_data"]["service_type"],
          description: reservation["reservation_data"]["description"],
          comment: reservation["reservation_data"]["comment"],
          price: reservation["reservation_data"]["price"],
          duration: reservation["reservation_data"]["lenght"],
        )));

    notifyListeners();
  }

  Future<void> deleteReservation(int reservationId, int appointmentId) async {
    if (authToken == null || accessLevel != "admin") throw "UnAuthorised";
    final url = Uri.parse("$rootLink/reservation/delete");
    final response = await http.delete(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "token": {"access_token": authToken, "token_type": "bearer"},
          "reservation": {"reservation_id": reservationId}
        }));
    if (response.statusCode > 400) return;
    final Appointment oldAppointment =
        _appointments.firstWhere((appoint) => appoint.id == appointmentId);

    _appointments.insert(
        _appointments.indexOf(oldAppointment),
        Appointment(
            id: appointmentId,
            starts: oldAppointment.starts,
            ends: oldAppointment.ends,
            status: "free",
            dayId: _id!,
            isMyReservation: false));
    _appointments.remove(oldAppointment);
    notifyListeners();
  }

  Future<void> loadDay(DateTime date) async {
    if (authToken == null) throw "UnAuthorised";
    await loadMyReservations();
    final dateToSend = "${date.year}-${date.month}-${date.day}";

    final url = Uri.parse("$rootLink/getday/$dateToSend");
    final response = await http.get(url, headers: {"token": authToken!});

    final Map<String, dynamic> loadedData = json.decode(response.body);

    _id = loadedData["id"]!;
    _date = DateTime.parse(loadedData["date"]);
    _isWorkingDay = loadedData["working_day"]!;
    _name = loadedData["day_name"]!;
    _monthId = loadedData["month_id"]!;
    _appointments = [];
    bool isMyReservation = false;

    for (Map<String, dynamic> apointment in loadedData["appointments"]) {
      isMyReservation = false;
      if (apointment["status"] == "reserved") {
        if (_myreservations
            .where((res) => res.appointmentId == apointment["id"])
            .isNotEmpty) {
          isMyReservation = true;
        }
      }
      _appointments.add(Appointment(
          id: apointment["id"],
          starts: DateTime.parse(apointment["starts"]),
          ends: DateTime.parse(apointment["ends"]),
          status: apointment["status"],
          dayId: _id!,
          isMyReservation: isMyReservation));
    }

    _appointments.sort(((a, b) {
      return a.starts.compareTo(b.starts);
    }));

    notifyListeners();
  }
}
