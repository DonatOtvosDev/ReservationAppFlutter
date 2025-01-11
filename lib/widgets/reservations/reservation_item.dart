import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/reservation_modell.dart';
import 'package:reservation_app/animations/hero_dialog_route.dart';
import 'package:reservation_app/widgets/reservations/reservation_popup.dart';

import 'package:intl/intl.dart';

class ReservationItem extends StatelessWidget {
  final Reservation reservation;
  const ReservationItem(this.reservation, {super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat =
        DateFormat("y-M-dd H:mm", Localizations.localeOf(context).languageCode);
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.all(5),
      child: Hero(
        tag: reservation.id,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary)),
          onPressed: () => Navigator.push(
              context,
              HeroDialogRoute(
                  builder: ((context) => ReservationPopUp(reservation)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reservation.data.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                    "${AppLocalizations.of(context)!.submitted}: ${dateFormat.format(reservation.submited)}",
                    style: const TextStyle(color: Colors.black, fontSize: 14)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
