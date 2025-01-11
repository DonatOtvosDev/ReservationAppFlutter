import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/widgets/calendar/month_picker.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/months.dart';
import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  static const routerName = "/calendar";

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _didRun = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Months>(context).fetchAndSetMonths().then((_) {
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
    return Scaffold(
      appBar: MyAppBar(
        const [],
        appbar: AppBar(),
        title: Text(AppLocalizations.of(context)!.calendar),
        requiredLogin: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [MonthPicker()],
            ),
      drawer: const AppDrawer(),
    );
  }
}
