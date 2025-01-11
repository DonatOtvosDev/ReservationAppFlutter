import 'package:flutter/material.dart';

import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = "/auth";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Theme.of(context).primaryColor,
        body: const AuthForm());
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> authData = {};
  bool _isLogin = true;
  bool _isLoading = false;
  String parssw = "";
  bool _saveCredentials = false;

  Future<void> _submit(String errorText) async {
    authData = {};
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_isLogin) {
        await Provider.of<UserAuth>(context, listen: false)
            .loginUser(authData, saveCredential: _saveCredentials);
      } else if (!_isLogin) {
        await Provider.of<UserAuth>(context, listen: false)
            .registerUser(authData);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(errorText),
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
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : AnimatedContainer(
              duration: const Duration(seconds: 1),
              padding: const EdgeInsets.all(12),
              height: _isLogin
                  ? MediaQuery.of(context).size.height * 0.5
                  : MediaQuery.of(context).size.height * 0.8,
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
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: appLocalization.username),
                              validator: (value) {
                                if (value == "") {
                                  return appLocalization.fieldreq;
                                } else if (value!.length < 4) {
                                  return appLocalization.tooshortusername;
                                } else if (value
                                    .contains(RegExp("[^a-z0-9]"))) {
                                  return appLocalization.invalidchar;
                                }
                                return null;
                              },
                              onSaved: ((newValue) =>
                                  authData["username"] = newValue!.trim()),
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
                                parssw = value;
                                return null;
                              },
                              onSaved: ((newValue) =>
                                  authData["password"] = newValue!.trim()),
                            ),
                            if (!_isLogin)
                              TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: appLocalization.passwordagain),
                                  validator: (value) {
                                    if (value == "") {
                                      return appLocalization.fieldreq;
                                    } else if (value!.length < 6) {
                                      return appLocalization.tooshortpasw;
                                    } else if (parssw != "" &&
                                        parssw != value) {
                                      return appLocalization.paswnotmatch;
                                    }
                                    return null;
                                  }),
                            if (!_isLogin)
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: appLocalization.firstname),
                                      validator: (value) {
                                        if (value == "") {
                                          return appLocalization.fieldreq;
                                        } else if (value!.contains(RegExp(
                                            "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ]"))) {
                                          return appLocalization.invalidchar;
                                        }
                                        return null;
                                      },
                                      onSaved: ((newValue) =>
                                          authData["first_name"] =
                                              newValue!.trim()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText:
                                              appLocalization.secondname),
                                      validator: (value) {
                                        if (value == "") {
                                          return appLocalization.fieldreq;
                                        } else if (value!.contains(RegExp(
                                            "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ]"))) {
                                          return appLocalization.invalidchar;
                                        }
                                        return null;
                                      },
                                      onSaved: ((newValue) =>
                                          authData["sir_name"] =
                                              newValue!.trim()),
                                    ),
                                  )
                                ],
                              ),
                            if (!_isLogin)
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: appLocalization.phonenum,
                                ),
                                validator: (value) {
                                  if (value == "") {
                                    return appLocalization.fieldreq;
                                  }
                                  if (value?[0] == "+") {
                                    value = value?.substring(1);
                                  }
                                  if (value!
                                      .contains(RegExp("[^0-9]"))) {
                                    return appLocalization.invalidphone;
                                  }
                                  return null;
                                },
                                onSaved: ((newValue) =>
                                    authData["phone_number"] =
                                        newValue!.trim()),
                              ),
                            if (!_isLogin)
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: appLocalization.emailaddrs),
                                validator: (value) {
                                  if (value == "") {
                                    return appLocalization.fieldreq;
                                  } else if (!RegExp(r".+@.+\.+")
                                      .hasMatch(value!)) {
                                    return appLocalization.invalidemail;
                                  }
                                  return null;
                                },
                                onSaved: ((newValue) =>
                                    authData["email"] = newValue!.trim()),
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: (() =>
                                  _submit(appLocalization.erroroccured)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                              child: Text(
                                _isLogin
                                    ? appLocalization.signin
                                    : appLocalization.signup,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    value: _saveCredentials,
                                    onChanged: (value) {
                                      setState(() {
                                        _saveCredentials = !_saveCredentials;
                                      });
                                    }),
                                Text(appLocalization.staylogdin,
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ),
                            Text(
                              _isLogin
                                  ? appLocalization.doyounothaveacc
                                  : appLocalization.doyouhaveacc,
                              style: const TextStyle(fontSize: 16),
                            ),
                            TextButton(
                              child: Text(_isLogin
                                  ? appLocalization.signup
                                  : appLocalization.signin),
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
