import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/modells/service_modell.dart';
import 'package:reservation_app/modells/appointment_modells.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:reservation_app/providers/auth.dart';
import 'package:intl/intl.dart';

import 'package:reservation_app/widgets/calendar/appointment.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});
  static const routerName = "/day";

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DateFormat dateFormat = DateFormat("yMMMMd");
  DateFormat timeFormat = DateFormat("Hm");
  bool _didRun = false;
  bool _isLoading = false;
  DateTime? date;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      date = ModalRoute.of(context)!.settings.arguments as DateTime;

      Provider.of<DayProvider>(context, listen: false)
          .loadDay(date!)
          .then((value) {
        setState(() {
          dateFormat = DateFormat(
              "yMMMMd", Localizations.localeOf(context).languageCode);
          timeFormat =
              DateFormat("Hm", Localizations.localeOf(context).languageCode);
          _isLoading = false;
          _didRun = true;
        });
      });
    }

    super.didChangeDependencies();
  }

  String capitalize(String string) {
    return string[0].toUpperCase() + string.substring(1);
  }

  void _showError(BuildContext context, String error) {
    final appLocalization = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(appLocalization.erroroccured),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  void _confirmReservation(
      Service serviceData, Appointment appointmentData) async {
    final appLocalization = AppLocalizations.of(context)!;
    final bool result = await showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              scrollable: true,
              title: Text(appLocalization.confirm),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalization.bookinginfo),
                      Text(
                          "${appLocalization.date}: ${dateFormat.format(date!)}"),
                      Text(
                          "${appLocalization.timeperiod}: ${timeFormat.format(appointmentData.starts)} - ${timeFormat.format(appointmentData.ends)}"),
                      Text(
                          "${appLocalization.servicename}: ${serviceData.name}"),
                      Text(
                          "${appLocalization.servicetype}: ${serviceData.type}"),
                      Text(
                          "${appLocalization.price}: ${serviceData.price} ${serviceData.comment} ft"),
                      Text(
                          "${appLocalization.duration}: ${serviceData.duration}"),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(appLocalization.finalquestionbooking),
                    ]),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(appLocalization.cancel)),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("OK")),
              ],
            )));
    if (result) {
      setState(() {
        _isLoading = true;
      });
      if (!mounted) return;
      await Provider.of<DayProvider>(context, listen: false)
          .submitReservation(appointmentData.id, serviceData);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void deleteReservation(int reservationId, int appointmentId) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<DayProvider>(context, listen: false)
        .deleteReservation(reservationId, appointmentId);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addAppontment(BuildContext context) async {
    final appLocalization = AppLocalizations.of(context)!;
    final TimeOfDay? startingTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: appLocalization.selectstarttime,
    );
    if (startingTime == null) return;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final TimeOfDay? endingTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: appLocalization.servicedescription);

    if (endingTime == null) return;
    if (endingTime.hour < startingTime.hour &&
        endingTime.minute <= startingTime.minute) {
      if (!mounted) return;
      _showError(context, appLocalization.startingtimeinval);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      if (!mounted) return;
      await Provider.of<DayProvider>(context, listen: false)
          .addAppointment(startingTime, endingTime);
    } catch (error) {
      if (error == "invalidtime") {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        _showError(context, appLocalization.invalidtimeererror);
        return;
      }

      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final day = Provider.of<DayProvider>(context).dayLoaded;
    final userAuth = Provider.of<UserAuth>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: day == null
          ? AppBar()
          : userAuth.isAuthenticatedAdmin
              ? AppBar(
                  title: Text(day.date
                          .isAfter(DateTime.now().add(const Duration(days: 6)))
                      ? dateFormat.format(day.date)
                      : capitalize(DateFormat.EEEE(
                              Localizations.localeOf(context).languageCode)
                          .format(day.date))),
                  actions: [
                    IconButton(
                        onPressed: () => _addAppontment(context),
                        icon: const Icon(Icons.add))
                  ],
                )
              : MyAppBar(
                  const [],
                  appbar: AppBar(),
                  title: Text(day.date
                          .isAfter(DateTime.now().add(const Duration(days: 6)))
                      ? dateFormat.format(day.date)
                      : capitalize(DateFormat.EEEE(
                              Localizations.localeOf(context).languageCode)
                          .format(day.date))),
                  requiredLogin: true,
                ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: ((context, i) => AppointmentItem(
                    day!.appointments[i],
                    _confirmReservation,
                    deleteReservation,
                    userAuth.isAuthenticatedAdmin)),
                itemCount: day == null ? 0 : day.appointments.length,
              ),
            ),
    );
  }
}
