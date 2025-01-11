import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/screens/login_screen.dart';
import 'package:reservation_app/screens/account_edit_screen.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

import 'package:reservation_app/widgets/user_edits/change_passw.dart';
import 'package:reservation_app/animations/hero_dialog_route.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appbar;
  final Text title;
  final List<Widget> actionButtons;
  final bool requiredLogin;

  const MyAppBar(this.actionButtons,
      {required this.appbar,
      required this.title,
      this.requiredLogin = false,
      super.key});

  @override
  Size get preferredSize => appbar.preferredSize;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).colorScheme.secondary;
    return AppBar(
      title: title,
      actions: [
        ...actionButtons,
        Consumer<UserAuth>(
            builder: (ctx, auth, _) => !auth.isAuthenticated
                ? ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(LoginScreen.routeName),
                    icon: const Icon(Icons.person),
                    label: Text(appLocalization.login))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        auth.username!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      PopupMenuButton(
                          padding: const EdgeInsets.all(0),
                          onSelected: (value) {
                            if (value == "changePasw") {
                              Navigator.push(
                                  context,
                                  HeroDialogRoute(
                                      builder: (context) =>
                                          const EditPaswPopup()));
                            } else if (value == "logOut") {
                              showDialog(
                                  context: context,
                                  builder: ((context) => AlertDialog(
                                        title: Text(appLocalization.logout),
                                        content:
                                            Text(appLocalization.logoutconfirm),
                                        actions: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.cancel),
                                            label: Text(appLocalization.cancel),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                          ),
                                          TextButton.icon(
                                              icon: const Icon(Icons.logout),
                                              label: Text(
                                                appLocalization.logout,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              }),
                                        ],
                                      ))).then((confirm) {
                                if (confirm == null) {
                                  return;
                                }
                                if (confirm) {
                                  if (requiredLogin) {
                                    auth.logOut();
                                    Navigator.of(context)
                                        .pushReplacementNamed("/aboutme");
                                  } else {
                                    auth.logOut();
                                  }
                                }
                              });
                            } else if (value == "edit") {
                              Navigator.of(context)
                                  .pushNamed(AccountEditScreen.routeName);
                            }
                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          appLocalization.editaccount,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryColor),
                                        ),
                                      ],
                                    )),
                                PopupMenuItem(
                                    value: "changePasw",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.password,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          appLocalization.changepasw,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryColor),
                                        ),
                                      ],
                                    )),
                                PopupMenuItem(
                                    value: "logOut",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_add_disabled,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          appLocalization.logout,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryColor),
                                        ),
                                      ],
                                    ))
                              ]),
                    ],
                  ))
      ],
    );
  }
}
