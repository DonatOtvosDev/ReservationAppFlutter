import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

class EditPaswPopup extends StatefulWidget {
  const EditPaswPopup({super.key});

  @override
  State<EditPaswPopup> createState() => _EditPaswPopupState();
}

class _EditPaswPopupState extends State<EditPaswPopup> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map passwords = {};
  String pasw = "";

  Future<void> _submit(AppLocalizations appLocalization) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool? confirmed = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(appLocalization.confirm),
              content: Text(appLocalization.passwordconfirm),
              actions: [
                TextButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text(
                      "Ok",
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    }),
                TextButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: Text(appLocalization.cancel),
                  onPressed: () => Navigator.of(context).pop(false),
                )
              ],
            ));

    if (confirmed == false) {
      if (!mounted) return;
      Navigator.of(context).pop();
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (!mounted) return;
      await Provider.of<UserAuth>(context, listen: false)
          .changePassword(passwords);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(appLocalization.erroroccured),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Ok'))
                ],
              ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Hero(
                tag: "menuPopup",
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 24,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.4),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                child: SingleChildScrollView(
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Text(
                                              appLocalization.changepasw,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87),
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  label: Text(appLocalization
                                                      .password)),
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == "") {
                                                  return appLocalization
                                                      .fieldreq;
                                                } else if (value!.length < 6) {
                                                  return appLocalization
                                                      .tooshortpasw;
                                                }
                                                return null;
                                              },
                                              onSaved: (newValue) {
                                                passwords["old_password"] =
                                                    newValue;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  label: Text(
                                                      "${appLocalization.newtext} ${appLocalization.password}")),
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == "") {
                                                  return appLocalization
                                                      .fieldreq;
                                                } else if (value!.length < 6) {
                                                  return appLocalization
                                                      .tooshortpasw;
                                                }
                                                pasw = value;
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                  label: Text(
                                                      "${appLocalization.newtext} ${appLocalization.passwordagain}")),
                                              obscureText: true,
                                              validator: (value) {
                                                if (value == "") {
                                                  return appLocalization
                                                      .fieldreq;
                                                } else if (value!.length < 6) {
                                                  return appLocalization
                                                      .tooshortpasw;
                                                } else if (value != pasw) {
                                                  return appLocalization
                                                      .paswnotmatch;
                                                }

                                                return null;
                                              },
                                              onSaved: (newValue) {
                                                passwords["new_password"] =
                                                    newValue;
                                              },
                                            ),
                                            Divider(
                                              height: 15,
                                              thickness: 0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                            ElevatedButton.icon(
                                                onPressed: () =>
                                                    _submit(appLocalization),
                                                icon: const Icon(Icons.save),
                                                label: Text(
                                                    appLocalization.change))
                                          ],
                                        ))))))),
              ));
  }
}
