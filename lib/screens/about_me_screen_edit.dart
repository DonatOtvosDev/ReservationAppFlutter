import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/home_screen/pickimage.dart';

import 'package:reservation_app/modells/about_me_screen_modell.dart';

import 'package:reservation_app/providers/screens.dart';
import 'package:provider/provider.dart';

class AboutMeScreenEdit extends StatelessWidget {
  final AboutMeScreenData screenData;
  const AboutMeScreenEdit(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(AppLocalizations.of(context)!.aboutmescreenedit),
        requiredLogin: true,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: AboutMeScreenForm(screenData)),
    );
  }
}

class AboutMeScreenForm extends StatefulWidget {
  final AboutMeScreenData screenData;
  const AboutMeScreenForm(this.screenData, {super.key});

  @override
  State<AboutMeScreenForm> createState() => _AboutMeScreenFormState();
}

class _AboutMeScreenFormState extends State<AboutMeScreenForm> {
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
        .updateAboutMeScreen(dataToUpgrade);
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
                  ImageUploader("aboutmescreen"),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.name),
                    initialValue: widget.screenData.name,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.name) {
                        dataToUpgrade["name"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.educations),
                    initialValue: widget.screenData.educations,
                    maxLines: 2,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.educations) {
                        dataToUpgrade["educations"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.myvision),
                    maxLines: 5,
                    initialValue: widget.screenData.myVision,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.myVision) {
                        dataToUpgrade["my_vision"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: appLocalization.intro),
                    maxLines: 5,
                    initialValue: widget.screenData.briefDescription,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.briefDescription) {
                        dataToUpgrade["brief_description"] = newValue!.trim();
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: appLocalization.servicedescription),
                    maxLines: 15,
                    initialValue: widget.screenData.longerDescription,
                    validator: (value) {
                      if (value == "") {
                        return appLocalization.fieldreq;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != widget.screenData.longerDescription) {
                        dataToUpgrade["longer_description"] = newValue!.trim();
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
                  )
                ],
              ),
            ),
          );
  }
}
