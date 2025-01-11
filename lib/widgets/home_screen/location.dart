import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/home_screen_modell.dart';

class HomeScreenLocation extends StatelessWidget {
  final HomeScreenData screenData;
  const HomeScreenLocation(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          gradient: const LinearGradient(
              begin: Alignment(0.2, 1),
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(131, 59, 106, 1),
                Color.fromRGBO(165, 108, 144, 1),
              ]),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          )),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          "${localization.location}:\n ${localization.exactadress}: ${screenData.street} ${screenData.housenum}\n ${screenData.city} ${screenData.postcode}\n ${localization.county}: ${screenData.county} ${screenData.country}\n${localization.contact}:\n ${localization.phonenum}: ${screenData.phoneNumber}\n ${localization.emailaddrs}: ${screenData.emailAdress}",
          style: const TextStyle(color: Colors.white, fontSize: 15),
          textAlign: TextAlign.left,
          softWrap: true,
        ),
      ),
    );
  }
}
