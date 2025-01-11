import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/about_me_screen_modell.dart';

class AboutMeBody extends StatelessWidget {
  final AboutMeScreenData screenData;
  const AboutMeBody(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          gradient: LinearGradient(
              begin: const Alignment(0.2, 1),
              end: Alignment.topRight,
              colors: [
                Theme.of(context).colorScheme.secondary,
                const Color.fromRGBO(131, 59, 106, 1)
              ]),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.myvision}:\n${screenData.myVision}",
            style: const TextStyle(color: Colors.white, fontSize: 17),
            textAlign: TextAlign.justify,
          ),
          const Divider(
            height: 16,
            thickness: 2,
            color: Colors.white,
          ),
          Text(
            "${AppLocalizations.of(context)!.educations}:\n${screenData.educations}",
            style: const TextStyle(color: Colors.white, fontSize: 17),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}
