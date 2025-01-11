import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import "package:reservation_app/modells/reservation_modell.dart";

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:intl/intl.dart';

class ReservationPopUp extends StatelessWidget {
  final Reservation reservation;
  final TextStyle _textStyle =
      const TextStyle(color: Colors.black, fontSize: 16);

  const ReservationPopUp(this.reservation, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Center(
        child: Hero(
            tag: reservation.id,
            child: FutureBuilder(
                future: Provider.of<DayProvider>(context, listen: false)
                    .loadAppointment(reservation.appointmentId),
                builder: ((context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 24,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.5),
                          child: Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SingleChildScrollView(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat.yMMMMd(
                                                  Localizations.localeOf(
                                                          context)
                                                      .languageCode)
                                              .format(snapshot.data!.starts),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                        Text(
                                          "${appLocalization.timeperiod}: ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(snapshot.data!.starts)} - ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(snapshot.data!.ends)}",
                                          style: _textStyle,
                                        ),
                                        Text(
                                          "${appLocalization.service}:",
                                          style: _textStyle,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Text(
                                              "${appLocalization.name}: ${reservation.data.name}\n${appLocalization.type}: ${reservation.data.type}\n${appLocalization.price}: ${reservation.data.price} ${reservation.data.comment}\n${appLocalization.duration}: ${reservation.data.duration} \n${appLocalization.servicedescription}:\n${reservation.data.description}",
                                              style: _textStyle),
                                        )
                                      ],
                                    )),
                                  ),
                          )));
                }))));
  }
}
