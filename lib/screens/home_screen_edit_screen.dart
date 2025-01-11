import 'package:flutter/material.dart';

import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/modells/home_screen_modell.dart';

import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/home_screen/pickimage.dart';

import 'package:reservation_app/providers/screens.dart';
import 'package:provider/provider.dart';

class HomeScreenEdit extends StatelessWidget {
  final HomeScreenData screenData;
  const HomeScreenEdit(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(AppLocalizations.of(context)!.homescreenedit),
        requiredLogin: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: HomeScreenForm(screenData)),
    );
  }
}

class HomeScreenForm extends StatefulWidget {
  final HomeScreenData screenData;
  const HomeScreenForm(this.screenData, {super.key});

  @override
  State<HomeScreenForm> createState() => _HomeScreenFormState();
}

class _HomeScreenFormState extends State<HomeScreenForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  Map dataToUpgrade = {};

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ScreenProvider>(context, listen: false)
        .updateHomeScreen(dataToUpgrade);
    setState(() {
      _isLoading = false;
    });
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUploader("homescreen"),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.title),
                    initialValue: widget.screenData.title,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.title) {
                        dataToUpgrade["title"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.subtitle),
                    initialValue: widget.screenData.subtitle,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.subtitle) {
                        dataToUpgrade["subtitle"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.slogan),
                    initialValue: widget.screenData.slogan,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.slogan) {
                        dataToUpgrade["slogan"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.news),
                    initialValue: widget.screenData.news,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.news) {
                        dataToUpgrade["news"] = newValue!.trim();
                      }
                    },
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.white,
                  ),
                  Text(
                    "${appLocalization.exactadress}:",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 7,
                          child: TextFormField(
                            initialValue: widget.screenData.street,
                            validator: (value) {
                              if (value == "") {
                                return appLocalization.fieldreq;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != widget.screenData.street) {
                                dataToUpgrade["street"] = newValue!.trim();
                              }
                            },
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: widget.screenData.housenum,
                            validator: (value) {
                              if (value == "") {
                                return appLocalization.fieldreq;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != widget.screenData.housenum) {
                                dataToUpgrade["housenum"] = newValue!.trim();
                              }
                            },
                          ))
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 0,
                    color: Colors.white,
                  ),
                  Text(
                    "${appLocalization.county}:",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: widget.screenData.county,
                            validator: (value) {
                              if (value == "") {
                                return appLocalization.fieldreq;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != widget.screenData.county) {
                                dataToUpgrade["county"] = newValue!.trim();
                              }
                            },
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: widget.screenData.country,
                            validator: (value) {
                              if (value == "") {
                                return appLocalization.fieldreq;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != widget.screenData.country) {
                                dataToUpgrade["country"] = newValue!.trim();
                              }
                            },
                          ))
                    ],
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.phonenum),
                    initialValue: widget.screenData.phoneNumber,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.phoneNumber) {
                        dataToUpgrade["phone_number"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.emailaddrs),
                    initialValue: widget.screenData.emailAdress,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.emailAdress) {
                        dataToUpgrade["email_adress"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.intro),
                    maxLines: 5,
                    initialValue: widget.screenData.intro,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.intro) {
                        dataToUpgrade["intro"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: appLocalization.servicedescription),
                    maxLines: 20,
                    initialValue: widget.screenData.description,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.description) {
                        dataToUpgrade["description"] = newValue!.trim();
                      }
                    },
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () => _submit(),
                      icon: const Icon(Icons.save),
                      label: Text(appLocalization.submit),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
