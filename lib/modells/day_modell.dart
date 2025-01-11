import 'package:reservation_app/modells/appointment_modells.dart';

class Day {
  final int id;
  final DateTime date;
  final bool isWorkingDay;
  final int monthId;
  final String? name;

  Day(
      {required this.id,
      required this.date,
      required this.isWorkingDay,
      required this.monthId,
      this.name});
}

class LoadedDay {
  final int id;
  final DateTime date;
  final bool isWorkingDay;
  final String name;
  final int monthId;
  final List<Appointment> appointments;

  LoadedDay(
      {required this.id,
      required this.date,
      required this.isWorkingDay,
      required this.name,
      required this.monthId,
      required this.appointments});
}
