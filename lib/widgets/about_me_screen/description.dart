import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/about_me_screen_modell.dart';

class AboutMeScreenDescription extends StatelessWidget {
  final AboutMeScreenData screenData;
  const AboutMeScreenDescription(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(168, 68, 72, 1),
                  Color.fromRGBO(233, 161, 120, 1)
                ]),
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Text(
          "${AppLocalizations.of(context)!.servicedescription}:\n${screenData.longerDescription}",
          textAlign: TextAlign.justify,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ));
  }
}
