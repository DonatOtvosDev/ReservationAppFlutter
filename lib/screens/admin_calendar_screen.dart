import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/providers/day.dart';
import 'package:reservation_app/providers/months.dart';
import 'package:provider/provider.dart';

import 'package:reservation_app/widgets/drawer.dart';

import 'package:reservation_app/widgets/calendar/working_day_grid_builder.dart';
import 'package:reservation_app/screens/day_screen.dart';

class CalendarScreenAdmin extends StatefulWidget {
  const CalendarScreenAdmin({super.key});
  static const routerName = "/admin_day";
  @override
  State<CalendarScreenAdmin> createState() => _CalendarScreenAdminState();
}

class _CalendarScreenAdminState extends State<CalendarScreenAdmin> {
  bool _didRun = false;
  bool _isLoading = false;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 180)));

    if (!mounted || datePicked == null) return;
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Months>(context, listen: false)
        .inacialiseMonth(datePicked.month, datePicked.year);

    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    Navigator.pushNamed(context, DayScreen.routerName, arguments: datePicked);
  }

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DayProvider>(context, listen: false)
          .fetchAndSetWorkingDays()
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
      appBar: AppBar(
        title: Text(appLocalization.calendar),
        actions: [
          ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: Text(appLocalization.choosedate),
              onPressed: () => _pickDate(context))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const WorkingDayGridBuilder(),
      drawer: const AppDrawer(),
    );
  }
}
