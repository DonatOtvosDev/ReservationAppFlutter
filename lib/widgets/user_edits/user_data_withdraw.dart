import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

class DeleteUserPopup extends StatefulWidget {
  const DeleteUserPopup({super.key});

  @override
  State<DeleteUserPopup> createState() => _DeleteUserPopupState();
}

class _DeleteUserPopupState extends State<DeleteUserPopup> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map verifcationData = {};

  Future<void> _submit(AppLocalizations appLocalization) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool? confirmed = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(appLocalization.delete),
              content: Text(appLocalization.deleteyouraccount),
              actions: [
                TextButton.icon(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
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
          .withdrawAllUserData(verifcationData);
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
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (!mounted) return;
    await Navigator.of(context).pushReplacementNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    return Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Hero(
                tag: "deleteUserPopup",
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 24,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                child: SingleChildScrollView(
                                    child: Form(
                                        key: _formKey,
                                        child: Column(children: [
                                          Text(
                                            Provider.of<UserAuth>(context)
                                                    .username ??
                                                "User",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87),
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                label: Text(
                                                    appLocalization.username)),
                                            validator: (value) {
                                              if (value == "") {
                                                return appLocalization.fieldreq;
                                              } else if (value!.length < 4) {
                                                return appLocalization
                                                    .tooshortusername;
                                              } else if (value.contains(
                                                  RegExp("[^a-z0-9]"))) {
                                                return appLocalization
                                                    .invalidchar;
                                              } else if (Provider.of<UserAuth>(
                                                          context,
                                                          listen: false)
                                                      .username! !=
                                                  value) {
                                                return appLocalization
                                                    .notcorrectusername;
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              verifcationData["username"] =
                                                  newValue!;
                                            },
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                label: Text(
                                                    appLocalization.password)),
                                            obscureText: true,
                                            validator: (value) {
                                              if (value == "") {
                                                return appLocalization.fieldreq;
                                              } else if (value!.length < 6) {
                                                return appLocalization
                                                    .tooshortpasw;
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              verifcationData["password"] =
                                                  newValue!;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ElevatedButton.icon(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red)),
                                            onPressed: () =>
                                                _submit(appLocalization),
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                            label: Text(appLocalization.delete),
                                          )
                                        ])))))))));
  }
}
