import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reservation_app/providers/services.dart';
import 'package:reservation_app/modells/service_modell.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/animations/hero_dialog_route.dart';
import 'package:reservation_app/widgets/services/services_chategory_selector.dart';

class ServiceManage extends StatefulWidget {
  final Service? loadedService;
  const ServiceManage({this.loadedService, super.key});

  @override
  State<ServiceManage> createState() => _ServiceManageState();
}

class _ServiceManageState extends State<ServiceManage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isloading = false;
  String? serviceName;
  TextEditingController serviceChategoryController = TextEditingController();
  String? description;
  String? comment;
  int? price;
  int? duration;

  @override
  void initState() {
    if (widget.loadedService != null) {
      serviceChategoryController.text = widget.loadedService!.type;
    }
    super.initState();
  }

  @override
  void dispose() {
    serviceChategoryController.dispose();
    super.dispose();
  }

  Future<void> _submit(String errorText) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isloading = true;
    });
    try {
      if (widget.loadedService == null) {
        await Provider.of<Services>(context, listen: false).addService({
          "name": serviceName,
          "service_type": serviceChategoryController.text,
          "description": description,
          "comment": comment,
          "price": price,
          "lenght": duration
        });
      } else {
        await Provider.of<Services>(context, listen: false).updateService(
            id: widget.loadedService!.id,
            serviceName: serviceName,
            serviceChategory: {
              "new": serviceChategoryController.text,
              "old": widget.loadedService!.type
            },
            duration: duration,
            comment: comment,
            price: price,
            description: description);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
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
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Center(
        child: _isloading
            ? const CircularProgressIndicator()
            : Hero(
                tag: widget.loadedService?.id ?? "add",
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                        width: MediaQuery.of(context).size.width - 24,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.6),
                        child: Card(
                            color: Theme.of(context).colorScheme.background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                            decoration: InputDecoration(
                                                labelText: appLocalization
                                                    .servicename),
                                            initialValue:
                                                widget.loadedService?.name,
                                            validator: (value) {
                                              if (value == "") {
                                                return appLocalization.fieldreq;
                                              } else if (value!.contains(RegExp(
                                                  "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ ]"))) {
                                                return appLocalization
                                                    .invalidchar;
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              if (newValue !=
                                                  widget.loadedService?.name) {
                                                serviceName = newValue!.trim();
                                              }
                                            }),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: TextFormField(
                                                  controller:
                                                      serviceChategoryController,
                                                  decoration: InputDecoration(
                                                      labelText: appLocalization
                                                          .servicetype),
                                                  validator: (value) {
                                                    if (value == "") {
                                                      return appLocalization
                                                          .fieldreq;
                                                    } else if (value!.contains(
                                                        RegExp(
                                                            "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ]"))) {
                                                      return appLocalization
                                                          .invalidchar;
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    if (newValue !=
                                                        widget.loadedService
                                                            ?.type) {
                                                      serviceChategoryController
                                                              .text =
                                                          newValue!.trim();
                                                    }
                                                  }),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  icon: const Icon(Icons.list),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        HeroDialogRoute(
                                                            builder: ((context) =>
                                                                const CategorySelect()))).then(
                                                        (value) {
                                                      if (value != null) {
                                                        serviceChategoryController
                                                            .text = value;
                                                      }
                                                    });
                                                  },
                                                ))
                                          ],
                                        ),
                                        TextFormField(
                                            decoration: InputDecoration(
                                                labelText: appLocalization
                                                    .servicedescription),
                                            initialValue: widget
                                                .loadedService?.description,
                                            maxLines: 3,
                                            validator: (value) {
                                              if (value == "") {
                                                return appLocalization.fieldreq;
                                              } else if (value!.contains(RegExp(
                                                  "[^a-zA-ZáíéóöőúüűÁÍÉÓÖŐÚÜŰ.?+-/!\n,: ]"))) {
                                                return appLocalization
                                                    .invalidchar;
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              if (newValue !=
                                                  widget.loadedService
                                                      ?.description) {
                                                description = newValue!.trim();
                                              }
                                            }),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: appLocalization
                                                          .price),
                                                  initialValue: widget
                                                      .loadedService?.price
                                                      .toString(),
                                                  validator: (value) {
                                                    if (value == "") {
                                                      return appLocalization
                                                          .fieldreq;
                                                    } else if (value!.contains(
                                                        RegExp("[^0-9]"))) {
                                                      return appLocalization
                                                          .invalidchar;
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    if (widget.loadedService
                                                            ?.price
                                                            .toString() !=
                                                        newValue) {
                                                      price =
                                                          int.parse(newValue!);
                                                    }
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: appLocalization
                                                          .comment),
                                                  initialValue: widget
                                                      .loadedService?.comment,
                                                  onSaved: (newValue) {
                                                    if (newValue !=
                                                        widget.loadedService
                                                            ?.comment) {
                                                      comment =
                                                          newValue!.trim();
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                labelText:
                                                    appLocalization.duration),
                                            initialValue: widget
                                                .loadedService?.duration
                                                .toString(),
                                            validator: (value) {
                                              if (value == "") {
                                                return appLocalization.fieldreq;
                                              } else if (value!
                                                  .contains(RegExp("[^0-9]"))) {
                                                return appLocalization
                                                    .invalidchar;
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              if (widget.loadedService?.duration
                                                      .toString() !=
                                                  newValue) {
                                                duration = int.parse(newValue!);
                                              }
                                            }),
                                        ElevatedButton.icon(
                                          onPressed: () => _submit(
                                              appLocalization.erroroccured),
                                          label: Text(appLocalization.submit),
                                          icon:
                                              const Icon(Icons.arrow_right_alt),
                                        )
                                      ]),
                                ),
                              ),
                            ))))));
  }
}
