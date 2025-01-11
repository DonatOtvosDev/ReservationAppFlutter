import 'package:reservation_app/modells/service_modell.dart';

class Reservation {
  final int id;
  final int userId;
  final int appointmentId;
  final DateTime submited;
  final Service data;
  Reservation(
      {required this.id,
      required this.userId,
      required this.appointmentId,
      required this.submited,
      required this.data});
}
