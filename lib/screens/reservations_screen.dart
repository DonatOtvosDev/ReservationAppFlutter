import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/day.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';

import 'package:reservation_app/widgets/reservations/reservation_item.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});
  static const routeName = "/myreservations";
  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  bool _isLoading = false;
  bool _didRun = false;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DayProvider>(context, listen: false)
          .loadMyReservations()
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(appLocalization.myreservations),
        requiredLogin: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Provider.of<DayProvider>(context).myreservation.isEmpty
              ? Center(
                  child: Text(appLocalization.noreservationavailable),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                      itemCount: Provider.of<DayProvider>(context)
                          .myreservation
                          .length,
                      itemBuilder: ((ctx, i) => ReservationItem(
                          Provider.of<DayProvider>(context)
                              .myreservation[i])))),
      drawer: const AppDrawer(),
    );
  }
}
