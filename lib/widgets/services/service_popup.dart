import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/service_modell.dart';

const TextStyle _cardTextStyle = TextStyle(fontSize: 18, color: Colors.white);

class ServicePopUp extends StatelessWidget {
  final Service service;
  const ServicePopUp(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Center(
      child: Hero(
        tag: service.id,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
              width: MediaQuery.of(context).size.width - 24,
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: Card(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          service.name,
                          style: _cardTextStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          child: Text(
                            "${appLocalization.servicedescription}:\n${service.description}",
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${appLocalization.duration}: ${service.duration} ${appLocalization.minutes}",
                                style: _cardTextStyle,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${appLocalization.price}: ${service.price} ${service.comment}",
                                style: _cardTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
