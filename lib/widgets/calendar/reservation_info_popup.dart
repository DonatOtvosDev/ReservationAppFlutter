import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import "package:reservation_app/modells/reservation_modell.dart";

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:intl/intl.dart';

class ReservationPopUp extends StatelessWidget {
  final int appointmentId;
  final TextStyle _textStyle =
      const TextStyle(color: Colors.black, fontSize: 16);

  const ReservationPopUp(this.appointmentId, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    DateFormat dateFormat =
        DateFormat("H:m y-M-d", Localizations.localeOf(context).languageCode);
    final Reservation reservation = Provider.of<DayProvider>(context)
        .reservationByApointmentId(appointmentId);
    return Center(
        child: Hero(
            tag: appointmentId,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 24,
                    height: MediaQuery.of(context).size.height * 0.5 > 230
                        ? 230
                        : MediaQuery.of(context).size.height * 0.5,
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMd(Localizations.localeOf(context)
                                      .languageCode)
                                  .format(Provider.of<DayProvider>(context)
                                      .dayLoaded!
                                      .date),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 22),
                            ),
                            Text(
                              "${appLocalization.submitted}: ${dateFormat.format(reservation.submited)}",
                              style: _textStyle,
                            ),
                            Text(
                              "${appLocalization.service}:",
                              style: _textStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                  "${appLocalization.name}: ${reservation.data.name}\n${appLocalization.type}: ${reservation.data.type}\n${appLocalization.price}: ${reservation.data.price} ${reservation.data.comment}\n${appLocalization.duration}: ${reservation.data.duration} \n${appLocalization.servicedescription}:\n${reservation.data.description}",
                                  style: _textStyle),
                            )
                          ],
                        )),
                      ),
                    )))));
  }
}
