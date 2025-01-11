import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/months.dart';
import 'package:reservation_app/modells/month_modell.dart';
import 'package:reservation_app/screens/day_screen.dart';

Future<DateTime?> _showDatePicker(
  BuildContext context,
  int id,
) async {
  final appLocalization = AppLocalizations.of(context)!;
  Month loadedMonth =
      await Provider.of<Months>(context, listen: false).getMonth(id);
  try {
    if (context.mounted) {
      return await showDatePicker(
        context: context,
        initialDate: loadedMonth.days
            .firstWhere((item) =>
                item.isWorkingDay == true && item.date.isAfter(DateTime.now()))
            .date,
        firstDate: loadedMonth.fromDate.isAfter(DateTime.now())
            ? loadedMonth.fromDate
            : DateTime.now(),
        lastDate: loadedMonth.toDate,
        selectableDayPredicate: (day) {
          if (loadedMonth.days
              .firstWhere((item) => day == item.date)
              .isWorkingDay) {
            return true;
          }
          return false;
        },
      );
    }
  } catch (error) {
    String errorText = error.toString();
    if (errorText == "Bad state: No element") {
      errorText = appLocalization.noavailableappointment;
    }
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(appLocalization.erroroccured),
                content: Text(errorText),
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
  return null;
}

class MonthPicker extends StatefulWidget {
  const MonthPicker({super.key});
  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Consumer<Months>(
          builder: (ctx, months, _) => ListView.builder(
              itemCount: months.awailableMonths.length,
              itemBuilder: (context, i) => MonhtButton(
                  months.awailableMonths[i].id,
                  DateFormat.MMMM(Localizations.localeOf(context).languageCode)
                      .format(months.awailableMonths[i].fromDate))),
        ));
  }
}

class MonhtButton extends StatelessWidget {
  final int id;
  final String name;

  const MonhtButton(this.id, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)))),
        child: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        onPressed: () {
          _showDatePicker(context, id).then((date) {
            if (date != null) {
              Navigator.of(context)
                  .pushNamed(DayScreen.routerName, arguments: date);
            }
          });
        });
  }
}
