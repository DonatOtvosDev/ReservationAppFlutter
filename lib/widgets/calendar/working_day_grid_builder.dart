import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/day.dart';

import 'package:reservation_app/screens/day_screen.dart';

class WorkingDayGridBuilder extends StatelessWidget {
  const WorkingDayGridBuilder({super.key});
  String capitalize(String string) {
    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat =
        DateFormat("d-MMM-y", Localizations.localeOf(context).languageCode);
    return Container(
      padding: const EdgeInsets.all(12),
      alignment: Alignment.topCenter,
      child: Consumer<DayProvider>(
        builder: (ctx, dayProvider, _) => GridView.builder(
            itemCount: dayProvider.workingDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (ctx, i) => ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
                onPressed: () => Navigator.of(context)
                    .pushNamed(DayScreen.routerName,
                        arguments: dayProvider.workingDays[i].date)
                    .then((_) => dayProvider.resetDay()),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text((dayProvider.workingDays[i].date
                          .isBefore(DateTime.now().add(const Duration(days: 6)))
                      ? capitalize(DateFormat.EEEE(
                              Localizations.localeOf(context).languageCode)
                          .format(dayProvider.workingDays[i].date))
                      : dateFormat.format(dayProvider.workingDays[i].date))),
                ))),
      ),
    );
  }
}
