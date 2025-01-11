import 'package:reservation_app/modells/day_modell.dart';

class Month {
  final int id;
  final String name;
  final DateTime fromDate;
  final DateTime toDate;
  List<Day> days;

  Month(
      {required this.id,
      required this.fromDate,
      required this.name,
      required this.toDate,
      required this.days});
}
