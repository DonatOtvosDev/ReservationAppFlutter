import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:reservation_app/animations/hero_dialog_route.dart';
import 'package:reservation_app/modells/service_modell.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:reservation_app/widgets/calendar/booking_popup.dart';
import 'package:reservation_app/widgets/calendar/reservation_info_popup.dart';
import 'package:reservation_app/widgets/calendar/reservation_info_popup_admin.dart';

import 'package:reservation_app/modells/appointment_modells.dart';

class AppointmentItem extends StatelessWidget {
  final bool _isAdmin;
  static final DateFormat _dateFormat = DateFormat("Hm");
  final Appointment appointment;
  final Function(Service serviceData, Appointment appointmentData)
      confirmBooking;
  final Function(int appointmentId, int reservationId) deleteReservation;
  const AppointmentItem(this.appointment, this.confirmBooking,
      this.deleteReservation, this._isAdmin,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Dismissible(
      key: Key(appointment.id.toString()),
      direction: _isAdmin ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      confirmDismiss: ((_) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(appLocalization.delete),
                content: Text(appLocalization.confirmappointmentdel),
                actions: [
                  TextButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        "Ok",
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                  TextButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: Text(appLocalization.cancel),
                    onPressed: () => Navigator.of(context).pop(false),
                  )
                ],
              ))),
      onDismissed: (_) => Provider.of<DayProvider>(context, listen: false)
          .deleteAppointment(appointment.id),
      child: Hero(
        tag: appointment.id,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            color: appointment.status == "free"
                ? Colors.green
                : appointment.isMyReservation || _isAdmin
                    ? Theme.of(context).primaryColor
                    : Colors.redAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_dateFormat.format(appointment.starts)} - ${_dateFormat.format(appointment.ends)}",
                      style: TextStyle(
                          color: appointment.isMyReservation
                              ? Colors.black
                              : Colors.white,
                          fontSize: 18),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      if (appointment.status == "free" && !_isAdmin)
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  HeroDialogRoute(
                                      builder: (context) =>
                                          BookingPopUp(appointment))).then(
                                  (value) => Future.delayed(
                                              const Duration(milliseconds: 301))
                                          .then((_) {
                                        if (value == null) return;
                                        return confirmBooking(
                                            value, appointment);
                                      }));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightGreen)),
                            child: Text(
                              appLocalization.book,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )),
                      if (appointment.isMyReservation ||
                          (_isAdmin && appointment.status == "reserved"))
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                HeroDialogRoute(
                                    builder: ((context) => _isAdmin
                                        ? ReservationPopUpAdmin(appointment.id)
                                        : ReservationPopUp(
                                            appointment.id)))).then((value) {
                              if (value == null) return;
                              if (value[0] == "delete") {
                                deleteReservation(value[1], appointment.id);
                              }
                            });
                          },
                          child: Icon(
                            Icons.lightbulb,
                            color: appointment.isMyReservation
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        appointment.status == "free"
                            ? Icons.event_available
                            : appointment.isMyReservation || _isAdmin
                                ? Icons.access_time_filled
                                : Icons.event_busy,
                        color: appointment.isMyReservation
                            ? Colors.black
                            : Colors.white,
                      )
                    ])
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
