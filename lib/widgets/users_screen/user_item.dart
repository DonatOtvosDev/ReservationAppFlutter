import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/user_info_modell.dart';

class UserItem extends StatelessWidget {
  final UserData userData;
  final Function allowUser;
  final Function bannUser;
  const UserItem(this.userData, this.allowUser, this.bannUser, {super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final keys = {
      "user": appLocalizations.users,
      "banneduser": appLocalizations.bannedusers,
      "admin": appLocalizations.admins
    };
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: userData.status == "user"
                  ? Theme.of(context).colorScheme.primary
                  : userData.status == "banneduser"
                      ? Colors.red
                      : Colors.blue,
              width: 5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "${appLocalizations.username}: ${userData.userName}     ${appLocalizations.accesslevel}: ${keys[userData.status]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            const SizedBox(height: 5),
            SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                      "${appLocalizations.firstname}: ${userData.firstName}     ${appLocalizations.secondname}: ${userData.sirName}"),
                )),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${appLocalizations.emailaddrs}:"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(userData.email),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("${appLocalizations.phonenum}:"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text("+${userData.phoneNumber}"),
                          ),
                        )
                      ]),
                ),
                Expanded(
                    flex: 2,
                    child: userData.status == "admin"
                        ? Container()
                        : TextButton.icon(
                            onPressed: () {
                              if (userData.status == "user") {
                                bannUser(userData.id);
                              } else {
                                allowUser(userData.id);
                              }
                            },
                            icon: userData.status == "user"
                                ? const Icon(
                                    Icons.do_not_disturb_on,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.add_reaction,
                                    color: Colors.black,
                                  ),
                            label: userData.status == "user"
                                ? FittedBox(
                                    child: Text(appLocalizations.bann,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  )
                                : FittedBox(
                                    child: Text(
                                    appLocalizations.allowuser,
                                    style: const TextStyle(color: Colors.black),
                                  )))),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
