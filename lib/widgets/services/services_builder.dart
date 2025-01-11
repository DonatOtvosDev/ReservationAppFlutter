import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/service_modell.dart';

import 'package:reservation_app/animations/hero_dialog_route.dart';
import 'package:reservation_app/widgets/services/service_popup.dart';
import 'package:reservation_app/widgets/services/service_manage.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:reservation_app/providers/services.dart';
import 'package:provider/provider.dart';

class ServicesBuilder extends StatelessWidget {
  final String dirKey;
  const ServicesBuilder(this.dirKey, {super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final isAdmin = Provider.of<UserAuth>(context).isAuthenticatedAdmin;
    List<Service> items = Provider.of<Services>(context).items[dirKey]!;
    return SizedBox(
      height: MediaQuery.of(context).size.height - 220,
      width: double.infinity,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: ((context, i) => Hero(
              tag: items[i].id,
              child: Dismissible(
                background: Container(
                  color: Theme.of(context).primaryColorDark,
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  width: double.infinity,
                  height: 45,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                direction: isAdmin
                    ? DismissDirection.horizontal
                    : DismissDirection.none,
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    Provider.of<Services>(context, listen: false)
                        .deleteService(items[i].id, items[i].type);
                  }
                },
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    return Navigator.push(
                        context,
                        HeroDialogRoute(
                            builder: (context) =>
                                ServiceManage(loadedService: items[i])));
                  } else {
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text(appLocalization.delete),
                              content: Text(appLocalization.confirmservicedel),
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
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                )
                              ],
                            ));
                  }
                },
                key: ValueKey(items[i].id),
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  height: 45,
                  padding: const EdgeInsets.all(3),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: (() => Navigator.push(
                        context,
                        HeroDialogRoute(
                            builder: (context) => ServicePopUp(items[i])))),
                    child: Text(
                      items[i].name,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
