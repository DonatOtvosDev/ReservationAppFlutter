import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:reservation_app/screens/services_screen.dart';
import 'package:reservation_app/screens/calendar_screen.dart';
import 'package:reservation_app/screens/admin_calendar_screen.dart';
import 'package:reservation_app/screens/reservations_screen.dart';
import 'package:reservation_app/screens/about_me_screen.dart';
import 'package:reservation_app/screens/users_edit_screen.dart';

import 'package:reservation_app/providers/auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Consumer<UserAuth>(
        builder: (ctx, userAuth, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child!,
            if (userAuth.isAuthenticated)
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 0.25,
                height: 0.5,
              ),
            if (userAuth.isAuthenticated)
              TextButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: SizedBox(
                      width: double.infinity,
                      child: Text(appLocalization.calendar)),
                  onPressed: () => userAuth.isAuthenticatedAdmin
                      ? Navigator.of(context)
                          .pushReplacementNamed(CalendarScreenAdmin.routerName)
                      : Navigator.of(context)
                          .pushReplacementNamed(CalendarScreen.routerName)),
            if (userAuth.isAuthenticated && userAuth.isAuthenticatedAdmin)
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 0.25,
                height: 0.5,
              ),
            if (userAuth.isAuthenticated && userAuth.isAuthenticatedAdmin)
              TextButton.icon(
                  icon: const Icon(Icons.assignment_ind),
                  label: SizedBox(
                      width: double.infinity,
                      child: Text(appLocalization.editusers)),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(UsersScreen.routeName)),
            if (userAuth.isAuthenticated && !userAuth.isAuthenticatedAdmin)
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 0.25,
                height: 0.5,
              ),
            if (userAuth.isAuthenticated && !userAuth.isAuthenticatedAdmin)
              TextButton.icon(
                  icon: const Icon(Icons.query_builder),
                  label: SizedBox(
                      width: double.infinity,
                      child: Text(appLocalization.myreservations)),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(ReservationsScreen.routeName)),
          ],
        ),
        child: Column(children: [
          AppBar(
            title: Text(appLocalization.menu),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Divider(
            height: 10,
          ),
          TextButton.icon(
              icon: const Icon(Icons.home),
              label: SizedBox(
                  width: double.infinity, child: Text(appLocalization.home)),
              onPressed: () => Navigator.of(context).pushReplacementNamed("/")),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.25,
            height: 0.5,
          ),
          TextButton.icon(
              icon: const Icon(Icons.person),
              label: SizedBox(
                  width: double.infinity, child: Text(appLocalization.aboutme)),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AboutMeScreen.routerName);
              }),
          Divider(
            color: Theme.of(context).primaryColor,
            thickness: 0.25,
            height: 0.5,
          ),
          TextButton.icon(
              icon: const Icon(Icons.add),
              label: SizedBox(
                  width: double.infinity,
                  child: Text(appLocalization.services)),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(ServiceScreen.routeName)),
        ]),
      ),
    );
  }
}
