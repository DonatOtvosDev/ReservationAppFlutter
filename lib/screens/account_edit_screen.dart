import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/user_edits/user_data_withdraw.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/users.dart';

import 'package:reservation_app/animations/hero_dialog_route.dart';

import 'package:reservation_app/modells/user_info_modell.dart';

class AccountEditScreen extends StatefulWidget {
  static const routeName = "/editaccount";
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  bool _didRun = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map dataToUpdate = {};

  Future<void> _submit(AppLocalizations appLocalization) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (dataToUpdate.keys.length == 1) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<UsersProvider>(context, listen: false)
          .updateUserInfo(dataToUpdate);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
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
  }

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UsersProvider>(context, listen: false).loadMyUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _didRun = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final UserInfo? currentUserData =
        Provider.of<UsersProvider>(context).myData;
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(appLocalization.editaccount),
        requiredLogin: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Container(
                  padding: const EdgeInsets.all(15),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentUserData!.userName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  appLocalization.firstname),
                                          initialValue:
                                              currentUserData.firstName,
                                          validator: (value) {
                                            if (value == "") {
                                              return appLocalization.fieldreq;
                                            } else if (value!.contains(RegExp(
                                                "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ]"))) {
                                              return appLocalization
                                                  .invalidchar;
                                            }
                                            return null;
                                          },
                                          onSaved: ((newValue) {
                                            if (newValue ==
                                                currentUserData.firstName) {
                                              return;
                                            }
                                            dataToUpdate["first_name"] =
                                                newValue!.trim();
                                          })),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText:
                                                appLocalization.secondname),
                                        initialValue: currentUserData.sirName,
                                        validator: (value) {
                                          if (value == "") {
                                            return appLocalization.fieldreq;
                                          } else if (value!.contains(RegExp(
                                              "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ]"))) {
                                            return appLocalization.invalidchar;
                                          }
                                          return null;
                                        },
                                        onSaved: ((newValue) {
                                          if (newValue ==
                                              currentUserData.sirName) {
                                            return;
                                          }
                                          dataToUpdate["sir_name"] =
                                              newValue!.trim();
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: appLocalization.phonenum,
                                  ),
                                  initialValue: currentUserData.phoneNumber,
                                  validator: (value) {
                                    if (value?[0] == "+") {
                                      value = value?.substring(1);
                                    }
                                    if (value == "") {
                                      return appLocalization.fieldreq;
                                    } else if (value!
                                        .contains(RegExp("[^0-9]"))) {
                                      return appLocalization.invalidphone;
                                    }
                                    return null;
                                  },
                                  onSaved: ((newValue) {
                                    if (newValue ==
                                        currentUserData.phoneNumber) {
                                      return;
                                    }
                                    dataToUpdate["phone_number"] =
                                        newValue!.trim();
                                  }),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: appLocalization.emailaddrs),
                                  initialValue: currentUserData.email,
                                  validator: (value) {
                                    if (value == "") {
                                      return appLocalization.fieldreq;
                                    } else if (!RegExp(r".+@.+\.+")
                                        .hasMatch(value!)) {
                                      return appLocalization.invalidemail;
                                    }
                                    return null;
                                  },
                                  onSaved: ((newValue) {
                                    if (newValue == currentUserData.email) {
                                      return;
                                    }
                                    dataToUpdate["email"] = newValue!.trim();
                                  }),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: appLocalization.password),
                                  validator: (value) {
                                    if (value == "") {
                                      return appLocalization.fieldreq;
                                    } else if (value!.length < 6) {
                                      return appLocalization.tooshortpasw;
                                    }
                                    return null;
                                  },
                                  onSaved: ((newValue) =>
                                      dataToUpdate["password"] =
                                          newValue!.trim()),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton.icon(
                                    onPressed: () => _submit(appLocalization),
                                    icon: const Icon(Icons.save),
                                    label: Text(appLocalization.change)),
                                Hero(
                                  tag: "deleteUserPopup",
                                  child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            HeroDialogRoute(
                                                builder: (ctx) =>
                                                    const DeleteUserPopup()));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        appLocalization.deleteaccountbutton,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                )),
      drawer: const AppDrawer(),
    );
  }
}
