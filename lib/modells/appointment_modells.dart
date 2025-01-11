class Appointment {
  final int id;
  final DateTime starts;
  final DateTime ends;
  final String status;
  final int dayId;
  final bool isMyReservation;

  Appointment(
      {required this.id,
      required this.starts,
      required this.ends,
      required this.status,
      required this.dayId,
      required this.isMyReservation});
}
