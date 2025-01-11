import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import "package:reservation_app/modells/reservation_modell.dart";

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:intl/intl.dart';

class ReservationPopUpAdmin extends StatefulWidget {
  final int appointmentId;

  const ReservationPopUpAdmin(this.appointmentId, {super.key});

  @override
  State<ReservationPopUpAdmin> createState() => _ReservationPopUpAdminState();
}

class _ReservationPopUpAdminState extends State<ReservationPopUpAdmin> {
  DateFormat _dateFormat = DateFormat("H:m y-M-d");
  final TextStyle _textStyle =
      const TextStyle(color: Colors.black, fontSize: 16);
  Reservation? reservation;
  bool _isLoading = false;
  bool _didRun = false;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DayProvider>(context, listen: false)
          .loadReservationByAppointmentId(widget.appointmentId)
          .then((reserv) {
        reservation = reserv;
        setState(() {
          _dateFormat = DateFormat(
              "H:m y-M-d", Localizations.localeOf(context).languageCode);
          _isLoading = false;
          _didRun = true;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Center(
        child: Hero(
            tag: widget.appointmentId,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 24,
                    height: MediaQuery.of(context).size.height * 0.5 > 230
                        ? 230
                        : MediaQuery.of(context).size.height * 0.5,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Card(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(
                                            Provider.of<DayProvider>(context)
                                                .dayLoaded!
                                                .date),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                        appLocalization.delete),
                                                    content: Text(appLocalization
                                                        .confirmreservationdel),
                                                    actions: [
                                                      TextButton.icon(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          label: const Text(
                                                            "Ok",
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          }),
                                                      TextButton.icon(
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                        label: Text(
                                                            appLocalization
                                                                .cancel),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                      )
                                                    ],
                                                  )).then((value) {
                                            if (!value) return;
                                            Navigator.of(context).pop(
                                                ["delete", reservation!.id]);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${appLocalization.submitted}: ${_dateFormat.format(reservation!.submited)}",
                                    style: _textStyle,
                                  ),
                                  Text(
                                    "${appLocalization.service}:",
                                    style: _textStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Text(
                                        "${appLocalization.name}: ${reservation!.data.name}\n${appLocalization.type}: ${reservation!.data.type}\n${appLocalization.price}: ${reservation!.data.price} ${reservation!.data.comment}\n${appLocalization.duration}: ${reservation!.data.duration} \n${appLocalization.servicedescription}:\n${reservation!.data.description}",
                                        style: _textStyle),
                                  )
                                ],
                              )),
                            ),
                          )))));
  }
}
