import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/services.dart';
import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

import 'package:reservation_app/animations/hero_dialog_route.dart';

import 'package:reservation_app/widgets/services/dropdown_button.dart';
import 'package:reservation_app/widgets/services/services_builder.dart';
import 'package:reservation_app/widgets/services/service_manage.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/drawer.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});
  static const routeName = "/services";

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool _didRun = false;
  bool _isLoading = false;
  String? selectedServiceType;
  void changeType(String key) {
    setState(() {
      selectedServiceType = key;
    });
  }

  void swithLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Services>(context, listen: false)
          .fetchAndSetServices()
          .then((_) {
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
    final appLocalization = AppLocalizations.of(context)!;
    Map items = Provider.of<Services>(context).items;

    if (!items.keys.contains(selectedServiceType)) selectedServiceType = null;
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(appLocalization.services),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.keys.isEmpty
              ? Center(
                  child: Text(appLocalization.servicesnotaw),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceChategorySelector(
                          selectedServiceType ?? items.keys.first,
                          items.keys,
                          changeType),
                      ServicesBuilder(selectedServiceType ?? items.keys.first)
                    ],
                  ),
                ),
      floatingActionButton: Provider.of<UserAuth>(context).isAuthenticatedAdmin
          ? Hero(
              tag: "add",
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                label: Text(
                  appLocalization.add,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      HeroDialogRoute(
                          builder: (context) => const ServiceManage()));
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
    );
  }
}
