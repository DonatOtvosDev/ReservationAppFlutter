import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/about_me_screen_modell.dart';

class AboutMeHeader extends StatelessWidget {
  final AboutMeScreenData screenData;
  const AboutMeHeader(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          gradient: const LinearGradient(
              begin: Alignment(0, 1),
              end: Alignment.topLeft,
              colors: [
                Color.fromRGBO(233, 161, 120, 1),
                Color.fromRGBO(168, 68, 72, 1),
                Color.fromRGBO(131, 59, 106, 1)
              ]),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.60,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              screenData.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Divider(
          height: 15,
          thickness: 1,
          color: Colors.white,
        ),
        Text(
          "${AppLocalizations.of(context)!.shortintro}: ${screenData.briefDescription}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.justify,
        )
      ]),
    );
  }
}
